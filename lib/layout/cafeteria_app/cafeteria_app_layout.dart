import 'package:cafeteriat/layout/cafeteria_app/cubit/cubit.dart';
import 'package:cafeteriat/layout/cafeteria_app/cubit/states.dart';
import 'package:cafeteriat/modules/cafeteria_app/checkout/checkout_screen.dart';
import 'package:cafeteriat/modules/cafeteria_app/edit_order/edit_order_screen.dart';
import 'package:cafeteriat/modules/cafeteria_app/my_drawer/my_drawer_screen.dart';
import 'package:cafeteriat/modules/cafeteria_app/search/search_screen.dart';
import 'package:cafeteriat/shared/components/components.dart';
import 'package:cafeteriat/shared/cubit/cubit.dart';
import 'package:cafeteriat/shared/styles/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CafeteriaHomeScreen extends StatelessWidget {
  const CafeteriaHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CafeteriaCubit, CafeteriaStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = CafeteriaCubit.get(context);
        cubit.timeNowInHours().then((value) => cubit.timeNow = value);
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            extendBody: true,
            appBar: AppBar(
              title: Text(
                cubit.appBarTitles[cubit.navBarCurrentIndex],
              ),
              actions: [
                if (cubit.myOrderModel != null)
                  IconButton(
                    onPressed: () {
                      cubit.reloadMyOrderData();

                      navigateTo(
                        context,
                        const MyOrderScreen(),
                      );
                    },
                    icon: const Icon(
                      Icons.shopping_cart,
                    ),
                  ),
                IconButton(
                  onPressed: () {
                    navigateTo(
                      context,
                      const SearchScreen(),
                    );
                  },
                  icon: const Icon(
                    Icons.search,
                  ),
                ),
                const SizedBox(
                  width: 12.0,
                ),
              ],
            ),
            body: cubit.screens[cubit.navBarCurrentIndex],
            drawer: const MyDrawer(),
            bottomNavigationBar: BottomAppBar(
              shape: const CircularNotchedRectangle(),
              child: BottomNavigationBar(
                elevation: 0,
                backgroundColor: Colors.transparent,
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.fastfood,
                    ),
                    label: "أكل",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.emoji_food_beverage_rounded,
                    ),
                    label: "مشروبات",
                  ),
                  BottomNavigationBarItem(
                    icon: ImageIcon(
                      AssetImage(
                        "assets/images/Snacks1.png",
                      ),
                    ),
                    label: "تسالي",
                  ),
                  BottomNavigationBarItem(
                    icon: ImageIcon(
                      AssetImage(
                        "assets/images/Dessert1.png",
                      ),
                    ),
                    label: "حلويات",
                  ),
                ],
                onTap: (index) {
                  cubit.changeBottomNav(index);
                },
                currentIndex: cubit.navBarCurrentIndex,
              ),
            ),
            floatingActionButton: (cubit.myCartDataModel != null &&
                    cubit.myCartDataModel!.totalItems != 0)
                ? SizedBox(
                    height: 60.0,
                    width: 60.0,
                    child: FloatingActionButton(
                      backgroundColor: defaultColor,
                      child: Icon(
                        Icons.shopping_cart,
                        size: 35,
                        color: Colors.grey[100],
                      ),
                      onPressed: () {
                        navigateTo(context, const CheckOutScreen());
                      },
                    ),
                  )
                : null,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
          ),
        );
      },
    );
  }
}
