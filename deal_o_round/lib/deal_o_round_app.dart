import 'package:flutter/material.dart';
import 'home_page.dart';

class DealORoundApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Deal-O-Round',
      theme: ThemeData(
        backgroundColor: Colors.black,
        primaryColor: Colors.white,
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}
