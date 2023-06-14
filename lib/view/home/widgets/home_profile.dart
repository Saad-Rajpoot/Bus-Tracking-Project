import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:lu_bird/view/public_widgets/app_colors.dart';

import '../../../providers/profile_provider.dart';

Positioned buildHomeProfile(BuildContext context) {
  return Positioned(
    top: 40.h,

    child: Consumer<ProfileProvider>(
      builder: (context, provider, child) {
        return Container(
          padding: EdgeInsets.fromLTRB(25.w, 43.h, 25.w, 10.h),

          width: 360.w,
          child: Row(
            children: [
              provider.profileUrl != ""
                  ? GestureDetector(
                      onTap: () {

                        Navigator.of(context)
                            .pushNamed("Profile");
                      },
                      child: CircleAvatar(
                        backgroundColor: Colors.grey,
                        radius: 21,
                        backgroundImage: NetworkImage(
                          provider.profileUrl,
                        ),
                      ),
                    )
                  : GestureDetector(
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed("Profile");
                      },
                      child: const CircleAvatar(
                        backgroundColor: Colors.grey,
                        radius: 21,
                        backgroundImage: AssetImage("assets/profile.jpg"),
                      ),
                    ),
              Padding(
                padding: EdgeInsets.only(left: 20.sp),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Welcome  👋",
                      style: TextStyle(
                          fontSize: 12.sp, color: Colors.black.withOpacity(0.6)),
                    ),
                    Text(
                      provider.profileName.isEmpty
                          ? "Unknown"
                          : provider.profileName,
                      style:
                          TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
                    )
                  ],
                ),
              ),
              /*const Spacer(),
              InkWell(
                onTap: () {
                  Navigator.of(context).pushNamed("GPSSetting");
                },
                child: Icon(
                  FontAwesomeIcons.gear,
                  size: 18.sp,
                ),
              )*/
            ],
          ),
        );
      },
    ),
  );
}
