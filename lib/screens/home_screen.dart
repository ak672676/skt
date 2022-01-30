import 'package:flutter/material.dart';
import 'package:skt/widget/navigation_drawer_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: const Center(
        child: Text('Home Screen'),
      ),
      drawer: NavigationDrawerWidget(),
    );
  }
}
