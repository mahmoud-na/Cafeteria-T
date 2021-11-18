import 'package:cached_network_image/cached_network_image.dart';
import 'package:cafeteriat/layout/cafeteria_app/cubit/cubit.dart';
import 'package:cafeteriat/layout/cafeteria_app/cubit/states.dart';
import 'package:cafeteriat/models/cafeteria_app/history_model.dart';
import 'package:cafeteriat/models/cafeteria_app/product_model.dart';
import 'package:cafeteriat/modules/cafeteria_app/current_history_order_details/current_history_order_details_screen.dart';
import 'package:cafeteriat/shared/styles/colors.dart';
import 'package:cafeteriat/shared/styles/icon_broken.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

Widget defaultButton({
  double width = double.infinity,
  bool isUpperCase = true,
  double borderRadius = 3.0,
  required VoidCallback onPressed,
  required String text,
}) =>
    Container(
      width: width,
      height: 40.0,
      child: MaterialButton(
        onPressed: onPressed,
        child: Text(
          isUpperCase ? text.toUpperCase() : text,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        color: defaultColor,
      ),
    );

Widget defaultTextButton({
  required String text,
  required Function()? onPressed,
}) =>
    TextButton(
      onPressed: onPressed,
      child: Text(text.toUpperCase()),
    );

PreferredSizeWidget defaultAppBar({
  required BuildContext context,
  String? title,
  List<Widget>? actions,
}) =>
    AppBar(
      titleSpacing: 5.0,
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(
          IconBroken.Arrow___Left_2,
        ),
      ),
      title: Text(title!),
      actions: actions,
    );

Widget defaultFormField({
  required TextEditingController textEditingController,
  required TextInputType textInputType,
  required String labelText,
  required Widget prefixIcon,
  Widget? suffixIcon,
  bool obscureText = false,
  bool enableInteractiveSelection = true,
  required String? Function(String? value) validator,
  Function(String value)? onFieldSubmitted,
  Function(String value)? onChanged,
  Function()? onTap,
}) =>
    TextFormField(
      controller: textEditingController,
      obscureText: obscureText,
      keyboardType: textInputType,
      validator: validator,
      onFieldSubmitted: onFieldSubmitted,
      onChanged: onChanged,
      onTap: onTap,
      focusNode: FocusNode(),
      enableInteractiveSelection: enableInteractiveSelection,
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
      ),
    );

Widget defaultListTile({
  required String title,
  Widget? icon,
  required Function() onTap,
}) =>
    ListTile(
      title: Text(
        title,
      ),
      leading: icon,
      onTap: onTap,
    );

Widget myVDivider() => Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 5.0,
        horizontal: 20.0,
      ),
      child: Container(
        width: double.infinity,
        height: 0.6,
        color: defaultColor,
      ),
    );

Widget myHDivider() => Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 5.0,
      ),
      child: Container(
        width: 0.6,
        height: double.infinity,
        color: defaultColor,
      ),
    );

void navigateTo(context, Widget widget) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: widget,
      ),
    ),
  );
}

void navigateAndReplace(context, Widget widget) {
  Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
      (route) => false);
}

void showToast({
  required String msg,
  required ToastStates state,
}) =>
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 5,
      backgroundColor: chooseToastColor(state),
      textColor: Colors.white,
      fontSize: 16.0,
    );

enum ToastStates { SUCCESS, ERROR, WARNING }

Color chooseToastColor(ToastStates state) {
  Color color;
  switch (state) {
    case ToastStates.SUCCESS:
      color = Colors.green;
      break;
    case ToastStates.ERROR:
      color = Colors.red;
      break;
    case ToastStates.WARNING:
      color = Colors.amber;
      break;
  }
  return color;
}

Widget defaultIconButton({
  required Function() onPressed,
  required IconData icon,
}) =>
    IconButton(
      onPressed: onPressed,
      icon: Icon(
        icon,
        color: defaultColor,
        size: 40.0,
      ),
    );

