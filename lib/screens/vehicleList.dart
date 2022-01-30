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
            child: ListView.builder(
              itemCount: 120,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Vehicle v = new Vehicle();
                    v.ownerName = "Amit Kumar";
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) =>
                            VehicleDetail(vehicle: v),
                      ),
                    );
                  },
                  child: ListTile(
                    title: Text("Vehicle $index"),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      drawer: NavigationDrawerWidget(),
    );
  }
}
