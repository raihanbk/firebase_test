import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:permission_handler/permission_handler.dart';

class StorageHome extends StatefulWidget {
  const StorageHome({super.key});

  @override
  State<StorageHome> createState() => _StorageHomeState();
}

class _StorageHomeState extends State<StorageHome> {
  final storage = FirebaseStorage.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Storage'),
      ),
      body: Container(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                    onPressed: () async {
                      if (await Permission.camera.request().isGranted) {
                        open('camera');
                      } else {
                        print('Camera access Denied');
                      }
                    },
                    icon: const Icon(Icons.camera_alt_outlined)),
                IconButton(
                    onPressed: () async {
                      if (await Permission.storage.request().isGranted) {
                        open('gallery');
                      } else {
                        print('Request Denied');
                      }
                    },
                    icon: const Icon(Icons.browse_gallery_outlined)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> open(String imgSource) async {
    final imgPicker = ImagePicker();
    XFile? pickedImg;

    try {
      pickedImg = await imgPicker.pickImage(
          source:
              imgSource == 'camera' ? ImageSource.camera : ImageSource.gallery);
      final String imgFileName = path.basename(pickedImg!.path);
      File imgFile = File(pickedImg.path);

      try {
        await storage.ref(imgFileName).putFile(
            imgFile,
            SettableMetadata(customMetadata: {
              'uploadBy': 'example user',
              'time': '${DateTime.now().isUtc}'
            }));
      } on FirebaseException catch (e) {
        print('Exception Occurred while uploading: $e');
      }
    } catch (e) {
      print('Exception during fetching: $e');
    }
  }
}
