import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_v2/tflite_v2.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // variable to store the selected image
  File? _image;
// variable to store the output of image classification
  List? _output;

// method to capture an image
  void captureImage() async {
    // create an image picker instance
    final picker = ImagePicker();
    // capture image from camera
    var image = await picker.pickImage(source: ImageSource.camera);

    // update the UI with the captured image
    setState(() {
      // store the captured image file
      _image = File(image!.path);
    });
    // call method to classify the captured image
    classifyImage(_image!);
  }

  // method to upload an image
  void uploadImage() async {
    // create an image picker instance
    final picker = ImagePicker();
    // get image from gallery
    var image = await picker.pickImage(source: ImageSource.gallery);

    // update the UI with the image
    setState(() {
      // store the image file
      _image = File(image!.path);
    });
    // call method to classify the image
    classifyImage(_image!);
  }

  // method to load the TFLite model
  Future<void> loadModel() async {
    await Tflite.loadModel(
      model: "assets/model_unquant.tflite",
      labels: "assets/labels.txt",
    );
  }

  // method to classify the image using TFLite model
  classifyImage(File image) async {
    var output = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 1,
      threshold: 0.5,
      imageMean: 127,
    );
    if (output == null) return;
    // update the UI with the classification output
    setState(() {
      // store the classification output
      _output = output;
    });
  }

  @override
  void initState() {
    // load the TFLite model when the widget initializes
    loadModel();
    super.initState();
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // container widget for background gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.lightGreen.shade50,
                  Colors.green.shade900,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Select Image for Detection",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 80,
              ),
              Column(
                children: [
                  SizedBox(
                    height: 200,
                    child: _image != null
                        ? Image.file(_image!)
                        : Container(
                            color: Colors.grey.shade50,
                            width: 250,
                            height: 250,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.image),
                                Text(
                                  'Select Photo',
                                  style: TextStyle(color: Colors.grey.shade400),
                                ),
                              ],
                            ),
                          ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  _output != null && _output!.isNotEmpty && _image != null
                      ? Text(
                          "${_output![0]['label']}") // display classification output if available
                      : _image != null
                          ? const Text(
                              "Retake Photo", // display message to retake photo if classification failed
                              style: TextStyle(color: Colors.red),
                            )
                          : Container(), // display an empty container if no image is selected
                ],
              ),
              const SizedBox(
                height: 25,
              ),
              // column widget to arrange buttons vertically
              Center(
                child: Column(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size(200, 50),
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        elevation: 3,
                      ),
                      onPressed: uploadImage,
                      child: const Text("Upload Photo",
                          style: TextStyle(color: Colors.black)),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size(200, 50),
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        elevation: 3,
                      ),
                      onPressed: captureImage,
                      child: const Text(
                        "Take Photo",
                        style: TextStyle(color: Colors.black),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
