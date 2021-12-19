import 'package:bloc/bloc.dart';
import 'package:cafeteriat/layout/cafeteria_app/cafeteria_app_layout.dart';
import 'package:cafeteriat/shared/components/components.dart';
import 'package:cafeteriat/shared/cubit/states.dart';
import 'package:cafeteriat/shared/network/local/cache_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);
  bool isDarkMode = true;
  PageController boardingController = PageController();
  bool isLastIndex = false;

  void onBoardingSubmit(BuildContext context) {
    CacheHelper.saveData(key: 'onBoarding', value: true).then(
      (value) {
        if (value) {
          navigateAndReplace(context, const CafeteriaHomeScreen());
        }
      },
    );
  }

  void changePageViewIndex({required bool isLastPageView}) {
    isLastIndex = isLastPageView;
    emit(AppPageViewIndexState());
  }

  void nextOnBoardingPage() {
    boardingController.nextPage(
      duration: const Duration(
        milliseconds: 750,
      ),
      curve: Curves.fastLinearToSlowEaseIn,
    );
    emit(AppPageViewNextPageState());
  }

  void animateToNextOnBoardingPage({required int index}) {
    boardingController.animateToPage(
      index,
      duration: const Duration(
        milliseconds: 750,
      ),
      curve: Curves.ease,
    );
    emit(AppPageViewNextPageState());
  }

  void changeAppThemeMode({dynamic fromShared}) {
    if (fromShared != null) {
      isDarkMode = fromShared;
      emit(AppChangeThemeModeState());
    } else {
      isDarkMode = !isDarkMode;
      CacheHelper.putBooleanData(key: 'isDark', value: isDarkMode).then(
        (value) {
          emit(AppChangeThemeModeState());
        },
      );
    }
  }
}
