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

  String? taxAmount;
  String? gainAmount;
  String? description;
  String date = "";
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();

  _selectDate(BuildContext context, String dateType) async {
    if (dateType == "start") {
      final DateTime? selected = await showDatePicker(
        context: context,
        initialDate: startDate,
        firstDate: DateTime(2010),
        lastDate: DateTime(2025),
      );

      setState(() {
        startDate = selected!;
      });
    }
    if (dateType == "end") {
      final DateTime? selected = await showDatePicker(
        context: context,
        initialDate: endDate,
        firstDate: DateTime(2010),
        lastDate: DateTime(2025),
      );

      setState(() {
        endDate = selected!;
      });
    }
  }

  saveTax(BuildContext context) async {
    String err = "";

    if (taxAmount == null || taxAmount == "") {
      err += "Tax amount is required\n";
    }
    if (gainAmount == null || gainAmount == "") {
      gainAmount = "0";
    }
    if (description == null) {
      description = "";
    }
    if ((startDate.day == endDate.day) &&
        (startDate.month == endDate.month) &&
        (startDate.year == endDate.year)) {
      err += "Start and End dates are same\n";
    }
    if (err != "") {
      Navigator.pop(context);
      showSnackBar(err, context);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      String res = await FirestoreMethods().addTax(
        widget.uid,
        taxAmount!,
        gainAmount!,
        description!,
        startDate,
        endDate,
      );
      if (res == "success") {
        setState(() {
          _isLoading = false;
        });
        Navigator.pop(context);
        showSnackBar("Added Document", widget.context);
      } else {
        setState(() {
          _isLoading = false;
        });
        showSnackBar(res, context);
      }
    } catch (e) {
      showSnackBar(err.toString(), context);
    }
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
                                onChanged: (value) {
                                  setState(() {
                                    taxAmount = value;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: TextField(
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: "Gain Amount",
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    gainAmount = value;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                decoration: const InputDecoration(
                                  labelText: "Description",
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    description = value;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  _selectDate(context, "start");
                                },
                                child: Container(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        Text(
                                          startDate.day.toString() +
                                              "/" +
                                              startDate.month.toString() +
                                              "/" +
                                              startDate.year.toString(),
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const Text(
                                          "From",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 15,
                                          ),
                                        ),
                                      ],
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
                                  _selectDate(context, "end");
                                },
                                child: Container(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        Text(
                                          endDate.day.toString() +
                                              "/" +
                                              endDate.month.toString() +
                                              "/" +
                                              endDate.year.toString(),
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const Text(
                                          "To",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 15,
                                          ),
                                        ),
                                      ],
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
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                saveTax(context);
                              },
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
