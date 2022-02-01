import 'dart:io';

import 'package:file_picker/file_picker.dart';
import "package:flutter/material.dart";
import 'package:skt/resources/firestore_methods.dart';
import 'package:skt/utils/utils.dart';

class AddTaxButtomSheet extends StatefulWidget {
  final BuildContext context;
  final String uid;
  const AddTaxButtomSheet({Key? key, required this.context, required this.uid})
      : super(key: key);

  @override
  _AddTaxButtomSheetState createState() => _AddTaxButtomSheetState();
}

class _AddTaxButtomSheetState extends State<AddTaxButtomSheet> {
  bool _isLoading = false;

  String date = "";
  DateTime selectedDate = DateTime.now();
  _selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2010),
      lastDate: DateTime(2025),
    );
    if (selected != null && selected != selectedDate)
      setState(() {
        selectedDate = selected;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(widget.context).size.height * 0.60,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const Text(
              "Add Tax",
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
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: "Tax Amount",
                                ),
                                onChanged: (value) {},
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: "Gain Amount",
                                ),
                                onChanged: (value) {},
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  _selectDate(context);
                                },
                                child: Container(
                                  child: const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      "From",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.blue,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  _selectDate(context);
                                },
                                child: Container(
                                  child: const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      "To",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.blue,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: () {},
                              child: Text("Save"),
                            )
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
