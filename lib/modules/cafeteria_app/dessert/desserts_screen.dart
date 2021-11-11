import 'package:flutter/material.dart';

class DessertsScreen extends StatelessWidget {
  const DessertsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Desserts Screen',
        style: TextStyle(
          fontSize: 23.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
