import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lu_bird/view/public_widgets/app_colors.dart';

import '../../profile/sub_page/bus_and_routine.dart';

SizedBox buildExplore() {
  List<Color> colors = [
    const Color(0xff2B4865),
    const Color(0xff355764),
    const Color(0xff3C6F9C)
  ];

  List<IconData> icons = [
    FontAwesomeIcons.bell,
    FontAwesomeIcons.clipboardList,
    FontAwesomeIcons.calendarWeek,
  ];

  List<String> titles = [
    "Notices",
    "Bus Schedule",
    "Class Routine",
  ];

  return SizedBox(
    width: 360.w,
    //padding: EdgeInsets.symmetric(horizontal: 30.w),
    child: Column(
      children: [
        SizedBox(height: 70.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Explore",
                style: TextStyle(
                    fontSize: 36.sp,
                    fontWeight: FontWeight.w800,
                    color: Color(0xff3F4E4F)),
              ),
            ],
          ),
        ),
        Container(
          height: 250.h,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                spreadRadius: 3,
                blurRadius: 15,
              )
            ],
          ),
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  if (index == 0) {
                    Navigator.of(context).pushNamed("Notice");
                  } else if (index == 1) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BusSchedule(name: "Bus Schedule"),
                      ),
                    );
                  } else if (index == 2) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BusSchedule(name: "Routine"),
                      ),
                    );
                  }
                },
                child: Container(
                  width: 150.w,
                  height: 220.h,
                  margin: EdgeInsets.fromLTRB(
                      index == 0 ? 30.w : 10.w, 20.w, 10.w, 30.w),
                  decoration: BoxDecoration(
                    color: colors[index],
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 10,
                          spreadRadius: 2,
                          offset: const Offset(0, 7))
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        icons[index],
                        size: 50.sp,
                        color: Colors.white,
                      ),
                      SizedBox(height: 15.h),
                      Text(
                        titles[index],
                        style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w800),
                      )
                    ],
                  ),
                ),
              );
            },
            itemCount: 3,
          ),
        )
      ],
    ),
  );
}
