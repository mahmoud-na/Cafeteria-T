import 'package:cafeteriat/layout/cafeteria_app/cafeteria_app_layout.dart';
import 'package:cafeteriat/layout/cafeteria_app/cubit/cubit.dart';
import 'package:cafeteriat/modules/cafeteria_app/login/login_screen.dart';
import 'package:cafeteriat/shared/components/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/cubit.dart';
import 'cubit/states.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CafeteriaLoadingCubit, CafeteriaLoadingStates>(
      listener: (context, state) async {
        if (state is CafeteriaLoadingCafeteriaLayoutState) {
          await CafeteriaCubit.get(context).getAppData();
          navigateAndReplace(context, const CafeteriaHomeScreen());
        } else if (state is CafeteriaLoadingLoginState) {
          navigateAndReplace(context, CafeteriaLoginScreen());
        }
      },
      builder: (context, state) {
        return Center(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                stops: [
                  0.3,
                  0.9,
                ],
                colors: [
                  Color(0xFFFFEB3B),
                  Color(0xFFF44336),
                ],
              ),
            ),
            child: Center(
              child: Image.asset('assets/images/loading.gif'),
            ),
          ),
        );
      },
    );
  }
}
