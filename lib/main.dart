import 'package:bloc/bloc.dart';
import 'package:cafeteriat/layout/cafeteria_app/cubit/cubit.dart';
import 'package:cafeteriat/shared/bloc_observer.dart';
import 'package:cafeteriat/shared/cubit/cubit.dart';
import 'package:cafeteriat/shared/cubit/states.dart';
import 'package:cafeteriat/shared/network/local/cache_helper.dart';
import 'package:cafeteriat/shared/styles/themes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'layout/cafeteria_app/cafeteria_app_layout.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Bloc.observer = MyBlocObserver();
  await CacheHelper.init();
  bool? isDark = CacheHelper.getData(key: "isDark");
  late Widget appStartingScreen;
  appStartingScreen = Container();
  runApp(
    MyApp(
      isDark: isDark,
      startingScreen: appStartingScreen,
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
            create: (context) => CafeteriaCubit()
              ..getMenuData()
              ..getCurrentHistoryData()
            // ..getPreviousHistoryData()
            // ..getMyOrderData(),
            // ..getUserData(activationCode: "jm"),
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
            home: const Directionality(
              child: CafeteriaHomeScreen(),
              textDirection: TextDirection.rtl,
              // textDirection: TextDirection.ltr,
            ),
          );
        },
      ),
    );
  }
}
