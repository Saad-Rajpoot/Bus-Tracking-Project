import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';

Widget flatButton({required String name, double? height, double? width}) {
  return Container(
    margin: EdgeInsets.only(right: 2.w),
    height: height ?? 40.h,
    width: width ?? 140.w,
    decoration: BoxDecoration(
      color: Colors.black,
      borderRadius: BorderRadius.circular(10.sp),
    ),
    child: Row(
      children: [
        const Spacer(),
        const Spacer(),
        Text(
          name,
          style: TextStyle(
              fontSize: 13.sp,
              color: Colors.white,
              fontWeight: FontWeight.w700),
        ),
        const Spacer(),
        Padding(
          padding: EdgeInsets.only(right: 10.w),
          child: Icon(
            Icons.arrow_forward_ios,
            color: Colors.white,
            size: 14.sp,
          ),
        ),
      ],
    ),
  );
}
