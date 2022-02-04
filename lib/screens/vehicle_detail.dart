import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import "package:flutter/material.dart";
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:skt/model/tax.dart';
import 'package:skt/model/vehicle.dart';
import 'package:skt/model/vehicleDocument.dart';
import 'package:skt/resources/firestore_methods.dart';
import 'package:skt/resources/pdf_api.dart';
import 'package:skt/screens/pdf_viewer_page.dart';
import 'package:skt/utils/utils.dart';
import 'package:skt/widget/add_tax_buttom_sheet.dart';
import 'package:skt/widget/buttom_sheet.dart';

class VehicleDetail extends StatefulWidget {
  final Vehicle? vehicle;

  const VehicleDetail({Key? key, this.vehicle}) : super(key: key);

  @override
  State<VehicleDetail> createState() => _VehicleDetailState();
}

class _VehicleDetailState extends State<VehicleDetail> {
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Vehicle Detail"),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const SizedBox(
                            width: 20,
                          ),
                          const Icon(Icons.directions_car, size: 50),
                          const SizedBox(
                            width: 20,
                          ),
                          Text(
                            widget.vehicle!.vehicleNumber!,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 28),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            widget.vehicle!.vehicleType!,
                            style: const TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Divider(
                          thickness: 1,
                        ),
                      ),
                      Row(
                        children: [
                          const SizedBox(
                            width: 20,
                          ),
                          const Icon(Icons.person, size: 40),
                          const SizedBox(
                            width: 20,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Owner",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                widget.vehicle!.ownerName!,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w400, fontSize: 28),
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          const SizedBox(
                            width: 20,
                          ),
                          const Icon(Icons.phone, size: 40),
                          const SizedBox(
                            width: 20,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Contact Number",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                widget.vehicle!.ownerContact!,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w400, fontSize: 26),
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 10,
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
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 24),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        showModalBottomSheet<void>(
                          context: context,
                          builder: (BuildContext context) {
                            return ButtonSheet(
                                context: context, uid: widget.vehicle!.uid!);
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
                    .doc(widget.vehicle!.uid!)
                    .collection("documents")
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
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
                        itemCount: (snapshot.data! as dynamic).docs.length,
                        itemBuilder: (context, index) {
                          VehicleDocument vd = VehicleDocument.fromJson(
                              (snapshot.data! as dynamic).docs[index].data());

                          return ListTile(
                            title: GestureDetector(
                              onTap: () async {
                                print(vd.url!);
                                if (vd.type == "pdf") {
                                  final url = vd.url!;
                                  // final file = await PDFApi.loadFirebase(url);
                                  // if (file == null) return;
                                  // openPDF(context, file);
                                  final file = await PDFApi.loadNetwork(url);
                                  openPDF(context, file);
                                } else {
                                  showModalBottomSheet<void>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Container(
                                        height:
                                            MediaQuery.of(context).size.height *
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
                                    String res =
                                        await FirestoreMethods().deleteDocument(
                                      vd.uid!,
                                      widget.vehicle!.uid!,
                                      vd.url!,
                                    );

                                    if (res == "success") {
                                      showSnackBar("Document Deleted", context);
                                    } else {
                                      showSnackBar(
                                          "Error Deleting Document", context);
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
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 24),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return AddTaxButtomSheet(
                              context: context,
                              uid: widget.vehicle!.uid!,
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
                    .where("vid", isEqualTo: widget.vehicle!.uid!)
                    .orderBy("onDate", descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
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
                        Tax tax = Tax.fromJson(
                            (snapshot.data! as dynamic).docs[index].data());

                        return ListTile(
                          leading: Icon(
                            Icons.circle_rounded,
                            // color: tax.isActive! ? Colors.green : Colors.red,
                            color: DateTime.now().millisecondsSinceEpoch <
                                    tax.endDate!.millisecondsSinceEpoch
                                ? Colors.green
                                : Colors.red,
                          ),
                          title: Text(
                            "${tax.startDate!.day}-${tax.startDate!.month}-${tax.startDate!.year}    -    ${tax.endDate!.day}-${tax.endDate!.month}-${tax.endDate!.year}",
                            style: const TextStyle(
                              fontWeight: FontWeight.w400,
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
                                        uid: widget.vehicle!.uid!,
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
                                    showSnackBar("Document Deleted", context);
                                  } else {
                                    showSnackBar(
                                        "Error Deleting Document", context);
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
