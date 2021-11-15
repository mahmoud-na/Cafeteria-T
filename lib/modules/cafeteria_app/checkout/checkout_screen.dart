import 'package:cafeteriat/layout/cafeteria_app/cubit/cubit.dart';
import 'package:cafeteriat/layout/cafeteria_app/cubit/states.dart';
import 'package:cafeteriat/shared/components/components.dart';
import 'package:cafeteriat/shared/styles/icon_broken.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CheckOutScreen extends StatelessWidget {
  const CheckOutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CafeteriaCubit, CafeteriaStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = CafeteriaCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: const Text("سلتي"),
            titleSpacing: 5.0,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                IconBroken.Arrow___Right_2,
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  myCartSummery(
                    myCartTotalItem: cubit.myCart['totalItems'],
                    myCartTotalPrice: cubit.myCart['totalPrice'],
                  ),
                  shopItemBuilder(
                    menuModel: cubit.myCart["list"],
                    state: state,
                  ),
                  const SizedBox(
                    height: 60.0,
                  ),
                ],
              ),
            ),
          ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.all(
              10.0,
            ),
            child: SizedBox(
              width: double.infinity,
              child: FloatingActionButton(
                elevation: 2.0,
                shape: ContinuousRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    20.0,
                  ),
                ),
                onPressed: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 50.0,
                    ),
                    const Expanded(
                      child: Text(
                        "إدفع",
                        style: TextStyle(
                          fontSize: 24.0,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.monetization_on,
                      size: 37.0,
                      color: Colors.grey[100],
                    ),
                    const SizedBox(
                      width: 25.0,
                    ),
                  ],
                ),
              ),
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
        );
      },
    );
  }

  Widget myCartSummery({
    required int myCartTotalItem,
    required double myCartTotalPrice,
  }) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          const Text(
            "ملخص الطلب",
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          myDivider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                width: 30.0,
              ),
              const Expanded(
                child: Text(
                  "عدد الطلبات",
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                ),
              ),
              Text(
                "$myCartTotalItem",
                style: const TextStyle(
                  fontSize: 20.0,
                ),
              ),
              const SizedBox(
                width: 30.0,
              ),
            ],
          ),
          myDivider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                width: 30.0,
              ),
              const Expanded(
                child: Text(
                  "المبلغ الإجمالي",
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                ),
              ),
              Text(
                "$myCartTotalPrice",
                style: const TextStyle(
                  fontSize: 20.0,
                ),
              ),
              const SizedBox(
                width: 30.0,
              ),
            ],
          ),
        ],
      );
}
