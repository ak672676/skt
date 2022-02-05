import 'dart:io';

import 'package:file_picker/file_picker.dart';
import "package:flutter/material.dart";
import 'package:skt/model/tax.dart';
import 'package:skt/resources/firestore_methods.dart';
import 'package:skt/utils/utils.dart';

class AddTaxButtomSheet extends StatefulWidget {
  final BuildContext context;
  final String uid;
  final String vehicleNumber;
  Tax? tax;
  bool isEditMode;
  AddTaxButtomSheet({
    Key? key,
    required this.context,
    required this.uid,
    required this.vehicleNumber,
    this.isEditMode = false,
    this.tax,
  }) : super(key: key);

  @override
  _AddTaxButtomSheetState createState() => _AddTaxButtomSheetState();
}

class _AddTaxButtomSheetState extends State<AddTaxButtomSheet> {
  bool _isLoading = false;

  // String? taxAmount;
  // String? gainAmount;
  // String? description;
  String date = "";
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();

  final TextEditingController taxAmount = TextEditingController();
  final TextEditingController gainAmount = TextEditingController();
  final TextEditingController description = TextEditingController();
  bool isActive = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.isEditMode) {
      startDate = widget.tax!.startDate!;
      endDate = widget.tax!.endDate!;
      taxAmount.text = widget.tax!.taxAmount!.toString();
      gainAmount.text = widget.tax!.gainAmount!.toString();
      description.text = widget.tax!.description!;
      isActive = widget.tax!.isActive!;
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    taxAmount.dispose();
    gainAmount.dispose();
    description.dispose();
  }

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
        lastDate: DateTime(2099),
      );

      setState(() {
        endDate = selected!;
      });
    }
  }

  saveTax(BuildContext context) async {
    String err = "";

    if (taxAmount.text == null || taxAmount.text == "") {
      err += "Tax amount is required\n";
    }
    if (gainAmount.text == null || gainAmount.text == "") {
      gainAmount.text = "0";
    }
    if (description.text == null) {
      description.text = "";
    }
    if ((startDate.day == endDate.day) &&
        (startDate.month == endDate.month) &&
        (startDate.year == endDate.year)) {
      err += "Start and End dates are same\n";
    }

    if (startDate.toUtc().millisecondsSinceEpoch >
        endDate.toUtc().millisecondsSinceEpoch) {
      err += "End Date before start date\n";
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
        widget.vehicleNumber,
        taxAmount.text,
        gainAmount.text,
        description.text,
        startDate,
        endDate,
        isActive,
      );
      if (res == "success") {
        setState(() {
          _isLoading = false;
        });
        Navigator.pop(context);
        showSnackBar("Tax added", widget.context);
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

  updateTax(BuildContext context) async {
    print("updateTax");
    String err = "";

    print(widget.tax!.uid);

    if (taxAmount.text == null || taxAmount.text == "") {
      err += "Tax amount is required\n";
    }
    if (gainAmount.text == null || gainAmount.text == "") {
      gainAmount.text = "0";
    }
    if (description.text == null) {
      description.text = "";
    }
    if ((startDate.day == endDate.day) &&
        (startDate.month == endDate.month) &&
        (startDate.year == endDate.year)) {
      err += "Start and End dates are same\n";
    }

    if (startDate.toUtc().millisecondsSinceEpoch >
        endDate.toUtc().millisecondsSinceEpoch) {
      err += "End Date before start date\n";
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
      String res = await FirestoreMethods().updateTax(
        widget.tax!.uid!,
        widget.uid,
        taxAmount.text,
        gainAmount.text,
        description.text,
        startDate,
        endDate,
        isActive,
      );
      if (res == "success") {
        setState(() {
          _isLoading = false;
        });
        Navigator.pop(context);
        showSnackBar("Tax updated", widget.context);
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
            Text(
              widget.isEditMode ? "Update Tax" : "Add Tax",
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
                                // onChanged: (value) {
                                //   setState(() {
                                //     taxAmount = value;
                                //   });
                                // },

                                controller: taxAmount,
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: TextField(
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: "Gain Amount",
                                ),
                                // onChanged: (value) {
                                //   setState(() {
                                //     gainAmount = value;
                                //   });
                                // },
                                controller: gainAmount,
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
                                // onChanged: (value) {
                                //   setState(() {
                                //     description = value;
                                //   });
                                // },
                                controller: description,
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
                            Switch(
                                value: isActive,
                                onChanged: (value) {
                                  setState(() {
                                    isActive = value;
                                  });
                                }),
                            ElevatedButton(
                              onPressed: () {
                                if (widget.isEditMode) {
                                  updateTax(context);
                                } else {
                                  saveTax(context);
                                }
                              },
                              child:
                                  Text(widget.isEditMode ? "Update" : "Save"),
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
