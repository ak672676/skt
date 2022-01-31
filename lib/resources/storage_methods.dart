import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import "package:flutter/material.dart";
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
}
