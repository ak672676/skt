import 'dart:io';

import "package:flutter/material.dart";
import 'package:skt/model/vehicle.dart';
import 'package:file_picker/file_picker.dart';
import 'package:skt/utils/utils.dart';

class VehicleDetail extends StatefulWidget {
  final Vehicle? vehicle;

  const VehicleDetail({Key? key, this.vehicle}) : super(key: key);

  @override
  State<VehicleDetail> createState() => _VehicleDetailState();
}

class _VehicleDetailState extends State<VehicleDetail> {
  File? file;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Vehicle Detail"),
        ),
        body: Container(
          child: Column(
            children: [
              ElevatedButton(
                child: Text("Pick File"),
                onPressed: () async {
                  FilePickerResult? result = await FilePicker.platform
                      .pickFiles(
                          type: FileType.custom,
                          allowedExtensions: ['jpg', 'pdf', 'jpeg', 'png']);

                  if (result != null) {
                    File f = File(result.files.single.path!);
                    print(f.path);
                    setState(() {
                      file:
                      f;
                    });
                    showSnackBar(f.path, context);
                  } else {
                    // User canceled the picker
                  }
                },
              ),
            ],
          ),
        ));
  }
}
