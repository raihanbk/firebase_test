import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
        title: const Text('Image Storage'),
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
            const SizedBox(
              height: 30,
            ),
            Expanded(
              child: FutureBuilder(
                  future: fetchImg(),
                  builder: (context, snapshot) {
                    return GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                childAspectRatio: 0.6, crossAxisCount: 2),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final img = snapshot.data![index];
                          return Card(
                            child: Column(
                              children: [
                                Expanded(
                                    child: Image.network(
                                  img['image'],
                                  fit: BoxFit.cover,
                                )),
                                Text(img['picture by']),
                                Text(img['time']),
                                IconButton(
                                    onPressed: () {
                                      deleteImg(img['path']);
                                    }, icon: Icon(Icons.delete))
                              ],
                            ),
                          );
                        });
                  }),
            )
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

  Future<List<Map<String, dynamic>>> fetchImg() async {
    List<Map<String, dynamic>> images = [];

    //ListResult class holds the list of values and its metadata as a result of listAll
    final ListResult result = await storage.ref().list();
    //reference of each item stored in firebase storage
    final List<Reference> allFiles = result.items;

    await Future.forEach(allFiles, (single) async {
      final String fileUrl = await single.getDownloadURL();
      final FullMetadata metadata = await single.getMetadata();

      images.add({
        'image': fileUrl,
        'path': single.fullPath,
        'picture by': metadata.customMetadata?['uploadBy'],
        'time': metadata.customMetadata?['time'],
      });
    });
    return images;
  }

  void deleteImg(String img) async{
    await storage.ref(img).delete();
    setState(() {

    });
  }
}
