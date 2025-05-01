import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

// زر ثابت
Widget default_button({
  double width = double.infinity,
  Color background = Colors.blue,
  bool isUpperCase = true,
  double radius = 10.0,
  required VoidCallback function,
  required String text,
}) =>
    Container(
      width: width,
      height: 50.0,
      child: MaterialButton(
        onPressed: function,
        child: Text(
          isUpperCase ? text.toUpperCase() : text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18.0,
          ),
        ),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: background,
      ),
    );

// TextFormField ثابت
Widget default_Text_form({
  required TextEditingController controller,
  required TextInputType textInputType,
  required String labelText,
  required IconData prefixIcon,
  IconButton? suffixIcon,
  bool isPassword = false,
  FormFieldValidator<String>? validator,
  VoidCallback? onTap,
}) =>
    TextFormField(
      controller: controller,
      keyboardType: textInputType,
      obscureText: isPassword,
      validator: validator,
      onTap: onTap,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(prefixIcon),
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(),
      ),
    );

// انواع التوست
enum ToastStates { SUCCESS, ERROR, WARNING }

// اختيار اللون حسب نوع التوست
Color chooseToastColor(ToastStates state) {
  switch (state) {
    case ToastStates.SUCCESS:
      return Colors.green;
    case ToastStates.ERROR:
      return Colors.red;
    case ToastStates.WARNING:
      return Colors.amber;
  }
}

// عرض رسالة توست
void toast({
  required String message,
  required ToastStates state,
}) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: chooseToastColor(state),
    textColor: Colors.white,
    fontSize: 16.0,
  );
}
enum toast_states {sucess,fail,warning}
// التنقل وحذف الصفحة السابقة
void navigateAndFinish(BuildContext context, Widget widget) {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => widget),
        (Route<dynamic> route) => false,
  );
}
