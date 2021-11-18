import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:cafeteriat/shared/cubit/states.dart';
import 'package:cafeteriat/shared/network/local/cache_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);
  bool isDarkMode = true;


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
