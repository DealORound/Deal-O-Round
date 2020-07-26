import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'background_gradient.dart';
import 'home/home_page.dart';
import 'home/home_page_widget.dart';

class DealORoundApp extends StatelessWidget {
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
        visualDensity: VisualDensity.adaptivePlatformDensity,
//        textTheme: TextTheme(
//        )
      ),
      home: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          decoration: BoxDecoration(
            gradient: getBackgroundGradient()
          ),
          child: HomePage(
            child: HomePageWidget()
          )
        )
      )
    );
  }
}
