import "package:flutter/material.dart";
import 'package:skt/model/vehicle.dart';
import 'package:skt/resources/firestore_methods.dart';
import 'package:skt/utils/utils.dart';
import 'package:skt/widget/navigation_drawer_widget.dart';
// import 'package:validate/validate.dart';

class CreateVehicle extends StatefulWidget {
  const CreateVehicle({Key? key}) : super(key: key);

  @override
  State<CreateVehicle> createState() => _CreateVehicleState();
}

class _CreateVehicleState extends State<CreateVehicle> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  bool _isLoading = false;
  Vehicle vehicle = new Vehicle();

  //Date Picker
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
  void initState() {
    // TODO: implement initState
    super.initState();
    vehicle.vehicleType = '2 wheeler';
  }

  void submit() {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    // print(vehicle.toJson());
    // FirestoreMethods().addNewVehicle(vehicle);
    saveVehicle(vehicle);
    // _formKey.currentState!.reset();
    // _formKey.currentState!.save();
  }

  void saveVehicle(Vehicle vehicle) async {
    setState(() {
      _isLoading = true;
    });
    try {
      String res = await FirestoreMethods().addNewVehicle(vehicle);

      if (res == "success") {
        setState(() {
          _isLoading = false;
        });
        showSnackBar("Vehicle added", context);
        // clearImage();
      } else {
        setState(() {
          _isLoading = false;
        });
        showSnackBar(res, context);
      }
    } catch (err) {
      showSnackBar(err.toString(), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text("Create Vehicle"),
      ),
      body: _isLoading
          ? const LinearProgressIndicator()
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Container(
                margin: EdgeInsets.only(top: 10.0),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                            hintText: 'Vehicle Number',
                            labelText: 'Vehicle Number'),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter a vehicle number';
                          }
                          return null;
                        },
                        onChanged: (value) => vehicle.vehicleNumber = value,
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10.0),
                        child: DropdownButton<String>(
                          hint: Text('Select a vehicle '),
                          underline: SizedBox(),
                          value: vehicle.vehicleType,
                          // icon: Icon(
                          //   Icons.,
                          //   color: Colors.black,
                          // ),
                          items: <String>[
                            '2 wheeler',
                            '3 wheeler',
                            '4 wheeler',
                            'Truck',
                            'Others'
                          ].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),

                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              setState(() {
                                vehicle.vehicleType = newValue;
                              });
                            }
                          },
                        ),
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                            hintText: 'Owner', labelText: 'Owner name'),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter owner name';
                          }
                          return null;
                        },
                        onChanged: (value) => vehicle.ownerName = value,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                            hintText: 'Contact Number',
                            labelText: 'Contact number'),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter owner contact';
                          }
                          return null;
                        },
                        onChanged: (value) => vehicle.ownerContact = value,
                      ),
                      // Row(
                      //   children: [
                      //     Container(
                      //       child: ElevatedButton(
                      //         child: const Text(
                      //           'Start Date',
                      //           style: TextStyle(color: Colors.white),
                      //         ),
                      //         onPressed: () {
                      //           _selectDate(context);
                      //         },
                      //       ),
                      //       margin: const EdgeInsets.only(top: 20.0),
                      //     ),
                      //     Container(
                      //       child: ElevatedButton(
                      //         child: const Text(
                      //           'Start Date',
                      //           style: TextStyle(color: Colors.white),
                      //         ),
                      //         onPressed: submit,
                      //       ),
                      //       margin: const EdgeInsets.only(top: 20.0),
                      //     ),
                      //   ],
                      // ),
                      Container(
                        width: screenSize.width,
                        child: ElevatedButton(
                          child: const Text(
                            'Save',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: submit,
                        ),
                        margin: const EdgeInsets.only(top: 20.0),
                      )
                    ],
                  ),
                ),
              ),
            ),
      drawer: NavigationDrawerWidget(),
    );
  }
}
