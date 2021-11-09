import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

Widget defaultButton({
  double width = double.infinity,
  Color backgroundColor = Colors.blue,
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
        color: backgroundColor,
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


// PreferredSizeWidget defaultAppBar({
//   required BuildContext context,
//   String? title,
//   List<Widget>? actions,
// }) =>
//     AppBar(
//       titleSpacing: 5.0,
//       leading: IconButton(
//         onPressed: () {
//           Navigator.pop(context);
//         },
//         icon: const Icon(
//           IconBroken.Arrow___Left_2,
//         ),
//       ),
//       title: Text(title!),
//       actions: actions,
//     );



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


Widget myDivider() => Padding(
  padding: const EdgeInsets.all(20.0),
  child: Container(
    width: double.infinity,
    height: 1.0,
    color: Colors.grey[300],
  ),
);


void navigateTo(context, Widget widget) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => widget,
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
