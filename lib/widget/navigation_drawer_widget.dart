import 'package:flutter/material.dart';
import 'package:skt/screens/create_vehicle.dart';
import 'package:skt/screens/home_screen.dart';
import 'package:skt/screens/insurance_notification.dart';
import 'package:skt/screens/tax_notification.dart';
import 'package:skt/screens/vehicleList.dart';

class NavigationDrawerWidget extends StatelessWidget {
  const NavigationDrawerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.blue,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(height: 40),
          ListTile(
            leading: const Icon(Icons.house, color: Colors.white70),
            title: const Text(
              'Home',
              style: TextStyle(fontSize: 24.0, color: Colors.white70),
            ),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => HomeScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.new_label, color: Colors.white70),
            title: const Text(
              'New Vehicle',
              style: TextStyle(fontSize: 24.0, color: Colors.white70),
            ),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => CreateVehicle(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.directions_bike, color: Colors.white70),
            title: const Text(
              'Vehicles',
              style: TextStyle(fontSize: 24.0, color: Colors.white70),
            ),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => VehicleList(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.notifications, color: Colors.white70),
            title: const Text(
              'Tax Notification',
              style: TextStyle(fontSize: 24.0, color: Colors.white70),
            ),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => TaxNotification(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.document_scanner_outlined,
                color: Colors.white70),
            title: const Text(
              'Insurance Notification',
              style: TextStyle(fontSize: 24.0, color: Colors.white70),
            ),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => InsuranceNotification(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
