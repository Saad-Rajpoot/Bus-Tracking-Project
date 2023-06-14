import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lu_bird/view/public_widgets/app_colors.dart';

class BusInfo extends StatelessWidget {
  const BusInfo({Key? key}) : super(key: key);

  static const List<Color> colors = [
    Color(0xff6D9886),
    Color(0xff625757),
    Color(0xff30475E),
    Color(0xffF96666),
    Color(0xff999B84),
  ];

  static const List<String> text = [
    "This color line in the map represents the common route.",
    "This color line in the map represents route 1.",
    "This color line in the map represents route 2.",
    "This color line in the map represents route 3.",
    "This color line in the map represents route 4.",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bus Info", style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: ListView.builder(
        padding: EdgeInsets.only(top: 20.h, bottom: 60.h),
        physics: const BouncingScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return Container(
              padding: EdgeInsets.fromLTRB(30.w, 6.h, 30.w, 20.h),
              height: 330.h,
              width: 100.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Bus Icon :",
                    style: TextStyle(
                        color: primaryColor,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 15.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 150.h,
                        child: Image.asset("assets/bus.png"),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    "This marker on the map represents the location of a single bus. Tap on the marker to see more information, like the route number and available seats.",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              if (index == 1)
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 20.h, left: 30.w),
                      child: Text(
                        "Bus Routes :",
                        style: TextStyle(
                            color: primaryColor,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              buildContainer(colors[index - 1]),
              buildText(text[index - 1])
            ],
          );
        },
        itemCount: colors.length + 1,
      ),
    );
  }

  Padding buildText(String text) {
    return Padding(
      padding: EdgeInsets.fromLTRB(30.w, 6.h, 30.w, 20.h),
      child: Text(
        text,
        style: TextStyle(
          color: primaryColor,
          fontSize: 15.sp,
        ),
      ),
    );
  }

  Container buildContainer(Color color) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.fromLTRB(30.w, 0, 30.w, 0),
      height: 15.h,
      decoration: BoxDecoration(
          color: color, borderRadius: BorderRadius.circular(10.sp)),
    );
  }
}
