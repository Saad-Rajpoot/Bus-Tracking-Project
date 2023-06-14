import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lu_bird/providers/profile_provider.dart';
import 'package:lu_bird/repository/assigned_bus_repo.dart';
import 'package:lu_bird/view/assigned_bus/assign_bus.dart';
import 'package:provider/provider.dart';
import '../../auth/widgets/snackBar.dart';
import '../../public_widgets/app_colors.dart';

ConstrainedBox buildContainer(int route, List<String> busses,
    BuildContext context, String departureTime, Function getBusses) {
  int rowNum = ((busses.length + 1) / 3).ceil();
  var pro = Provider.of<ProfileProvider>(context, listen: false);

  return ConstrainedBox(
    constraints: BoxConstraints(
      minHeight: (rowNum * 40.h) + 45.h,
    ),
    child: Container(
      margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 25.w),
      //height: 130.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.15),
        borderRadius: BorderRadius.circular(10.sp),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 13.h),
            child: Text(
              "Bus assigned to route $route",
              style: const TextStyle(
                  color: Colors.black54, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: rowNum * 60.h,
            child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: busses.isEmpty ? 1 : 3,
                  childAspectRatio: busses.isEmpty ? 6 : 2,
                ),
                itemCount: busses.length + 1,
                itemBuilder: (BuildContext context, int index) {
                  if (busses.isEmpty && pro.role != "admin") {
                    return Container(
                      padding: EdgeInsets.only(bottom: 12.h),
                      decoration: const BoxDecoration(
                        color: Colors.transparent,
                      ),
                      child: const Center(
                          child: Text(
                        "Not Assigned",
                        style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                    );
                  }
                  if (index == busses.length) {
                    return pro.role == "admin"
                        ? InkWell(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AssignBus(
                                    route: route.toString(),
                                    departureTime: departureTime,
                                  );
                                },
                              ).then((value) {
                                getBusses();
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.all(6.sp),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Center(child: Icon(Icons.add)),
                            ),
                          )
                        : const SizedBox();
                  }
                  return Stack(
                    children: [
                      Container(
                        margin: EdgeInsets.all(6.sp),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(child: Text(busses[index])),
                      ),
                      if (pro.role == "admin")
                        Positioned(
                          right: 0,
                          top: 0,
                          child: InkWell(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              try {
                                bool response = await AssignedBusRepo()
                                    .deleteBus(busses[index]);

                                if (response) {
                                  getBusses();
                                } else {
                                  return snackBar(
                                      context, "Can not remove bus");
                                }
                              } catch (err) {
                                return snackBar(
                                    context, "Something Went Wrong");
                              }
                            },
                            child: Center(
                              child: Icon(
                                Icons.cancel,
                                size: 18.sp,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                }),
          )
        ],
      ),
    ),
  );
}
