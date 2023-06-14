import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../public_widgets/app_colors.dart';


Widget pageIndicator(int pageNumber, BuildContext context) {
  return Row(
    children: [
      InkWell(
        onTap: (){
          Navigator.of(context).pushReplacementNamed("LandingPage");
        },
        child: Container(
          margin: EdgeInsets.only(right: 2.w),
          height: 6.h,
          width: 16.w,
          decoration: BoxDecoration(
            color: pageNumber == 1 ? Colors.black : secondaryColor,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      Container(
        margin: EdgeInsets.only(right: 2.w),
        height: 6.h,
        width: 16.w,
        decoration: BoxDecoration(
          color: pageNumber == 2 ? Colors.black : secondaryColor,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      Container(
        decoration: BoxDecoration(
          color: pageNumber == 3 ? Colors.black : secondaryColor,
          borderRadius: BorderRadius.circular(10),
        ),
        height: 6.h,
        width: 16.w,
      )
    ],
  );
}
