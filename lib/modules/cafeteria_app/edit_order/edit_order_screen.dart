import 'package:cafeteriat/layout/cafeteria_app/cafeteria_app_layout.dart';
import 'package:cafeteriat/layout/cafeteria_app/cubit/cubit.dart';
import 'package:cafeteriat/layout/cafeteria_app/cubit/states.dart';
import 'package:cafeteriat/shared/components/components.dart';
import 'package:cafeteriat/shared/components/constants.dart';
import 'package:cafeteriat/shared/styles/icon_broken.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

bool isMyOrderEdited(context) {
  for (int i = 0;
      i < CafeteriaCubit.get(context).myOrderModel!.data!.orderList.length;
      i++) {
    if (CafeteriaCubit.get(context).myOrderModel!.data!.orderList[i].counter !=
        CafeteriaCubit.get(context)
            .myEditedOrderModel!
            .data!
            .orderList[i]
            .counter) {
      return true;
    }
  }
  return false;
}

class MyOrderScreen extends StatelessWidget {
  const MyOrderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CafeteriaCubit, CafeteriaStates>(
      listener: (context, state) async {
        if (state is CafeteriaEditMyOrderLoadingState) {
          Navigator.pop(context);
          defaultShowDialog(
            closeable: false,
            context: context,
            content: "جاري تعديل الطلب برجاء الإنتظار...",
            title: 'تعديل الطلب',
            icon: const CircularProgressIndicator(),
          );
        }
        if (state is CafeteriaEditMyOrderErrorState) {
          Navigator.pop(context);
          defaultShowDialog(
            context: context,
            content: 'لم يتم قبول تعديل الطلب برجاء المحاولة مرة اخرى',
            title: 'تعديل الطلب',
            icon: const Icon(
              Icons.error,
              color: Colors.red,
              size: 40,
            ),
            toDoAfterClosing: () =>
                CafeteriaCubit.get(context).reloadMyOrderData(),
          );
        }
        if (state is CafeteriaEditMyOrderSuccessState) {
          if (CafeteriaCubit.get(context)
                  .editOrderResponseModel!
                  .data!
                  .updateValid ==
              'true') {
            Navigator.pop(context);
            defaultShowDialog(
              context: context,
              title: "تعديل الطلب",
              content: "تم تعديل طلبك بنجاح",
              icon: const Icon(
                Icons.verified,
                color: Colors.green,
                size: 40,
              ),
              toDoAfterClosing: () async {
                await CafeteriaCubit.get(context).getMyOrderData();
                CafeteriaCubit.get(context).reloadMyOrderData();
                if (CafeteriaCubit.get(context)
                        .myOrderModel!
                        .data!
                        .totalPrice ==
                    0) {
                  Navigator.pop(context);
                }
              },
            );
          } else if (CafeteriaCubit.get(context)
                  .editOrderResponseModel!
                  .data!
                  .updateValid ==
              'false') {
            Navigator.pop(context);
            defaultShowDialog(
              context: context,
              content:
                  '${CafeteriaCubit.get(context).editOrderResponseModel!.data!.errorMessage}',
              title: 'تعديل الطلب',
              icon: const Icon(
                Icons.error,
                color: Colors.red,
                size: 40,
              ),
              toDoAfterClosing: () =>
                  CafeteriaCubit.get(context).reloadMyOrderData(),
            );
          }
        }
      },
      builder: (context, state) {
        var cubit = CafeteriaCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: const Text("طلب اليوم"),
            titleSpacing: 5.0,
            leading: IconButton(
              onPressed: () {
                navigateAndReplace(context, const CafeteriaHomeScreen());
              },
              icon: const Icon(
                IconBroken.Arrow___Right_2,
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 10.0,
                ),
                child: defaultQrIconButton(
                  context: context,
                ),
              ),
            ],
          ),
          body: ConditionalBuilder(
            condition: state is! CafeteriaMyOrderLoadingState,
            builder: (context) => Padding(
              padding: const EdgeInsets.all(20.0),
              child: RefreshIndicator(
                child: Column(
                  children: [
                    myCartSummery(
                      myOrderTotalPrice:
                          cubit.myEditedOrderModel?.data!.totalPrice,
                      context: context,
                      cubit: cubit,
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Expanded(
                      child: shopItemBuilder(
                        menuModel: cubit.myEditedOrderModel?.data!.orderList,
                        cubit: cubit,
                        onRefresh: () => cubit.getMyOrderData(),
                      ),
                    ),
                    if (((cubit.dateAndTimeNow?.hour ?? errorTempTime) <
                            timeLimitAllowed) &&
                        (isMyOrderEdited(context)))
                      const SizedBox(
                        height: 40.0,
                      ),
                  ],
                ),
                onRefresh: () => cubit.getMyOrderData(),
              ),
            ),
            fallback: (context) => const Center(
              child: CircularProgressIndicator(),
            ),
          ),
          floatingActionButton: ((cubit.dateAndTimeNow?.hour ?? errorTempTime) <
                      timeLimitAllowed) &&
                  (isMyOrderEdited(context))
              ? ConditionalBuilder(
                  condition: state is! CafeteriaMyOrderLoadingState,
                  builder: (context) => Padding(
                    padding: const EdgeInsets.all(
                      10.0,
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50.0,
                      child: FloatingActionButton(
                        heroTag: "editOrder",
                        elevation: 2.0,
                        shape: ContinuousRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            20.0,
                          ),
                        ),
                        onPressed: () {
                          defaultShowDialog(
                            context: context,
                            content: "هل أنت متأكد من تعديل طلبك",
                            title: 'تعديل الطلب',
                            actions: [
                              defaultAlertActionButtons(
                                context: context,
                                onPressed: () {
                                  cubit.editMyOrderData();
                                },
                              ),
                            ],
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  right: 20.0,
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
                              width: 12.0,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  fallback: (context) {
                    return const SizedBox();
                  },
                )
              : null,
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
        );
      },
    );
  }

  Widget myCartSummery({
    required double? myOrderTotalPrice,
    required BuildContext context,
    required var cubit,
  }) =>
      Center(
        child: Stack(
          alignment: Alignment.topLeft,
          children: [
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
            ),
            if ((cubit.dateAndTimeNow?.hour ?? errorTempTime) <
                timeLimitAllowed)
              Positioned(
                top: -10,
                left: 20,
                child: TextButton(
                  onPressed: () => defaultShowDialog(
                    context: context,
                    content: "هل أنت متأكد من حذف الطلب",
                    title: 'حذف الطلب',
                    actions: [
                      defaultAlertActionButtons(
                        context: context,
                        onPressed: () {
                          cubit.deleteMyOrder();
                        },
                      ),
                    ],
                  ),
                  child: const Text(
                    "حذف",
                    style: TextStyle(color: Colors.red, fontSize: 15.0),
                  ),
                ),
              ),
          ],
        ),
      );
}
