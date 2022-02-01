import 'dart:io';

import 'package:file_picker/file_picker.dart';
import "package:flutter/material.dart";
import 'package:skt/resources/firestore_methods.dart';
import 'package:skt/utils/utils.dart';

class ButtonSheet extends StatefulWidget {
  final BuildContext context;
  final String uid;
  const ButtonSheet({Key? key, required this.context, required this.uid})
      : super(key: key);

  @override
  _ButtonSheetState createState() => _ButtonSheetState();
}

class _ButtonSheetState extends State<ButtonSheet> {
  File? fileToSave;
  String? fileName;
  String? fileDescription;
  String? selectedFileType = "jpg";
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(widget.context).size.height * 0.60,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const Text(
              "Add File",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            _isLoading
                ? const LinearProgressIndicator()
                : Expanded(
                    child: Column(
                      children: [
                        TextField(
                          decoration: const InputDecoration(
                            labelText: "File Description",
                          ),
                          onChanged: (String value) {
                            setState(() {
                              fileDescription = value;
                            });
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            DropdownButton<String>(
                              hint: Text('Select a file type'),
                              underline: SizedBox(),
                              value: selectedFileType,
                              items: <String>['jpg', 'pdf', 'jpeg', 'png']
                                  .map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                if (newValue != null) {
                                  setState(() {
                                    selectedFileType = newValue;
                                  });
                                  setState(() {
                                    fileName = null;
                                  });
                                  setState(() {
                                    fileToSave = null;
                                  });
                                }
                              },
                            ),
                            ElevatedButton(
                              child: Text("Pick File"),
                              onPressed: () async {
                                FilePickerResult? result =
                                    await FilePicker.platform.pickFiles(
                                  type: FileType.custom,
                                  allowedExtensions: [
                                    selectedFileType!,
                                  ],
                                );

                                if (result != null) {
                                  setState(() {
                                    fileName = result.files.first.name;
                                  });
                                  // showSnackBar(f.path, context);

                                  final path = result.files.first.path!;
                                  setState(() {
                                    fileToSave = File(path);
                                  });
                                } else {
                                  // User canceled the picker
                                }
                                // Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(fileName ?? "No file selected"),
                            ElevatedButton(
                              child: Text("Save"),
                              onPressed: () async {
                                if (fileName == null ||
                                    fileDescription == null ||
                                    fileToSave == null) {
                                  Navigator.pop(context);
                                  showSnackBar("Please give all the input",
                                      widget.context);
                                  return;
                                }
                                setState(() {
                                  _isLoading = true;
                                });
                                try {
                                  // String res = await StorageMethod()
                                  //     .uploadImageToStorage(fileName!,
                                  //         selectedFileType!, fileToSave!);
                                  String res = await FirestoreMethods()
                                      .addNewDocument(
                                          widget.uid,
                                          fileDescription!,
                                          fileName!,
                                          selectedFileType!,
                                          fileToSave!);
                                  if (res == "success") {
                                    setState(() {
                                      _isLoading = false;
                                    });
                                    Navigator.pop(context);
                                    showSnackBar(
                                        "Added Document", widget.context);
                                  } else {
                                    setState(() {
                                      _isLoading = false;
                                    });
                                    showSnackBar(res, context);
                                  }
                                } catch (err) {
                                  showSnackBar(err.toString(), context);
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
