import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'widgets/page_indicator.dart';
import 'widgets/round_button.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(25.sp),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset("assets/landingPage.png"),
              SizedBox(height: 80.h),
              SizedBox(
                width: 200.w,
                child: Text(
                  "Track the Bus easily",
                  style:
                      TextStyle(fontSize: 36.sp, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 5.h),
              Text(
                "GPGC Mandian",
                style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w300),
              ),
              SizedBox(height: 60.h),
              Row(
                children: [
                  pageIndicator(1, context),
                  const Spacer(),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed("SignIn");
                    },
                    child: roundButton(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
