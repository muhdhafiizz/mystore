import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class EmptyList extends StatelessWidget {
  final String text;

  const EmptyList({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Lottie.asset("assets/lottie/empty_state_lottie.json"),
        Text(text)
      ],
    );
  }
}