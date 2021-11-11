import 'package:cafeteriat/shared/styles/icon_broken.dart';
import 'package:flutter/material.dart';

class CurrentHistoryScreen extends StatelessWidget {
  const CurrentHistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text("CurrentHistory"),
        titleSpacing: 5.0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            IconBroken.Arrow___Left_2,
          ),
        ),
      ),
      body: const Center(
        child: Text(
          'CurrentHistory Screen',
          style: TextStyle(
            fontSize: 23.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
