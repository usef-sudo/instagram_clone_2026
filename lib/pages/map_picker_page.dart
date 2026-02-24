import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:map_picker/map_picker.dart';
import 'package:geocoding/geocoding.dart';

class MyMapPickerPage extends StatefulWidget {
  const MyMapPickerPage({Key? key}) : super(key: key);

  @override
  _MyMapPickerPageState createState() => _MyMapPickerPageState();
}

class _MyMapPickerPageState extends State<MyMapPickerPage> {
  final _controller = Completer<GoogleMapController>();
  MapPickerController mapPickerController = MapPickerController();

  CameraPosition cameraPosition = const CameraPosition(
    target: LatLng(41.311158, 69.279737),
    zoom: 14.4746,
  );

  var textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Column(
            children: [
              Container(
                height: MediaQuery.of(context).viewPadding.top,
                color: Colors.white,
              ),
              Container(
                height: 500,
                width: MediaQuery.of(context).size.width - 50,
                color: Colors.white,
                child: TextFormField(
                  maxLines: 3,
                  textAlign: TextAlign.center,
                  readOnly: true,
                  decoration: const InputDecoration(
                      contentPadding: EdgeInsets.zero,
                      border: InputBorder.none),
                  controller: textController,
                ),
              ),
              Expanded(
                child: Container(
                  width: 300,
                  child: MapPicker(
                    // pass icon widget
                    iconWidget: Icon(
                      Icons.pin_drop_outlined,
                      size: 60,
                    ),
                    //add map picker controller
                    mapPickerController: mapPickerController,
                    child: GoogleMap(
                      myLocationEnabled: true,
                      zoomControlsEnabled: false,
                      // hide location button
                      myLocationButtonEnabled: false,
                      mapType: MapType.normal,
                      //  camera position
                      initialCameraPosition: cameraPosition,
                      onMapCreated: (GoogleMapController controller) {
                        _controller.complete(controller);
                      },
                      onCameraMoveStarted: () {
                        // notify map is moving
                        mapPickerController.mapMoving!();
                        textController.text = "checking ...";
                      },
                      onCameraMove: (cameraPosition) {
                        this.cameraPosition = cameraPosition;
                      },
                      onCameraIdle: () async {
                        // notify map stopped moving
                        mapPickerController.mapFinishedMoving!();
                        //get address name from camera position
                        List<Placemark> placemarks =
                            await placemarkFromCoordinates(
                          cameraPosition.target.latitude,
                          cameraPosition.target.longitude,
                        );

                        // update the ui with the address
                        textController.text =
                            '${placemarks.first.name}, ${placemarks.first.administrativeArea}, ${placemarks.first.country}';
                      },
                    ),
                  ),
                ),
              ),
              Container(
                height: MediaQuery.of(context).viewPadding.top,
                color: Colors.white,
              ),
              Container(
                height: 50,
                width: MediaQuery.of(context).size.width - 50,
                color: Colors.white,
                child: TextFormField(
                  maxLines: 3,
                  textAlign: TextAlign.center,
                  readOnly: true,
                  decoration: const InputDecoration(
                      contentPadding: EdgeInsets.zero,
                      border: InputBorder.none),
                  controller: textController,
                ),
              ),
            ],
          ),
          Positioned(
            top: MediaQuery.of(context).viewPadding.top + 20,
            width: MediaQuery.of(context).size.width - 50,
            height: 50,
            child: TextFormField(
              maxLines: 3,
              textAlign: TextAlign.center,
              readOnly: true,
              decoration: const InputDecoration(
                  contentPadding: EdgeInsets.zero, border: InputBorder.none),
              controller: textController,
            ),
          ),
          Positioned(
            bottom: 24,
            left: 24,
            right: 24,
            child: SizedBox(
              height: 50,
              child: TextButton(
                child: const Text(
                  "Submit",
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    color: Color(0xFFFFFFFF),
                    fontSize: 19,
                    // height: 19/19,
                  ),
                ),
                onPressed: () {
                  print(
                      "Location ${cameraPosition.target.latitude} ${cameraPosition.target.longitude}");
                  print("Address: ${textController.text}");
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(const Color(0xFFA3080C)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
