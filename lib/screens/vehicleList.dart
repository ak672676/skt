import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:skt/model/vehicle.dart';
import 'package:skt/screens/vehicle_detail.dart';
import 'package:skt/widget/navigation_drawer_widget.dart';

class VehicleList extends StatefulWidget {
  const VehicleList({Key? key}) : super(key: key);

  @override
  State<VehicleList> createState() => _VehicleListState();
}

class _VehicleListState extends State<VehicleList> {
  String searchText = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextFormField(
          onChanged: (value) {
            setState(() {
              searchText = value;
            });
          },
          decoration: const InputDecoration(
            hintText: "Search",
            border: InputBorder.none,
          ),
          cursorColor: Colors.grey,
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: FutureBuilder(
                future: searchText != ""
                    ? FirebaseFirestore.instance
                        .collection("vehicles")
                        .where("vehicleNumber",
                            isGreaterThanOrEqualTo: searchText)
                        .limit(5)
                        .get()
                    : FirebaseFirestore.instance.collection("vehicles").get(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  int count = (snapshot.data! as dynamic).docs.length;

                  return count <= 0
                      ? const Center(
                          child: Text("No Vehicles",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w400)))
                      : ListView.builder(
                          itemCount: (snapshot.data! as dynamic).docs.length,
                          itemBuilder: (context, index) {
                            Vehicle v2 = Vehicle.fromJson(
                                (snapshot.data! as dynamic).docs[index].data());
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute<void>(
                                    builder: (BuildContext context) =>
                                        VehicleDetail(vehicleNumber: v2.uid),
                                  ),
                                );
                              },
                              child: ListTile(
                                title: Text(
                                  "${v2.vehicleNumber}",
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            );
                          });
                }),
          ),
        ],
      ),
      drawer: NavigationDrawerWidget(),
    );
  }
}
