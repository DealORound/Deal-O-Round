import 'dart:math';

import 'package:get/get.dart';
import 'package:flutter/material.dart';

double chipSize(BuildContext context) {
  final size = context.mediaQuerySize;
  return min((size.height - 11) / 5, (size.width - 11) / 10); // ~80
}

double chipRadius(BuildContext context) {
  return chipSize(context) / 2;
}
