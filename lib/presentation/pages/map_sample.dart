import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapSample extends StatefulWidget {
  const MapSample({super.key});

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  CameraPosition _myLocation = CameraPosition(
    target: LatLng(32.0315505, 35.8625347),
    zoom: 14.4746,
  );

  static const CameraPosition _kLake = CameraPosition(
    bearing: 192.8334901395799,
    target: LatLng(32.0315505, 35.8625347),
    tilt: 59.440717697143555,
    zoom: 19.151926040649414,
  );

  Set<Marker> myMarkersSet = {
    Marker(
        markerId: MarkerId("1"),
        position: LatLng(31.973564, 35.909809),
        onTap: () => print("Sport City")),
    Marker(markerId: MarkerId("2"), position: LatLng(31.986305, 35.897967)),
  };

  double x = 0;
  double y = 0;
  late BitmapDescriptor icon;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _setCustomIcon();
    getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.satellite,
            initialCameraPosition: _myLocation,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            markers: myMarkersSet,
          ),
          Positioned(
              left: 10,
              top: 10,
              child: Container(
                height: 70,
                width: 200,
                child: TextField(
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                      fillColor: Colors.white,
                      filled: true),
                  onSubmitted: (val) async {
                    // Convert text -> coordinates
                    List<Location> locations = await locationFromAddress(val);

                    if (locations.isNotEmpty) {
                      final loc = locations.first;

                      final GoogleMapController controller =
                          await _controller.future;

                      final newPosition = CameraPosition(
                        target: LatLng(loc.latitude, loc.longitude),
                        zoom: 15,
                      );

                      // Move camera
                      controller.animateCamera(
                        CameraUpdate.newCameraPosition(newPosition),
                      );

                      // Optional: add marker
                      setState(() {
                        myMarkersSet.add(
                          Marker(
                            markerId: MarkerId(val),
                            position: LatLng(loc.latitude, loc.longitude),
                          ),
                        );
                      });
                    }
                  },
                ),
              )),
        ],
      ),
    );
  }

  Future<void> _setCustomIcon() async {
    icon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(devicePixelRatio: 2),
      // Adjust pixel ratio if needed
      'assets/icons/me.jpeg',
    );
  }

  Future<void> getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    Position myPosition = await Geolocator.getCurrentPosition();

    _myLocation = CameraPosition(
      target: LatLng(myPosition.latitude, myPosition.longitude),
      zoom: 14.4746,
    );

    myMarkersSet.add(Marker(
        markerId: MarkerId("me"),
        icon: icon,
        position: LatLng(myPosition.latitude, myPosition.longitude)));

    setState(() {});
  }
}
