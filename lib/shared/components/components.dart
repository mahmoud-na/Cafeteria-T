import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cafeteriat/layout/cafeteria_app/cubit/cubit.dart';
import 'package:cafeteriat/layout/cafeteria_app/cubit/states.dart';
import 'package:cafeteriat/models/cafeteria_app/history_model.dart';
import 'package:cafeteriat/models/cafeteria_app/product_model.dart';
import 'package:cafeteriat/modules/cafeteria_app/current_history_order_details/current_history_order_details_screen.dart';
import 'package:cafeteriat/shared/components/constants.dart';
import 'package:cafeteriat/shared/styles/colors.dart';
import 'package:cafeteriat/shared/styles/icon_broken.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

Widget defaultButton({
  double width = double.infinity,
  double height = 40.0,
  bool isUpperCase = true,
  double borderRadius = 3.0,
  required VoidCallback onPressed,
  required String text,
  required BuildContext context,
}) =>
    Container(
      width: width,
      height: height,
      child: MaterialButton(
        onPressed: onPressed,
        child: Text(
          isUpperCase ? text.toUpperCase() : text,
          style: Theme.of(context).textTheme.headline6!.copyWith(
                color: Colors.white,
              ),
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
      child: Text(
        text,
        textDirection: TextDirection.rtl,
      ),
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: const Size(10.0, 10.0),
        // alignment: Alignment.centerRight,
      ),
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
  var maxLength,
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
      maxLength: maxLength,
      enableInteractiveSelection: enableInteractiveSelection,
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
      ),
      // maxLengthEnforcement:MaxLengthEnforcement.enforced ,
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
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
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
  required var cubit,
  required BuildContext context,
}) =>
    Stack(
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
                  imageUrl: menuModel.image!,
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
                      const SizedBox(height: 10.0,),
                      Text(
                        "${menuModel.name}",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          height: 1.0,
                          fontSize: 20.0,
                        ),
                      ),
                      Text(
                        "${menuModel.price}",
                        style: const TextStyle(
                          height: 1.5,
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
                              menuModel,
                              context,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        if (menuModel.runtimeType == ProductDataModel)
          if (menuModel.quantity == 0)
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.all(8.0),
                  width: double.infinity,
                  height: 134.0,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.8),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(5.0),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error,
                      color: Colors.amberAccent,
                    ),
                    const SizedBox(
                      width: 5.0,
                    ),
                    Text(
                      "عذراً، لقد نفذت الكمية برجاء إختيار منتج اخر",
                      style: Theme.of(context).textTheme.bodyText1,
                    ),

                  ],
                )
              ],
            ),
      ],
    );

Widget shopItemBuilder({
  required var menuModel,
  required var cubit,
  required Function() onRefresh,
}) {
  return ConditionalBuilder(
    condition: menuModel != null,
    builder: (context) => ListView.separated(
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      itemBuilder: (context, index) => shopItem(
        menuModel: menuModel[index],
        context: context,
        cubit: cubit,
      ),
      separatorBuilder: (context, index) => myVDivider(),
      itemCount: menuModel.length,
    ),
    fallback: (context) {
      return cubit.menuTimerFire
          ? connectionError(onRefresh: onRefresh)
          : const Center(
              child: CircularProgressIndicator(),
            );
    },
  );
}

Widget connectionError({
  required Function() onRefresh,
}) =>
    Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            height: 100.0,
          ),
          Image.asset(
            "assets/images/landscape.png",
            width: 130.0,
            height: 130.0,
            color: Colors.grey,
          ),
          const SizedBox(
            height: 30.0,
          ),
          const Text(
            "لا يوجد إتصال بالإنترنت",
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          const Text(
            "تعذر الحصول على البيانات برجاء المحاولة مرة أخرى",
            style: TextStyle(
              fontWeight: FontWeight.normal,
              color: Colors.grey,
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
          IconButton(
            onPressed: onRefresh,
            icon: const Icon(
              Icons.refresh,
              size: 40.0,
            ),
          ),
        ],
      ),
    );

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
                ),
              );
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
  required bool historyTimerFire,
  required Function() onRefresh,
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
      fallback: (context) {
        return historyTimerFire
            ? connectionError(onRefresh: onRefresh)
            : const Center(
                child: CircularProgressIndicator(),
              );
      },
    );

Widget historyOrderDetailsItem({
  required HistoryOrdersModel? historyOrderDetailsListModel,
}) =>
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
            child: (historyOrderDetailsListModel.orderStatus)!
                ? const Icon(
                    Icons.verified,
                    color: Colors.green,
                  )
                : const Text(
                    '-',
                  ),
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

Widget defaultQrIconButton({
  required BuildContext context,
}) =>
    IconButton(
      onPressed: () => WidgetsBinding.instance!.addPostFrameCallback(
        (_) => showQrFunction(
          context: context,
        ),
      ),
      icon: const Icon(
        Icons.qr_code_outlined,
        size: 30.0,
      ),
    );

Future showQrFunction({required BuildContext context, req}) => showDialog(
      context: context,
      builder: (context) => Dialog(
        insetPadding: const EdgeInsets.all(12.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Colors.black,
              width: 10.0,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: qrImage,
        ),
      ),
    );

Future<void> defaultShowDialog({
  required BuildContext context,
  required String title,
  required String content,
  VoidCallback? toDoAfterClosing,
  bool closeable = true,
  Widget? icon,
  List<Widget>? actions,
  Widget? defaultTextButton,
}) async =>
    WidgetsBinding.instance!.addPostFrameCallback(
      (_) => showDialog(
        context: context,
        builder: (context) => WillPopScope(
          onWillPop: () async => closeable,
          child: AlertDialog(
            contentPadding: const EdgeInsets.all(
              15.0,
            ),
            titlePadding: const EdgeInsets.only(
              top: 15.0,
            ),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              textBaseline: TextBaseline.alphabetic,
              children: [
                defaultTextButton ?? const SizedBox(),
                Flexible(
                  fit: FlexFit.loose,
                  flex: 2,
                  child: Text(
                    content,
                    textDirection: TextDirection.rtl,
                    softWrap: true,
                    // textAlign: TextAlign.justify,
                  ),
                ),
              ],
            ),
            title: Column(
              children: [
                icon ?? const SizedBox(),
                Text(
                  title,
                ),
                const Divider(
                  color: Colors.grey,
                  indent: 30,
                  endIndent: 30,
                ),
              ],
            ),
            buttonPadding: EdgeInsets.zero,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(20.0),
              ),
            ),
            actions: actions,
          ),
        ),
      ).then(
        (value) {
          if (toDoAfterClosing != null) {
            toDoAfterClosing();
          }
        },
      ),
    );

Widget defaultAlertActionButtons({
  required BuildContext context,
  required VoidCallback onPressed,
}) =>
    Row(
      children: <Widget>[
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  width: 1.5,
                  color: Colors.grey.shade200,
                ),
                right: BorderSide(
                  width: 1.5,
                  color: Colors.grey.shade200,
                ),
              ),
            ),
            child: TextButton(
              child: const Text(
                'إلغاء',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 18.0,
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  width: 1.5,
                  color: Colors.grey.shade200,
                ),
              ),
            ),
            child: TextButton(
              child: const Text(
                'تأكيد',
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  fontSize: 18.0,
                ),
              ),
              onPressed: onPressed,
            ),
          ),
        ),
      ],
    );
