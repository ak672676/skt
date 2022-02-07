import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:async';

import 'package:skt/screens/home_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    _mockCheckForSession();
  }

  Future<void> _mockCheckForSession() async {
    await Future.delayed(Duration(milliseconds: 2000), () {});
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (BuildContext context) => HomeScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Container(
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Opacity(opacity: 0.5, child: Center(child: Text("SKT"))),
            Shimmer.fromColors(
              period: Duration(milliseconds: 1500),
              baseColor: Color(0xffffffff),
              highlightColor: Color(0xff73b2ff),
              child: Container(
                padding: EdgeInsets.all(16.0),
                child: const Text(
                  "SKT",
                  style: TextStyle(
                    fontSize: 70.0,
                    fontFamily: 'Pacifico',
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
