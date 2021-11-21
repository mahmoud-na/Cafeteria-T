import 'package:cafeteriat/layout/cafeteria_app/cubit/cubit.dart';
import 'package:cafeteriat/layout/cafeteria_app/cubit/states.dart';
import 'package:cafeteriat/shared/components/components.dart';
import 'package:cafeteriat/shared/components/constants.dart';
import 'package:cafeteriat/shared/styles/icon_broken.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyOrderScreen extends StatelessWidget {
  const MyOrderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CafeteriaCubit, CafeteriaStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = CafeteriaCubit.get(context);
        return ConditionalBuilder(
          condition: state is! CafeteriaMyOrderLoadingState,
          builder: (context) => Scaffold(
            appBar: AppBar(
              title: const Text("طلب اليوم"),
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
                      myOrderTotalPrice:
                          cubit.myEditedOrderModel?.data!.totalPrice,
                      context: context,
                    ),
                    shopItemBuilder(
                      menuModel: cubit.myEditedOrderModel?.data!.orderList,
                    ),
                    const SizedBox(
                      height: 60.0,
                    ),
                  ],
                ),
              ),
            ),
            floatingActionButton: cubit.timeNow < timeLimitAllowed
                ? Padding(
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
                        onPressed: () {
                          cubit.editMyOrderData();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  right: 40.0,
                                ),
                                child: Text(
                                  "تعديل الطلب",
                                  style: Theme.of(context).textTheme.headline6,
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
                  )
                : null,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
          ),
          fallback: (context) => const Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  Widget myCartSummery({
    required double? myOrderTotalPrice,
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
                  "المبلغ الإجمالي",
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
              Text(
                "$myOrderTotalPrice",
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
