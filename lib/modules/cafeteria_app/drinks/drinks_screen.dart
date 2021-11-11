import 'package:flutter/material.dart';

class DrinksScreen extends StatelessWidget {
  const DrinksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Drinks Screen',
        style: TextStyle(
          fontSize: 23.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
