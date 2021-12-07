import 'package:cafeteriat/layout/cafeteria_app/cafeteria_app_layout.dart';
import 'package:cafeteriat/layout/cafeteria_app/cubit/cubit.dart';
import 'package:cafeteriat/modules/cafeteria_app/login/login_screen.dart';
import 'package:cafeteriat/modules/cafeteria_app/on_boarding/on_boarding_screen.dart';
import 'package:cafeteriat/shared/components/components.dart';
import 'package:cafeteriat/shared/network/local/cache_helper.dart';
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
          Future.delayed(
            const Duration(milliseconds: 2000),
            () async {
              await CafeteriaCubit.get(context).getAppData();
              bool? onBoardingState = CacheHelper.getData(key: "onBoarding");
              if (onBoardingState != null) {
                navigateAndReplace(context, const CafeteriaHomeScreen());
              } else {
                navigateAndReplace(context,  OnBoardingScreen());
              }
            },
          );
        } else if (state is CafeteriaLoadingLoginState) {
          Future.delayed(
            const Duration(milliseconds: 3000),
            () async {
              navigateAndReplace(context, CafeteriaLoginScreen());
            },
          );
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
