import 'package:flutter/material.dart';

class CircularProgress extends StatelessWidget {
  const CircularProgress({super.key});

  @override
  Widget build(BuildContext context) {
    return const Positioned.fill(
      child: ColoredBox(
        color: Color(0x66000000), // semi-transparent black
        child: Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
