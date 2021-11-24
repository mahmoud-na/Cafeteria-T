import 'package:cafeteriat/layout/cafeteria_app/cubit/cubit.dart';
import 'package:cafeteriat/layout/cafeteria_app/cubit/states.dart';
import 'package:cafeteriat/modules/cafeteria_app/edit_order/edit_order_screen.dart';
import 'package:cafeteriat/shared/components/components.dart';
import 'package:cafeteriat/shared/styles/icon_broken.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CheckOutScreen extends StatelessWidget {
  const CheckOutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CafeteriaCubit, CafeteriaStates>(
      listener: (context, state) async {
        if (state is ClearMyCartSuccessState) {
          Navigator.pop(context);
        }
        if (state is CafeteriaPostMyOrderLoadingState) {
          Navigator.pop(context);
          defaultShowDialog(
            closeable: false,
            context: context,
            content: "جاري إتمام الطلب برجاء الإنتظار...",
            title: 'إتمام الطلب',
            icon: const SizedBox(
              height: 20.0,
              width: 20.0,
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (state is CafeteriaPostMyOrderSuccessState) {
          Navigator.pop(context);
           defaultShowDialog(
            context: context,
            title:
                "تم تأكيد طلب رقم ${CafeteriaCubit.get(context).myOrderModel!.data!.orderNumber}",
            content: "يمكنك مراجعة الطلب من صفحة ",
            defaultTextButton: defaultTextButton(
              text: 'طلب اليوم',
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
                navigateTo(
                  context,
                  const MyOrderScreen(),
                );
              },
            ),
            icon: const Icon(
              Icons.verified,
              color: Colors.green,
              size: 40,
            ),
             toDoAfterClosing: () async {
               await CafeteriaCubit.get(context).clearMyCart();
               await CafeteriaCubit.get(context).getMenuData();
             },
          );
          await CafeteriaCubit.get(context).refreshMyOrder();
        }
      },
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
            actions: [
              defaultTextButton(
                text: "خذف السلة",
                onPressed: () {
                  defaultShowDialog(
                    context: context,
                    content: "هل أنت متأكد من خذف السلة",
                    title: 'خذف السلة',
                    actions: [
                      defaultAlertActionButtons(
                        context: context,
                        onPressed: () async {
                          cubit.clearMyCart();
                          cubit.getMenuData();
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                myCartSummery(
                  myCartTotalItem: cubit.myCartDataModel!.totalItems,
                  myCartTotalPrice: cubit.myCartDataModel!.totalPrice,
                  context: context,
                ),
                Expanded(
                  child: shopItemBuilder(
                    menuModel: cubit.myCartDataModel!.products,
                  ),
                ),
                const SizedBox(
                  height: 60.0,
                ),
              ],
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
                onPressed: () {
                  defaultShowDialog(
                    context: context,
                    content:
                        "هل أنت متأكد من إتمام طلبك...\n\n مع العلم انه لا يمكنك تعديل أو حذف الطلب بعد الساعة التاسعة صباحاً",
                    title: 'تأكيد الطلب',
                    actions: [
                      defaultAlertActionButtons(
                        context: context,
                        onPressed: () {
                          cubit.postMyOrderData(context);
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
                          right: 50.0,
                        ),
                        child: Text(
                          "إدفع",
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
