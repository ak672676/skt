import 'dart:io';

import "package:flutter/material.dart";
import 'package:jiffy/jiffy.dart';
import 'package:skt/model/insurance.dart';

import 'package:skt/resources/firestore_methods.dart';
import 'package:skt/utils/utils.dart';

class AddInsuranceButtomSheet extends StatefulWidget {
  final BuildContext context;
  final String uid;
  final String vehicleNumber;
  Insurance? insurance;
  bool isEditMode;
  AddInsuranceButtomSheet({
    Key? key,
    required this.context,
    required this.uid,
    required this.vehicleNumber,
    this.isEditMode = false,
    this.insurance,
  }) : super(key: key);

  @override
  _AddInsuranceButtomSheetState createState() =>
      _AddInsuranceButtomSheetState();
}

class _AddInsuranceButtomSheetState extends State<AddInsuranceButtomSheet> {
  bool _isLoading = false;

  String date = "";
  DateTime startDate = DateTime.now();
  DateTime endDate = Jiffy().add(years: 1).dateTime;

  final TextEditingController insuranceAmount = TextEditingController();
  final TextEditingController gainAmount = TextEditingController();
  final TextEditingController description = TextEditingController();
  final TextEditingController valuation = TextEditingController();

  bool isActive = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.isEditMode) {
      startDate = widget.insurance!.startDate!;
      endDate = widget.insurance!.endDate!;
      insuranceAmount.text = widget.insurance!.insuranceAmount!.toString();
      gainAmount.text = widget.insurance!.gainAmount!.toString();
      valuation.text = widget.insurance!.valuation!.toString();
      description.text = widget.insurance!.description!;
      isActive = widget.insurance!.isActive!;
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    insuranceAmount.dispose();
    gainAmount.dispose();
    description.dispose();
    valuation.dispose();
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
        endDate = Jiffy(startDate).add(years: 1).dateTime;
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

  saveInsurance(BuildContext context) async {
    String err = "";

    if (insuranceAmount.text == null || insuranceAmount.text == "") {
      err += "Insurance amount is required\n";
    }
    if (gainAmount.text == null || gainAmount.text == "") {
      gainAmount.text = "0";
    }

    if (valuation.text == null || valuation.text == "") {
      valuation.text = "0";
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
      String res = await FirestoreMethods().addInsurance(
        widget.uid,
        widget.vehicleNumber,
        insuranceAmount.text,
        gainAmount.text,
        valuation.text,
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
        showSnackBar("Insurance added", widget.context);
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

  updateInsurance(BuildContext context) async {
    String err = "";

    print(widget.insurance!.uid);

    if (insuranceAmount.text == null || insuranceAmount.text == "") {
      err += "Insurancee amount is required\n";
    }
    if (gainAmount.text == null || gainAmount.text == "") {
      gainAmount.text = "0";
    }
    if (valuation.text == null || valuation.text == "") {
      valuation.text = "0";
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
      String res = await FirestoreMethods().updateInsurance(
        widget.insurance!.uid!,
        widget.uid,
        insuranceAmount.text,
        gainAmount.text,
        valuation.text,
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
        showSnackBar("Insurance updated", widget.context);
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
              widget.isEditMode ? "Update Insurance" : "Add Insurance",
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
                                  labelText: "Insurance Amount",
                                ),
                                controller: insuranceAmount,
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
                            const SizedBox(width: 15),
                            Expanded(
                              child: TextField(
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: "Valuation",
                                ),
                                // onChanged: (value) {
                                //   setState(() {
                                //     gainAmount = value;
                                //   });
                                // },
                                controller: valuation,
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
                                  updateInsurance(context);
                                } else {
                                  saveInsurance(context);
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
