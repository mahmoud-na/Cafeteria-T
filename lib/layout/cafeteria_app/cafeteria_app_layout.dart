import 'package:cafeteriat/shared/components/components.dart';
import 'package:cafeteriat/shared/cubit/cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CafeteriaHomeScreen extends StatelessWidget {
  const CafeteriaHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        actions: [
          IconButton(
            onPressed: () {
              AppCubit.get(context).changeAppThemeMode();
            },
            icon: const Icon(
              Icons.dark_mode,
            ),
          ),
        ],
      ),
      body: const Center(
        child: Text(
          'Home Screen',
          style: TextStyle(
            fontSize: 23.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
