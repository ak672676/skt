import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import "package:flutter/material.dart";
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:skt/model/insurance.dart';
import 'package:skt/model/tax.dart';
import 'package:skt/model/vehicle.dart';
import 'package:skt/model/vehicleDocument.dart';
import 'package:skt/resources/firestore_methods.dart';
import 'package:skt/resources/pdf_api.dart';
import 'package:skt/screens/create_vehicle.dart';
import 'package:skt/screens/home_screen.dart';
import 'package:skt/screens/pdf_viewer_page.dart';
import 'package:skt/utils/utils.dart';
import 'package:skt/widget/add_insurance_buttom_sheet.dart';
import 'package:skt/widget/add_tax_buttom_sheet.dart';
import 'package:skt/widget/buttom_sheet.dart';
import 'package:skt/widget/tax_detail.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';

class VehicleDetail extends StatefulWidget {
  final String? vehicleNumber;

  const VehicleDetail({Key? key, this.vehicleNumber}) : super(key: key);

  @override
  State<VehicleDetail> createState() => _VehicleDetailState();
}

class _VehicleDetailState extends State<VehicleDetail> {
  Vehicle? vehicle;
  bool _isLoading = false;

  Widget fileTypeIcon(String fileType) {
    if (fileType != null) {
      if (fileType == "pdf") {
        return const Text("PDF",
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold));
      }
      return const Text("IMG",
          style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold));
    } else {
      return const Text("File",
          style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold));
    }
  }

  void openPDF(BuildContext context, File file) => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => PDFViewerPage(file: file),
        ),
      );

  Future openFile({required String url, String? filename}) async {
    final file = await downloadFile(url, filename!);
    print("Check File ->  ${file}");
    if (file != null) return;
    OpenFile.open(file!.path);
  }

  Future<File?> downloadFile(String url, String name) async {
    final appStorage = await getApplicationDocumentsDirectory();
    final file = File("${appStorage.path}/$name");
    print("Path: ${file.path}");
    try {
      final response = await Dio().get(
        url,
        options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            receiveTimeout: 0),
      );

      final raf = file.openSync(mode: FileMode.write);
      raf.writeFromSync(response.data);
      await raf.close();
      return file;
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    initialize();
  }

  initialize() async {
    setState(() {
      _isLoading = true;
    });
    try {
      // FirebaseFirestore.instance
      //     .collection("vehicles")
      //     .doc(widget.vehicleNumber!)
      //     .get()
      //     .then((doc) {
      //   print(doc.data());
      //   setState(() {
      //     vehicle = Vehicle.fromJson(doc.data() as dynamic);
      //   });
      // });
      // setState(() {
      //   _isLoading = false;
      // });

      DocumentSnapshot snap = await FirebaseFirestore.instance
          .collection("vehicles")
          .doc(widget.vehicleNumber!)
          .get();
      if (snap.exists) {
        setState(() {
          vehicle = Vehicle.fromJson(snap.data() as dynamic);
        });
      }
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
      showSnackBar(e.toString(), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Vehicle Detail"),
      ),
      body: _isLoading
          ? Center(child: Text("Loading..."))
          : SingleChildScrollView(
              child: Container(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute<void>(
                                        builder: (BuildContext context) =>
                                            CreateVehicle(
                                          isEditMode: true,
                                          vehicle: vehicle,
                                        ),
                                      ),
                                    );
                                  },
                                  child: const Icon(Icons.edit),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    String res = await FirestoreMethods()
                                        .deleteVehicle(vehicle!.uid!);
                                    if (res == "success") {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute<void>(
                                          builder: (BuildContext context) =>
                                              HomeScreen(),
                                        ),
                                      );
                                    }
                                  },
                                  child: Icon(Icons.delete),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Icon(Icons.directions_car, size: 50),
                                const SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Vehicle Number",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Clipboard.setData(ClipboardData(
                                          text: vehicle!.vehicleNumber!,
                                        )).then((_) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                                  content: Text(
                                                      "Copied to clipboard")));
                                        });
                                      },
                                      child: Text(
                                        vehicle!.vehicleNumber!,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 26),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Column(
                                          children: [
                                            const Text(
                                              "Vehicle Type",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            Text(
                                              vehicle!.vehicleType!,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 26),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "GVW",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                if (vehicle!.gvw!.isNotEmpty) {
                                                  Clipboard.setData(
                                                      ClipboardData(
                                                    text: vehicle!.gvw!,
                                                  )).then((_) {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                            const SnackBar(
                                                                content: Text(
                                                                    "Copied to clipboard")));
                                                  });
                                                }
                                              },
                                              child: Text(
                                                vehicle!.gvw!.isNotEmpty
                                                    ? vehicle!.gvw!
                                                    : "----",
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 26),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "Chassis Number",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                if (vehicle!.chassisNumber!
                                                    .isNotEmpty) {
                                                  Clipboard.setData(
                                                      ClipboardData(
                                                    text:
                                                        vehicle!.chassisNumber!,
                                                  )).then((_) {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                            const SnackBar(
                                                                content: Text(
                                                                    "Copied to clipboard")));
                                                  });
                                                }
                                              },
                                              child: Text(
                                                vehicle!.chassisNumber!
                                                        .isNotEmpty
                                                    ? vehicle!.chassisNumber!
                                                    : "----",
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 20),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "Engine Number",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                if (vehicle!
                                                    .engineNumber!.isNotEmpty) {
                                                  Clipboard.setData(
                                                      ClipboardData(
                                                    text:
                                                        vehicle!.engineNumber!,
                                                  )).then((_) {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                            const SnackBar(
                                                                content: Text(
                                                                    "Copied to clipboard")));
                                                  });
                                                }
                                              },
                                              child: Text(
                                                vehicle!.engineNumber!
                                                        .isNotEmpty
                                                    ? vehicle!.engineNumber!
                                                    : "----",
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 20),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Icon(Icons.person, size: 50),
                                const SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Owner Name",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Text(
                                      vehicle!.ownerName!,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 26),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const Text(
                                      "Owner Contact",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        launch("tel://" +
                                            "+91" +
                                            vehicle!.ownerContact!);
                                      },
                                      child: Text(
                                        vehicle!.ownerContact!,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 26),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            "Documents",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 24),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              showModalBottomSheet<void>(
                                context: context,
                                builder: (BuildContext context) {
                                  return ButtonSheet(
                                      context: context, uid: vehicle!.uid!);
                                },
                              );
                            },
                            child: const Text("Add Document"),
                          ),
                        ],
                      ),
                    ),
                    StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("vehicles")
                          .doc(vehicle!.uid!)
                          .collection("documents")
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if ((snapshot.data! as dynamic).docs.length == 0) {
                          return Container(
                            margin: EdgeInsets.only(top: 10.0),
                            child: Text("No Documents"),
                          );
                        }
                        return Container(
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount:
                                  (snapshot.data! as dynamic).docs.length,
                              itemBuilder: (context, index) {
                                VehicleDocument vd = VehicleDocument.fromJson(
                                    (snapshot.data! as dynamic)
                                        .docs[index]
                                        .data());

                                return ListTile(
                                  title: GestureDetector(
                                    onTap: () async {
                                      if (vd.type == "pdf") {
                                        final url = vd.url!;
                                        // final file = await PDFApi.loadFirebase(url);
                                        // if (file == null) return;
                                        // openPDF(context, file);
                                        final file =
                                            await PDFApi.loadNetwork(url);
                                        openPDF(context, file);
                                      } else {
                                        showModalBottomSheet<void>(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.70,
                                              child: Image.network(
                                                vd.url!,
                                                fit: BoxFit.cover,
                                              ),
                                            );
                                          },
                                        );
                                      }
                                    },
                                    child: Text(vd.title!),
                                  ),
                                  leading: fileTypeIcon(vd.type!),
                                  trailing: Wrap(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.download),
                                        onPressed: () async {
                                          // await PDFApi.downloadFile(vd.url!);
                                          // await StorageMethod.downloadFile(
                                          //     "gs://sktrader-5182a.appspot.com/jpg/IMG_20211204_101902.jpg"
                                          //         as Reference);

                                          // showSnackBar("Downloaded", context);
                                          openFile(
                                              url: vd.url!,
                                              filename: "acd." + vd.type!);
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete),
                                        onPressed: () async {
                                          String res = await FirestoreMethods()
                                              .deleteDocument(
                                            vd.uid!,
                                            vehicle!.uid!,
                                            vd.url!,
                                          );

                                          if (res == "success") {
                                            showSnackBar(
                                                "Document Deleted", context);
                                          } else {
                                            showSnackBar(
                                                "Error Deleting Document",
                                                context);
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              }),
                        );
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            "Tax Details",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 24),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (BuildContext context) {
                                  return AddTaxButtomSheet(
                                    context: context,
                                    uid: vehicle!.uid!,
                                    vehicleNumber: vehicle!.vehicleNumber!,
                                  );
                                },
                              );
                            },
                            child: const Text("Add Tax"),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("taxes")
                          .where("vid", isEqualTo: vehicle!.uid!)
                          .orderBy("onDate", descending: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if ((snapshot.data! as dynamic).docs.length == 0) {
                          return Container(
                            margin: EdgeInsets.only(top: 10.0),
                            child: Text("No previous tax details"),
                          );
                        }
                        return Container(
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: (snapshot.data! as dynamic).docs.length,
                            itemBuilder: (context, index) {
                              Tax tax = Tax.fromJson((snapshot.data! as dynamic)
                                  .docs[index]
                                  .data());

                              return ListTile(
                                leading: Icon(
                                  Icons.circle_rounded,
                                  // color: tax.isActive! ? Colors.green : Colors.red,
                                  color: DateTime.now().millisecondsSinceEpoch <
                                          tax.endDate!.millisecondsSinceEpoch
                                      ? Colors.green
                                      : Colors.red,
                                ),
                                title: GestureDetector(
                                  onTap: () {
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: TaxDetail(tax: tax),
                                        );
                                      },
                                    );
                                  },
                                  child: Text(
                                    "${tax.startDate!.day}-${tax.startDate!.month}-${tax.startDate!.year}    -    ${tax.endDate!.day}-${tax.endDate!.month}-${tax.endDate!.year}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                                trailing: Wrap(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit),
                                      onPressed: () {
                                        showModalBottomSheet(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AddTaxButtomSheet(
                                              context: context,
                                              uid: vehicle!.uid!,
                                              vehicleNumber:
                                                  vehicle!.vehicleNumber!,
                                              isEditMode: true,
                                              tax: tax,
                                            );
                                          },
                                        );
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () async {
                                        String res =
                                            await FirestoreMethods().deleteTax(
                                          tax.uid!,
                                        );

                                        if (res == "success") {
                                          showSnackBar(
                                              "Document Deleted", context);
                                        } else {
                                          showSnackBar(
                                              "Error Deleting Document",
                                              context);
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            "Insurance",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 24),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (BuildContext context) {
                                  return AddInsuranceButtomSheet(
                                    context: context,
                                    uid: vehicle!.uid!,
                                    vehicleNumber: vehicle!.vehicleNumber!,
                                  );
                                },
                              );
                            },
                            child: const Text("Add Insurance"),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("insurances")
                          .where("vid", isEqualTo: vehicle!.uid!)
                          .orderBy("onDate", descending: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if ((snapshot.data! as dynamic).docs.length == 0) {
                          return Container(
                            margin: EdgeInsets.only(top: 10.0),
                            child: Text("No previous insurance details"),
                          );
                        }
                        return Container(
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: (snapshot.data! as dynamic).docs.length,
                            itemBuilder: (context, index) {
                              Insurance insurance = Insurance.fromJson(
                                  (snapshot.data! as dynamic)
                                      .docs[index]
                                      .data());

                              return ListTile(
                                leading: Icon(
                                  Icons.circle_rounded,
                                  // color: tax.isActive! ? Colors.green : Colors.red,
                                  color: DateTime.now().millisecondsSinceEpoch <
                                          insurance
                                              .endDate!.millisecondsSinceEpoch
                                      ? Colors.green
                                      : Colors.red,
                                ),
                                title: GestureDetector(
                                  onTap: () {
                                    // showModalBottomSheet(
                                    //   context: context,
                                    //   builder: (BuildContext context) {
                                    //     return Padding(
                                    //       padding: const EdgeInsets.all(8.0),
                                    //       child: TaxDetail(tax: tax),
                                    //     );
                                    //   },
                                    // );
                                  },
                                  child: Text(
                                    "${insurance.startDate!.day}-${insurance.startDate!.month}-${insurance.startDate!.year}    -    ${insurance.endDate!.day}-${insurance.endDate!.month}-${insurance.endDate!.year}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                                trailing: Wrap(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit),
                                      onPressed: () {
                                        showModalBottomSheet(
                                          context: context,
                                          builder: (BuildContext context) {
                                            print(insurance.valuation);

                                            return AddInsuranceButtomSheet(
                                              context: context,
                                              uid: vehicle!.uid!,
                                              vehicleNumber:
                                                  vehicle!.vehicleNumber!,
                                              isEditMode: true,
                                              insurance: insurance,
                                            );
                                          },
                                        );
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () async {
                                        String res = await FirestoreMethods()
                                            .deleteInsurance(
                                          insurance.uid!,
                                        );

                                        if (res == "success") {
                                          showSnackBar(
                                              "Insurance Deleted", context);
                                        } else {
                                          showSnackBar(
                                              "Error Insurance Document",
                                              context);
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
