import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:cafeteriat/layout/cafeteria_app/cubit/cubit.dart';
import 'package:cafeteriat/shared/bloc_observer.dart';
import 'package:cafeteriat/shared/components/constants.dart';
import 'package:cafeteriat/shared/cubit/cubit.dart';
import 'package:cafeteriat/shared/cubit/states.dart';
import 'package:cafeteriat/shared/network/local/cache_helper.dart';
import 'package:cafeteriat/shared/styles/themes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'layout/cafeteria_app/cafeteria_app_layout.dart';
import 'models/cafeteria_app/user_model.dart';
import 'modules/cafeteria_app/loading/cubit/cubit.dart';
import 'modules/cafeteria_app/loading/loading_screen.dart';
import 'modules/cafeteria_app/login/login_screen.dart';

Future<void> main() async {
  /*
    *   WidgetsFlutterBinding.ensureInitialized();
    *   When we use async in main we have to call this function to
    *   ensure App initializations will occurs before app starting
  */

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Bloc.observer = MyBlocObserver();
  await CacheHelper.init();
  bool? isDark = CacheHelper.getData(key: "isDark");
  runApp(
    MyApp(
      isDark: isDark,
      startingScreen: const LoadingScreen(),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool? isDark;
  final Widget? startingScreen;

  const MyApp({
    Key? key,
    this.isDark,
    this.startingScreen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AppCubit()
            ..changeAppThemeMode(
              fromShared: isDark,
            ),
        ),
        BlocProvider(
          create: (context) => CafeteriaCubit(),
        ),
        BlocProvider(
          create: (context) => CafeteriaLoadingCubit()..loadingNavigator(),
        ),
      ],
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Cafeteria-T',
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: AppCubit.get(context).isDarkMode
                ? ThemeMode.dark
                : ThemeMode.light,
            home:   Directionality(
              child: startingScreen!,
              textDirection: TextDirection.rtl,
              // textDirection: TextDirection.ltr,
            ),
          );
        },
      ),
    );
  }
}
