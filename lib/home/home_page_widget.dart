import 'package:flutter/material.dart';

import 'home_center.dart';
import 'left_example.dart';
import 'right_example.dart';

class HomePageWidget extends StatelessWidget {
  const HomePageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [LeftExample(), HomeCenter(), RightExample()],
    );
  }
}
