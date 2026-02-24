import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_picker/map_picker.dart';
import 'package:geocoding/geocoding.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

class AddScreen extends StatefulWidget {
  AddScreen({super.key});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final _titleController = TextEditingController();

  final _discController = TextEditingController();

  final _imageController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  XFile? _pickedGalleryImage;

  XFile? _pickedCameraImage;
  String imageTag = "";
  Future<String?> uploadToCloudinary(File imageFile) async {
    const cloudName = 'di0u3tcx5';
    const uploadPreset = 'yousef';

    final request = http.MultipartRequest(
        'POST',
        Uri.parse(
          'https://api.cloudinary.com/v1_1/$cloudName/image/upload',
        ));

    request.fields['upload_preset'] = uploadPreset;

    request.files.add(
      await http.MultipartFile.fromPath('file', imageFile.path),
    );

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();
    final decoded = json.decode(responseBody);

    if (response.statusCode == 200) {
      return decoded['secure_url'];
    } else {
      throw Exception(decoded['error']['message']);
    }
  }

  final _controller = Completer<GoogleMapController>();
  MapPickerController mapPickerController = MapPickerController();

  CameraPosition cameraPosition = const CameraPosition(
    target: LatLng(41.311158, 69.279737),
    zoom: 14.4746,
  );

  Interpreter? _interpreter;
  List<String> labels = [];
  @override
  void initState() {
    initTfModel();
    // TODO: implement initState
    super.initState();
  }

  void initTfModel() async {
    try {
      _interpreter = await Interpreter.fromAsset('assets/mymodel.tflite');
      final labelData = await rootBundle.loadString('assets/labels.txt');
      labels = labelData.split('\n').where((label) => label.trim().isNotEmpty).toList();
      print('Model loaded successfully');
      print('Labels count: ${labels.length}');
    } catch (e) {
      print('Error loading model: $e');
    }
  }

  Future<String> classifyImage(File file) async {
    try {
      final bytes = await file.readAsBytes();
      img.Image? image = img.decodeImage(bytes);

      if (image == null) {
        return "Unknown (0%)";
      }

      // Resize image to 224x224
      img.Image resized = img.copyResize(image, width: 224, height: 224);

      // Get actual dimensions
      int width = resized.width;
      int height = resized.height;

      var input = List.generate(
        1, (_) => List.generate(
        height, (y) => List.generate(
        width, (x) {
        // Use getPixel method which is safer and handles bounds checking
        img.Pixel pixel = resized.getPixel(x, y);
        
        // Extract RGB components from the pixel value
        int r = pixel.r.toInt();
        int g = pixel.g.toInt();
        int b = pixel.b.toInt();

        // Normalize RGB values to [0, 1]
        return [
          r / 255.0,
          g / 255.0,
          b / 255.0,
        ];
      },
      ),
      ),
      );

      // Get the actual output shape from the interpreter
      var outputTensor = _interpreter!.getOutputTensor(0);
      var outputShape = outputTensor.shape;
      int outputSize = outputShape[outputShape.length - 1]; // Get the last dimension (number of classes)
      
      var output = List.generate(
          1, (_) => List.filled(outputSize, 0.0)
      );

      _interpreter!.run(input, output);

      int maxIndex = 0;
      double maxScore = 0;

      for (int i = 0; i < output[0].length; i++) {
        if (output[0][i] > maxScore) {
          maxScore = output[0][i];
          maxIndex = i;
        }
      }

      // Ensure maxIndex is within bounds of labels array
      if (maxIndex >= labels.length) {
        return "Unknown (${(maxScore * 100).toStringAsFixed(2)}%)";
      }

      return "${labels[maxIndex]} (${(maxScore * 100).toStringAsFixed(2)}%)";

    } catch (e) {
      print('Classification error: $e');
      return "Classification failed";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter Title',
              ),
              controller: _titleController,
            ),
            SizedBox(
              height: 8,
            ),
            TextField(
              maxLines: 4,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter Discription',
              ),
              controller: _discController,
            ),
            SizedBox(
              height: 8,
            ),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Image Link',
              ),
              controller: _imageController,
            ),
            SizedBox(
              height: 18,
            ),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email',
              ),
              controller: _emailController,
            ),
            SizedBox(
              height: 18,
            ),
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'phone number',
                hint: Text("+9627XXXXXXXX"),
              ),
              controller: _phoneController,
            ),
            SizedBox(
              height: 18,
            ),
            Row(
              children: [
                Expanded(child: Divider()),
                Text("OR"),
                Expanded(child: Divider()),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Center(
                  child: IconButton(
                      onPressed: () async {
                        showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return Container(
                                height: 120,
                                child: Column(
                                  children: [
                                    ListTile(
                                      leading: Icon(Icons.camera_alt),
                                      title: Text("Camera"),
                                      onTap: () async {
                                        final ImagePicker _picker =
                                            ImagePicker();
                                        _pickedCameraImage =
                                            await _picker.pickImage(
                                                source: ImageSource.camera);
                                        setState(() {});
                                        Navigator.pop(context);
                                      },
                                    ),
                                    ListTile(
                                      leading: Icon(Icons.photo_library),
                                      title: Text("Gallery"),
                                      onTap: () async {
                                        final ImagePicker _picker =
                                            ImagePicker();
                                        _pickedGalleryImage =
                                            await _picker.pickImage(
                                                source: ImageSource.gallery);
                                        setState(() {});
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                ),
                              );
                            });
                      },
                      icon: _pickedGalleryImage == null
                          ? Icon(
                              Icons.image,
                              size: 150,
                            )
                          : Image.file(
                              File(_pickedGalleryImage!.path),
                              height: 150,
                              width: 150,
                              fit: BoxFit.cover,
                            )),
                ),
                Center(
                  child: Container(
                    width: 240,
                    height: 200,
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

                          '${placemarks.first.name}, ${placemarks.first.administrativeArea}, ${placemarks.first.country}';
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 60,
            ),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  try {
                    imageTag =
                        await classifyImage(File(_pickedGalleryImage!.path));

                    String? imageurl;
                    // 1️1 Get user UID
                    final prefs = await SharedPreferences.getInstance();
                    final String userUid = prefs.getString("userUid")!;
                    // 2 Get image url
                    if (_pickedGalleryImage != null) {
                      imageurl = await uploadToCloudinary(
                          File(_pickedGalleryImage!.path));
                    }

                    // 3 Save post to Firestore
                    await FirebaseFirestore.instance.collection("Posts").add({
                      "title": _titleController.text.trim(),
                      "discription": _discController.text.trim(),
                      "image": imageurl ?? _imageController.text,
                      "date": Timestamp.now(),
                      "likes": 0,
                      "comments": 0,
                      "userUid": userUid,
                      "email": _emailController.text.trim(),
                      "phone": _phoneController.text.trim(),
                      "latitude": cameraPosition.target.latitude,
                      "longitude": cameraPosition.target.longitude,
                      "tag": imageTag
                    });

                    // 4 Clear UI
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Post Added Successfully")),
                    );

                    _titleController.clear();
                    _discController.clear();
                    _imageController.clear();
                    _pickedGalleryImage = null;
                    setState(() {});
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Error: $e")),
                    );
                  }
                },
                child: const Text('Add Post'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
