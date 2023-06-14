import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lu_bird/view/public_widgets/app_colors.dart';

Container customButton({
  double? height,
  double? width,
  required String text,
  double? fontSize,
  Color? color
}) {
  return Container(
    height: height ?? 55.h,
    width: width ?? double.infinity,
    decoration: BoxDecoration(
      color: color?? primaryColor,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Center(
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize ?? 18.sp,
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
  );
}
