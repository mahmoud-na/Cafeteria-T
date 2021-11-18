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
                    myCartTotalItem: cubit.myCartDataModel!.totalItems,
                    myCartTotalPrice: cubit.myCartDataModel!.totalPrice,
                    context: context,
                  ),
                  shopItemBuilder(
                    menuModel: cubit.myCartDataModel!.products,
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
              height: 50.0,
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
                     Expanded(
                      child: Text(
                        "إدفع",
                        style: Theme.of(context).textTheme.headline6,
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
    required int? myCartTotalItem,
    required double? myCartTotalPrice,
    required BuildContext context,
   }) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
           Text(
            "ملخص الطلب",
            style: Theme.of(context).textTheme.headline6,
           ),
          myVDivider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                width: 30.0,
              ),
               Expanded(
                child: Text(
                  "عدد الطلبات",
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
              Text(
                "$myCartTotalItem",
                style: Theme.of(context).textTheme.headline6,
              ),
              const SizedBox(
                width: 30.0,
              ),
            ],
          ),
          myVDivider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                width: 30.0,
              ),
               Expanded(
                child: Text(
                  "المبلغ الإجمالي",
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
              Text(
                "$myCartTotalPrice",
                style: Theme.of(context).textTheme.headline6,
              ),
              const SizedBox(
                width: 30.0,
              ),
            ],
          ),
        ],
      );
}
