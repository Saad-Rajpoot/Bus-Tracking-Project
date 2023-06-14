import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';

Widget roundButton() {
  return Container(
    margin: EdgeInsets.only(right: 2.w),
    height: 50.sp,
    width: 50.sp,
    decoration: BoxDecoration(
      color: Colors.black,
      borderRadius: BorderRadius.circular(100),
    ),
    child: const Icon(
      Icons.arrow_forward_ios,
      color: Colors.white,
    ),
  );
}
