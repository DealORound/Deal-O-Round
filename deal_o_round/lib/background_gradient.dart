import 'package:flutter/material.dart';

RadialGradient getBackgroundGradient() {
  return RadialGradient(
    center: const Alignment(0.0, 0.0),
    radius: 1.0,
    colors: [Color(0xAA33691E), Colors.black],
    stops: [0.0, 1.0],
  );
}
