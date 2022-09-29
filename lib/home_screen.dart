import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final storage = FirebaseStorage.instance;
  bool isUploading = false;
  List<XFile> imageFileList = [];
  final ImagePicker imagePicker = ImagePicker();

  void uploadFile() async {
    isUploading = true;
    setState(() {});
    if (imageFileList.isNotEmpty) {
      for (var i = 0; i < imageFileList.length; i++) {
        File file = File(imageFileList[i].path);
        try {
          await storage
              .ref()
              .child('images/${imageFileList[i].name}')
              .putFile(file);
        } catch (e) {
          print('error');
        }
      }
      imageFileList = [];
      isUploading = false;
      setState(() {});
    }
  }

  void selectImages() async {
    final List<XFile>? selectedImages = await imagePicker.pickMultiImage();
    if (selectedImages != null) {
      imageFileList.addAll(selectedImages);
    }
    setState(() {});
  }

  _removeImage(int index) {
    if (isUploading) {
      return () {};
    } else {
      return () {
        imageFileList.removeAt(index);
        setState(() {});
      };
    }
  }

  _addImage() {
    if (isUploading) {
      return () {};
    } else {
      return () => selectImages();
    }
  }

  _uploadImage() {
    if (isUploading) {
      return () {};
    } else {
      return () => uploadFile();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upload Images'), actions: [
        IconButton(
            onPressed: () => Navigator.pushNamed(context, '/showImage'),
            icon: const Icon(Icons.photo_library_outlined)),
        IconButton(onPressed: _uploadImage(), icon: const Icon(Icons.upload))
      ]),
      body: Stack(children: [
        GridView.builder(
            itemCount: imageFileList.length + 1,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisSpacing: 5, crossAxisSpacing: 5, crossAxisCount: 3),
            itemBuilder: (BuildContext context, int index) {
              if (imageFileList.isEmpty ||
                  index > (imageFileList.length - 1) &&
                      imageFileList.length < 10) {
                return SizedBox(
                    height: 10,
                    width: 10,
                    child: IconButton(
                        onPressed: _addImage(), icon: const Icon(Icons.add)));
              } else if (index <= imageFileList.length - 1) {
                return Stack(children: [
                  SizedBox(
                      height: double.infinity,
                      width: double.infinity,
                      child: Image.file(File(imageFileList[index].path),
                          fit: BoxFit.fill)),
                  Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                          onPressed: _removeImage(index),
                          icon: const Icon(Icons.cancel),
                          color: Colors.red))
                ]);
              } else {
                return const SizedBox();
              }
            }),
        if (isUploading)
          Center(
            child: Container(
              height: 150,
              width: 150,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20), color: Colors.white),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    CircularProgressIndicator.adaptive(),
                    SizedBox(height: 10),
                    Text("Uploading...",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20))
                  ]),
            ),
          ),
      ]),
    );
  }
}
