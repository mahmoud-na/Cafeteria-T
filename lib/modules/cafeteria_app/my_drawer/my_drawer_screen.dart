import 'package:cafeteriat/layout/cafeteria_app/cubit/cubit.dart';
import 'package:cafeteriat/layout/cafeteria_app/cubit/states.dart';
import 'package:cafeteriat/modules/cafeteria_app/about/about_screen.dart';
import 'package:cafeteriat/modules/cafeteria_app/current_history/current_history_screen.dart';
import 'package:cafeteriat/modules/cafeteria_app/previous_history/previous_history_screen.dart';
import 'package:cafeteriat/modules/cafeteria_app/profile/profile_screen.dart';
import 'package:cafeteriat/shared/components/components.dart';
import 'package:cafeteriat/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CafeteriaCubit, CafeteriaStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Drawer(
          child: ListView(
            children: [
              myDrawerHeaderBuilder(context),
              const SizedBox(
                height: 7.0,
              ),
              Center(
                child: Text(
                  "جوزيف مدحت سليم",
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
              const SizedBox(
                height: 5.0,
              ),
              myDivider(),
              defaultListTile(
                title: 'بياناتي',
                icon: const Icon(Icons.person),
                onTap: () {
                  navigateTo(context, const ProfileScreen());
                },
              ),
              myDivider(),
              Theme(
                data: Theme.of(context).copyWith(
                  dividerColor: Colors.transparent,
                ),
                child: ExpansionTile(
                  leading: const Icon(
                    Icons.shopping_cart_rounded,
                  ),
                  title: const Text(
                    "طلباتي",
                  ),
                  children: <Widget>[
                    defaultListTile(
                      title: 'طلبات الشهر الحالي',
                      onTap: () {
                        navigateTo(context, const CurrentHistoryScreen());
                      },
                    ),
                    defaultListTile(
                      title: 'طلبات الشهر السابق',
                      onTap: () {
                        navigateTo(context, const PreviousHistoryScreen());
                      },
                    ),
                  ],
                ),
              ),
              myDivider(),
              defaultListTile(
                title: 'حول التطبيق',
                icon: const Icon(Icons.info),
                onTap: () {
                  navigateTo(context, const AboutScreen());
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 90.0,
                ),
                child: OutlinedButton(
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all<Color>(
                      Colors.grey,
                    ),
                    side: MaterialStateProperty.all<BorderSide>(
                      const BorderSide(
                        color: defaultColor,
                        width: 0.6,
                      ),
                    ),
                  ),
                  onPressed: () {},
                  child: const Text(
                    "تسجيل الخروخ",
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget myDrawerHeaderBuilder(context) => SizedBox(
        width: double.infinity,
        height: 220.0,
        child: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: [
            Align(
              alignment: AlignmentDirectional.topCenter,
              child: Container(
                height: 160.0,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage('assets/images/DrawerBackground.jpg'),
                  ),
                ),
              ),
            ),
            CircleAvatar(
              radius: 54.0,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              child: const CircleAvatar(
                radius: 50.0,
                backgroundImage: AssetImage('assets/images/person.png'),
              ),
            ),
          ],
        ),
      );
}
