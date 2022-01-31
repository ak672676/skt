import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:skt/model/vehicle.dart';
import 'package:skt/screens/vehicle_detail.dart';
import 'package:skt/widget/navigation_drawer_widget.dart';

class VehicleList extends StatelessWidget {
  const VehicleList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Vehicle List"),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: FutureBuilder(
                future: FirebaseFirestore.instance.collection("vehicles").get(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return ListView.builder(
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
                                    VehicleDetail(vehicle: v2),
                              ),
                            );
                          },
                          child: ListTile(
                            title: Text(
                              "${v2.vehicleNumber}",
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w400),
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
