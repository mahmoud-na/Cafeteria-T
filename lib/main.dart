import 'package:bloc/bloc.dart';
import 'package:cafeteriat/layout/cafeteria_app/cubit/cubit.dart';
import 'package:cafeteriat/shared/bloc_observer.dart';
import 'package:cafeteriat/shared/components/components.dart';
import 'package:cafeteriat/shared/cubit/cubit.dart';
import 'package:cafeteriat/shared/cubit/states.dart';
import 'package:cafeteriat/shared/network/local/cache_helper.dart';
import 'package:cafeteriat/shared/styles/themes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'modules/cafeteria_app/loading/cubit/cubit.dart';
import 'modules/cafeteria_app/loading/loading_screen.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {}
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseMessaging.instance.getToken();
  FirebaseMessaging.onMessage.listen((event) {
    showToast(
      msg: "تبقى على أخر ميعاد للطلبات ربع ساعة فقط",
      state: ToastStates.SUCCESS,
    );
  });
  FirebaseMessaging.onMessageOpenedApp.listen((event) {});
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  Bloc.observer = MyBlocObserver();
  await CacheHelper.init();
  var brightness = SchedulerBinding.instance?.window.platformBrightness;
  bool? isDark =
      CacheHelper.getData(key: "isDark") ?? brightness == Brightness.dark;
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
            home: Directionality(
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