Widget shopItem({
  required var menuModel,
}) =>
    BlocConsumer<CafeteriaCubit, CafeteriaStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = CafeteriaCubit.get(context);
        return Column(
          children: [
            SizedBox(
              height: 150.0,
              child: Card(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                elevation: 15.0,
                margin: const EdgeInsets.all(
                  8.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CachedNetworkImage(
                      key: UniqueKey(),
                      imageUrl: menuModel.image,
                      height: 150.0,
                      width: 150.0,
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      placeholder: (context, url) {
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        );
                      },
                      errorWidget: (context, url, error) {
                        return Container(
                          decoration: const BoxDecoration(
                            color: Colors.black12,
                          ),
                          child: const Icon(
                            Icons.fastfood,
                            color: Colors.red,
                            size: 30,
                          ),
                        );
                      },
                    ),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "${menuModel.name}",
                            style: const TextStyle(
                              fontSize: 20.0,
                            ),
                          ),
                          Text(
                            "${menuModel.price}",
                            style: const TextStyle(
                              fontSize: 20.0,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: cubit.shopItemAddIcon(menuModel),
                              ),
                              Container(
                                alignment: Alignment.center,
                                width: 43.0,
                                child: Text(
                                  "${menuModel.counter}",
                                  style: const TextStyle(
                                    fontSize: 24.0,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              Expanded(
                                  child: cubit.shopItemRemoveIcon(
                                      menuModel, context)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );

Widget shopItemBuilder({
  required var menuModel,
  required var state,
}) {
  return ConditionalBuilder(
      condition: menuModel != null,
      builder: (context) => SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) => shopItem(
            menuModel: menuModel[index],
          ),
          separatorBuilder: (context, index) => myVDivider(),
          itemCount: menuModel.length,
        ),
      ),
      fallback: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
}

String dateFormatting(HistoryDataModel historyModel) {
  dateFormattingHelper(
      int startChar, int endChar, HistoryDataModel historyModel) {
    return int.parse(historyModel.dateTime!.substring(startChar, endChar));
  }

  String formattedDate =
      "${historyModel.dateTime!.substring(0, 3)} ${dateFormattingHelper(4, 6, historyModel)}, ${dateFormattingHelper(12, 14, historyModel) > 12 ? dateFormattingHelper(12, 14, historyModel) - 12 : dateFormattingHelper(12, 14, historyModel)}${historyModel.dateTime!.substring(14, 17)}";
  return formattedDate;
}

Widget historyItem({
  required HistoryDataModel? historyModel,
  required int index,
}) =>
    BlocConsumer<CafeteriaCubit, CafeteriaStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return GestureDetector(
          onTap: () {
            if (historyModel!.payType == 'Prepaid') {
              navigateTo(
                  context,
                  CurrentHistoryOrderDetailsScreen(
                    historyOrderDetailsModel: historyModel,
                  ));
            }
          },
          child: SizedBox(
            child: Card(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              elevation: 7.0,
              margin: const EdgeInsets.all(
                8.0,
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      dateFormatting(historyModel!),
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    myVDivider(),
                    if (historyModel.orderNumber != null)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "رقم الطلب: ",
                          ),
                          Text(
                            "${historyModel.orderNumber}",
                          ),
                        ],
                      ),
                    Row(
                      children: [
                        const Text("السعر الكلي: "),
                        const SizedBox(
                          width: 10.0,
                        ),
                        Text("${historyModel.price}"),
                      ],
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      children: [
                        const Text("طريقة الدفع: "),
                        const SizedBox(
                          width: 10.0,
                        ),
                        historyModel.payType == "Prepaid"
                            ? const Text("دفع مسبق")
                            : const Text("دفع عند الإستلام"),
                        if (historyModel.payType == "Prepaid")
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: const [
                                Text(
                                  "تفاصيل الطلب",
                                ),
                                Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );

Widget historyItemBuilder({
  required List<HistoryDataModel>? historyModel,
  required var state,
}) =>
    ConditionalBuilder(
      condition: historyModel != null,
      builder: (context) => SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) => historyItem(
            historyModel: historyModel![index],
            index: index,
          ),
          separatorBuilder: (context, index) => myVDivider(),
          itemCount: historyModel!.length,
        ),
      ),
      fallback: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

Widget historyOrderDetailsItem(
        {required HistoryOrdersModel? historyOrderDetailsListModel}) =>
    Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Center(
            child: Text(
              "${historyOrderDetailsListModel!.name}",
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: Text(
              "${historyOrderDetailsListModel.counter}",
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: Text(
              "${historyOrderDetailsListModel.price}",
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: (historyOrderDetailsListModel.orderStatus)!?
           const Icon(
                    Icons.verified,
                    color: Colors.green,
                  ): const Text('-',),
          ),
        ),
      ],
    );

Widget historyOrderDetailsBuilder({
  required HistoryDataModel? historyOrderDetailsListModel,
}) =>
    SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) => historyOrderDetailsItem(
          historyOrderDetailsListModel:
              historyOrderDetailsListModel!.ordersList[index],
        ),
        separatorBuilder: (context, index) => myVDivider(),
        itemCount: historyOrderDetailsListModel!.ordersList.length,
      ),
    );
