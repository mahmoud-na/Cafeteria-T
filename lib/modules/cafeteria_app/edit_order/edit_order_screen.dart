import 'package:cafeteriat/layout/cafeteria_app/cafeteria_app_layout.dart';
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
          );
        }
        if (state is CafeteriaEditMyOrderSuccessState) {
          if (CafeteriaCubit.get(context)
                  .editOrderResponseModel!
                  .data!
                  .updateValid ==
              'true') {
            await CafeteriaCubit.get(context).getMyOrderData();
            Navigator.pop(context);
            showToast(msg: 'تم تعديل طلبك بنجاح', state: ToastStates.SUCCESS);
          } else if (CafeteriaCubit.get(context)
                  .editOrderResponseModel!
                  .data!
                  .updateValid ==
              'false') {
            Navigator.pop(context);
            showToast(
                msg:
                    '${CafeteriaCubit.get(context).editOrderResponseModel!.data!.errorMessage}',
                state: ToastStates.ERROR);
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
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Expanded(
                      child: shopItemBuilder(
                        menuModel: cubit.myEditedOrderModel?.data!.orderList,
                      ),
                    ),
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
          floatingActionButton: (cubit.dateAndTimeNow?.hour ?? errorTempTime) <
                  timeLimitAllowed
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
