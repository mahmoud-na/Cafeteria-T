import 'package:cached_network_image/cached_network_image.dart';
import 'package:cafeteriat/layout/cafeteria_app/cubit/cubit.dart';
import 'package:cafeteriat/layout/cafeteria_app/cubit/states.dart';
import 'package:cafeteriat/modules/cafeteria_app/about/about_screen.dart';
import 'package:cafeteriat/modules/cafeteria_app/current_history/current_history_screen.dart';
import 'package:cafeteriat/modules/cafeteria_app/login/login_screen.dart';
import 'package:cafeteriat/modules/cafeteria_app/previous_history/previous_history_screen.dart';
import 'package:cafeteriat/modules/cafeteria_app/profile/profile_screen.dart';
import 'package:cafeteriat/shared/components/components.dart';
import 'package:cafeteriat/shared/cubit/cubit.dart';
import 'package:cafeteriat/shared/network/local/cache_helper.dart';
import 'package:cafeteriat/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyDrawer extends StatelessWidget {
  MyDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CafeteriaCubit, CafeteriaStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = CafeteriaCubit.get(context);
        return Drawer(
          child: ListView(
            children: [
              myDrawerHeaderBuilder(context, cubit),
              const SizedBox(
                height: 7.0,
              ),
              Center(
                child: Text(
                  "${cubit.userModel?.data?.name}",
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
              const SizedBox(
                height: 5.0,
              ),
              myVDivider(),
              defaultListTile(
                title: 'بياناتي',
                icon: const Icon(Icons.person),
                onTap: () {
                  navigateTo(context, profileScreen());
                },
              ),
              myVDivider(),
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
              myVDivider(),
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
                  vertical: 60.0,
                ),
                child: OutlinedButton(
                  onPressed: () {
                    CacheHelper.removeAllData().then((value) {
                      defaultShowDialog(
                        context: context,
                        title: "تسجيل خروج",
                        content: "هل انت متأكد من تسجيلك للخروج",
                        icon: const Icon(
                          Icons.error,
                          color: Colors.red,
                          size: 40,
                        ),
                        actions: [
                          defaultAlertActionButtons(
                            context: context,
                            onPressed: () {
                              navigateAndReplace(
                                context,
                                const LoginScreen(),
                              );
                            },
                          ),
                        ],
                      );

                    });
                  },
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

  Widget myDrawerHeaderBuilder(context, var cubit) => SizedBox(
        width: double.infinity,
        height: 220.0,
        child: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: [
            Align(
              alignment: AlignmentDirectional.topCenter,
              child: SizedBox(
                height: 160.0,
                child: CachedNetworkImage(
                  imageUrl: cubit.userModel?.data?.coverImage ?? '',
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 4,
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(
                          10.0,
                        ),
                        topRight: Radius.circular(
                          10.0,
                        ),
                      ),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage('assets/images/DrawerBackground.jpg'),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            CircleAvatar(
              radius: 54.0,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              child: CachedNetworkImage(
                imageUrl: cubit.userModel?.data?.profileImage ?? '',
                imageBuilder: (context, imageProvider) => Container(
                  height: 100.0,
                  width: 100.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                placeholder: (context, url) => Container(
                  height: 104.0,
                  width: 104.0,
                  child: const CircularProgressIndicator(
                    strokeWidth: 4,
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.black12,
                    shape: BoxShape.circle,
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  width: 100.0,
                  height: 100.0,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    shape: BoxShape.circle,
                  ),
                  child: const Image(
                    image: AssetImage('assets/images/person.png'),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AppCubit.get(context).isDarkMode
                      ? const Icon(
                          Icons.dark_mode,
                        )
                      : const Icon(
                          Icons.light_mode,
                          color: Colors.amber,
                        ),
                  Switch(
                    value: !(AppCubit.get(context).isDarkMode),
                    onChanged: (value) {
                      AppCubit.get(context).changeAppThemeMode();
                    },
                    activeColor: Colors.amber,
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(
                  right: 25.0,
                ),
                child: defaultQrIconButton(
                  context: context,
                ),
              ),
            ),
          ],
        ),
      );
}
