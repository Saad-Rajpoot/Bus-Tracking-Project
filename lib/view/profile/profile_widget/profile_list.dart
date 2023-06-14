import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lu_bird/view/public_widgets/app_colors.dart';

Widget profileList(String text, IconData iconData) {

  return Padding(
    padding: EdgeInsets.fromLTRB(25.w, 5.h, 25.w, 0),
    child: Column(
      children: [
        Row(
          children: [
            Container(
              height: 35.sp,
              width: 35.sp,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: primaryColor.withOpacity(0.2),
              ),
              child: Icon(
                iconData,
                color: primaryColor,
                size: 17.sp,
              ),
            ),
            const SizedBox(width: 20),
            Text(
              text,
              style: TextStyle(
                  color: const Color(0xff383840),
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500),
            ),
            const Spacer(),

            Icon(
              Icons.arrow_forward_ios,
              size: 18.sp,
              color: Colors.grey,
            ),
          ],
        ),
        SizedBox(height: 5.h),
        Divider(
          color: primaryColor.withOpacity(0.1),
        )
      ],
    ),
  );
}
