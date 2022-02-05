import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:skt/model/tax.dart';
import 'package:skt/model/vehicleDocument.dart';
import 'package:skt/screens/vehicle_detail.dart';
import 'package:skt/widget/navigation_drawer_widget.dart';

class TaxNotification extends StatefulWidget {
  const TaxNotification({Key? key}) : super(key: key);

  @override
  _TaxNotificationState createState() => _TaxNotificationState();
}

class _TaxNotificationState extends State<TaxNotification> {
  String searchDays = '15';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextFormField(
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
          ],
          onChanged: (value) {
            setState(() {
              searchDays = value != "" ? value : '15';
            });
            print("searchDays -> $searchDays");
            print("to int ->");
            print(int.parse(searchDays));
          },
          decoration: const InputDecoration(
            hintText: "Days",
            border: InputBorder.none,
          ),
          cursorColor: Colors.grey,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("taxes")
                  .where(
                    "endDate",
                    isLessThanOrEqualTo: DateTime.now()
                        .add(Duration(days: int.parse(searchDays)))
                        .millisecondsSinceEpoch,
                  )
                  .orderBy("endDate", descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return Container(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: (snapshot.data! as dynamic).docs.length,
                    itemBuilder: (context, index) {
                      Tax tax = Tax.fromJson(
                        (snapshot.data! as dynamic).docs[index].data(),
                      );

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) => VehicleDetail(
                                vehicleNumber: tax.vid,
                              ),
                            ),
                          );
                        },
                        child: ListTile(
                          leading: const Text(
                            "TAX",
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                tax.vehicleNumber!,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              Text(
                                "${tax.startDate!.day}-${tax.startDate!.month}-${tax.startDate!.year}    -    ${tax.endDate!.day}-${tax.endDate!.month}-${tax.endDate!.year}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
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
      drawer: NavigationDrawerWidget(),
    );
  }
}
