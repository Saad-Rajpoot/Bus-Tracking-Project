import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../public_widgets/app_colors.dart';

Padding switchPageButton(String text1, String text2,BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 1),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          text1,
          style: TextStyle(
            fontSize: 13.sp,
            color: Theme.of(context).primaryColor
          ),
        ),
        const Spacer(),
        GestureDetector(
          onTap: () {
            if (text2 == "Register now") {
              Navigator.of(context).pushReplacementNamed("Registration");
            } else {
              Navigator.of(context).pushReplacementNamed("SignIn");
            }
          },
          child: Text(
            text2,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
              color: secondaryColor,
            ),
          ),
        )
      ],
    ),
  );
}