import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import "package:flutter/material.dart";
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class StorageMethod {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadImageToStorage(
      String fileName, String fileType, File file) async {
    String res = "Some error occoured";
    Reference ref = _storage.ref().child("$fileType/$fileName");

    UploadTask uploadTask = ref.putFile(
      file,
    );

    try {
      TaskSnapshot snap = await uploadTask;
      String downloadUrl = await snap.ref.getDownloadURL();
      res = downloadUrl;
    } catch (e) {
      res = "Error";
    }
    return res;
  }

  static Future downloadFile(Reference ref) async {
    // final ref = FirebaseStorage.instance.ref().child(url);

    // print('Downloading $url');
    // print('Downloading ${ref}');
    // final dir = await getApplicationDocumentsDirectory();
    // print('Downloading ${dir.path}');
    // print('Downloading ${ref.name}');
    // final file = File('${dir.path}/${ref.name}');
    // print("-----------------> ${file.path}");
    // await ref.writeToFile(file);

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/${ref.name}');

    await ref.writeToFile(file);
  }
}

// Future<void> downloadFile(StorageReference ref) async {
//   final String url = await ref.getDownloadURL();
//   final http.Response downloadData = await http.get(url);
//   final Directory systemTempDir = Directory.systemTemp;
//   final File tempFile = File('${systemTempDir.path}/tmp.jpg');
//   if (tempFile.existsSync()) {
//     await tempFile.delete();
//   }
//   await tempFile.create();
//   final StorageFileDownloadTask task = ref.writeToFile(tempFile);
//   final int byteCount = (await task.future).totalByteCount;
//   var bodyBytes = downloadData.bodyBytes;
//   final String name = await ref.getName();
//   final String path = await ref.getPath();
//   print(url);
//   _scaffoldKey.currentState.showSnackBar(
//     SnackBar(
//       backgroundColor: Colors.white,
//       content: Image.memory(
//         bodyBytes,
//         fit: BoxFit.fill,
//       ),
//     ),
//   );
// }
