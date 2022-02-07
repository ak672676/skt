import "package:flutter/material.dart";
import 'package:skt/model/vehicle.dart';
import 'package:skt/resources/firestore_methods.dart';
import 'package:skt/screens/home_screen.dart';
import 'package:skt/utils/utils.dart';
import 'package:skt/widget/navigation_drawer_widget.dart';
// import 'package:validate/validate.dart';

class CreateVehicle extends StatefulWidget {
  Vehicle? vehicle;
  bool isEditMode;

  CreateVehicle({
    Key? key,
    this.isEditMode = false,
    this.vehicle,
  }) : super(key: key);

  @override
  State<CreateVehicle> createState() => _CreateVehicleState();
}

class _CreateVehicleState extends State<CreateVehicle> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  final TextEditingController vehicleNumber = TextEditingController();
  final TextEditingController chassisNumber = TextEditingController();
  final TextEditingController engineNumber = TextEditingController();
  final TextEditingController gvw = TextEditingController();
  final TextEditingController ownerContact = TextEditingController();
  final TextEditingController ownerName = TextEditingController();

  bool _isLoading = false;
  Vehicle vehicle = new Vehicle();
  String vehicleType = "Truck";

  @override
  void initState() {
    super.initState();

    if (widget.isEditMode) {
      print(widget.vehicle!.toJson());
      vehicleNumber.text = widget.vehicle!.vehicleNumber!;
      vehicleType = widget.vehicle!.vehicleType!;
      chassisNumber.text = widget.vehicle!.chassisNumber!;
      engineNumber.text = widget.vehicle!.engineNumber!;
      gvw.text = widget.vehicle!.gvw!;
      ownerContact.text = widget.vehicle!.ownerContact!;
      ownerName.text = widget.vehicle!.ownerName!;

      print("l iiohio io");
      print(vehicleNumber.text);
    }
  }

  @override
  void dispose() {
    super.dispose();
    vehicleNumber.dispose();
    // vehicleType.dispose();
    chassisNumber.dispose();
    engineNumber.dispose();
    gvw.dispose();
    ownerContact.dispose();
    ownerName.dispose();
  }

  void submit() {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }

    if (widget.isEditMode) {
      vehicle.uid = widget.vehicle!.uid;
    }

    vehicle.vehicleNumber = vehicleNumber.text;
    vehicle.vehicleType = vehicleType;
    vehicle.chassisNumber =
        chassisNumber.text.isEmpty ? "" : chassisNumber.text;
    vehicle.engineNumber = engineNumber.text.isEmpty ? "" : engineNumber.text;
    vehicle.gvw = gvw.text.isEmpty ? "" : gvw.text;
    vehicle.ownerContact = ownerContact.text;
    vehicle.ownerName = ownerName.text;
    if (widget.isEditMode)
      updateVehicle(vehicle);
    else {
      print(vehicle.toJson());
      saveVehicle(vehicle);
    }
  }

  void updateVehicle(Vehicle vehicle) async {
    setState(() {
      _isLoading = true;
    });
    try {
      String res = await FirestoreMethods().updateVehicle(vehicle);

      if (res == "success") {
        setState(() {
          _isLoading = false;
        });
        Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => HomeScreen(),
          ),
        );

        showSnackBar("Vehicle updated", context);
        // clearImage()
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

        Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => HomeScreen(),
          ),
        );

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
        title:
            widget.isEditMode ? Text("Update Vehicle") : Text("Create Vehicle"),
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
                      Row(
                        children: [
                          Flexible(
                            child: TextFormField(
                              controller: vehicleNumber,
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                  hintText: 'Vehicle Number',
                                  labelText: 'Vehicle Number'),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Enter a vehicle number';
                                }
                                return null;
                              },
                            ),
                          ),
                          Flexible(
                            child: Container(
                              margin: EdgeInsets.only(top: 10.0),
                              child: DropdownButton<String>(
                                hint: Text('Select a vehicle '),
                                underline: SizedBox(),
                                value: vehicleType,
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
                                      vehicleType = newValue;
                                    });
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: TextFormField(
                              controller: chassisNumber,
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                  hintText: 'Chassis Number',
                                  labelText: 'Chassis Number'),
                            ),
                          ),
                          Flexible(
                            child: TextFormField(
                              controller: engineNumber,
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                  hintText: 'Engine Number',
                                  labelText: 'Engine Number'),
                            ),
                          ),
                        ],
                      ),
                      TextFormField(
                        controller: gvw,
                        decoration: const InputDecoration(
                          hintText: 'GVW',
                          labelText: 'GVW',
                        ),
                      ),
                      TextFormField(
                        controller: ownerName,
                        decoration: const InputDecoration(
                          hintText: 'Owner',
                          labelText: 'Owner name',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter owner name';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: ownerContact,
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
                      ),
                      Container(
                        width: screenSize.width,
                        child: ElevatedButton(
                          child: widget.isEditMode
                              ? const Text(
                                  'Update',
                                  style: TextStyle(color: Colors.white),
                                )
                              : const Text(
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
