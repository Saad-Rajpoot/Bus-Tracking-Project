import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lu_bird/view/auth/widgets/snackBar.dart';

Container customTextField(TextEditingController controller, String text,
    BuildContext context, IconData iconData) {
  return Container(
    height: 50.h,
    width: 340.w,
    padding: EdgeInsets.fromLTRB(10, 2, 10, 0),
    decoration: BoxDecoration(
      color: const Color(0xffC4C4C4).withOpacity(0.2),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Center(
      child: TextFormField(
          controller: controller,
          keyboardAppearance: Brightness.light,
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (text == "Full name") {
              if (value != null && value.length > 50) {
                snackBar(context, "Name should be less then 50 character");
                return "Name should be less then 50 character";
              } else if (value == null || value.isEmpty) {
                snackBar(context, "Field can not be empty!");
                return "Field can not be empty!";
              } else if (isNameValid(value)) {
                snackBar(context, "Name should contain only character");
                return "Name should contain only character";
              }
            } else if (text == "Valid email" || text == "Enter your email") {
              if (value != null && !value.contains("@lus.ac.bd")) {
                snackBar(context, "You have to use LU G Suite Email");
                return "You have to use LU G Suite Email";
              } else if (value == null || value.isEmpty) {
                snackBar(context, "Field can not be empty!");
                return "Field can not be empty!";
              }
            } else if (text == "Password") {
              if (value != null && value.length < 6) {
                snackBar(
                    context, "Password should be at least 6 character long");
                return "Password should be at least 6 character long";
              } else if (value == null || value.isEmpty) {
                snackBar(context, "Field can not be empty!");
                return "Field can not be empty!";
              }
            } else if (text == "Department") {
              if (value != null && value.length > 20) {
                snackBar(context, "Please enter short form of your department");
                return "Please enter short form of your department";
              } else if (value == null || value.isEmpty) {
                snackBar(context, "Field can not be empty!");
                return "Field can not be empty!";
              }
            } else if (value == null || value.isEmpty) {
              snackBar(context, "Field can not be empty!");
              return "Field can not be empty!";
            }
            return null;
          },
          obscureText: text == "Password" ? true : false,
          decoration: InputDecoration(
            suffixIcon: Icon(iconData),
            errorStyle: const TextStyle(fontSize: 0.01),
            filled: true,
            fillColor: Colors.transparent,
            border: InputBorder.none,
            hintText: text,
            hintStyle: TextStyle(
              color: Colors.black.withOpacity(0.5),
              fontSize: 14.sp,
            ),
          )),
    ),
  );
}

bool isNameValid(String name) {
  if (name.isEmpty) {
    return false;
  }
  bool hasDigits = name.contains(RegExp(r'[0-9]'));
  bool hasSpecialCharacters = name.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

  return hasDigits & hasSpecialCharacters;
}
