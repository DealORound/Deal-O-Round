import 'package:deal_o_round/home_page_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'home_page.dart';

class DealORoundApp extends StatelessWidget {
  RadialGradient _getBackgroundGradient() {
    return RadialGradient(
      center: const Alignment(0.0, 0.0),
      radius: 1.0,
      colors: [
        Color(0xAA33691E),
        Colors.black
      ],
      stops: [0.0, 1.0],
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight
    ]);
    return MaterialApp(
      title: 'Deal-O-Round',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity
      ),
      home: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          decoration: BoxDecoration(
            gradient: _getBackgroundGradient()
          ),
          child: HomePage(
            child: HomePageWidget()
          )
        )
      )
    );
  }
}
