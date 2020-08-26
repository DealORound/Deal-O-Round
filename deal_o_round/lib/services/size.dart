import 'package:get/get.dart';
import 'package:flutter/material.dart';

double chipSize(BuildContext context) {
  final size = context.mediaQuerySize;
  final height = size.height - 11;
  return height / 5;  // ~80
}

double chipRadius(BuildContext context) {
  final size = context.mediaQuerySize;
  final height = size.height - 11;
  return height / 10;  // ~40
}
