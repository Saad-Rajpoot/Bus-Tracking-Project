import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lu_bird/models/assigned_bus_model.dart';
import 'package:lu_bird/providers/profile_provider.dart';
import 'package:lu_bird/repository/assigned_bus_repo.dart';
import 'package:lu_bird/view/assigned_bus/assign_bus.dart';
import 'package:lu_bird/view/assigned_bus/widgets/top_list.dart';
import 'package:provider/provider.dart';

import '../auth/widgets/snackBar.dart';
import '../public_widgets/app_colors.dart';
import '../public_widgets/custom_loading.dart';

class AssignedBus extends StatefulWidget {
  const AssignedBus({Key? key}) : super(key: key);

  @override
  State<AssignedBus> createState() => _AssignedBusState();
}

class _AssignedBusState extends State<AssignedBus> {
  List<String> busTime = ["12 pm", "1 pm", "2 pm", "2.45 pm", "4 pm"];
  late int selectedIndex;
  bool isLoading = true;
  List<String> route1 = [];
  List<String> route2 = [];
  List<String> route3 = [];
  List<String> route4 = [];

  late ScrollController scrollController;

  @override
  void initState() {
    setIndex();
    getBusses();

    scrollController = ScrollController(
      initialScrollOffset: selectedIndex * 110.0, // or whatever offset you wish
      keepScrollOffset: true,
    );
    super.initState();
  }

  Future<void> getBusses() async {
    setState(() {
      isLoading = true;
    });

    List<AssignedBusModel> response = [];
    try {
      response =
          await AssignedBusRepo().getAssignedBusses(busTime[selectedIndex]);
    } catch (err) {
      snackBar(context, "Something Went Wrong");
    }

    route1.clear();
    route2.clear();
    route3.clear();
    route4.clear();

    for (var e in response) {
      if (e.route == '1' && e.busNumber != null) {
        route1.add(e.busNumber!);
      } else if (e.route == '2' && e.busNumber != null) {
        route2.add(e.busNumber!);
      } else if (e.route == '3' && e.busNumber != null) {
        route3.add(e.busNumber!);
      } else if (e.route == '4' && e.busNumber != null) {
        route4.add(e.busNumber!);
      }
    }

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var pro = Provider.of<ProfileProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Assigned Bus",
          style: TextStyle(
            fontSize: 19.sp,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
      ),
      body: ListView(
        physics: const NeverScrollableScrollPhysics(),
        children: [
          SizedBox(height: 10.h),
          Container(
            padding: EdgeInsets.only(left: 22.w),
            height: 50.h,
            width: double.infinity,
            child: ListView.builder(
              controller: scrollController,
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    selectedIndex = index;
                    pro.refreshAssignBusPage();
                    getBusses();
                  },
                  child: Container(
                    height: 40.h,
                    width: 100.w,
                    margin: EdgeInsets.symmetric(horizontal: 5.w),
                    decoration: BoxDecoration(
                        color: selectedIndex == index
                            ? primaryColor.withOpacity(0.8)
                            : Colors.grey.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10.sp)),
                    child: Center(
                        child: Text(
                      busTime[index],
                      style: TextStyle(
                          color: selectedIndex == index
                              ? Colors.white
                              : primaryColor,
                          fontWeight: FontWeight.bold),
                    )),
                  ),
                );
              },
              itemCount: busTime.length,
            ),
          ),
          SizedBox(height: 10.h),
          isLoading
              ? SizedBox(height: 580.h, child: buildThreeInOutLoadingWidget())
              : Selector<ProfileProvider, bool>(
                  selector: (context, provider) => provider.refreshAssignBus,
                  builder: (context, provider, child) {
                    return SizedBox(
                      height: 580.h,
                      child: ListView(
                        physics: const BouncingScrollPhysics(),
                        children: [
                          buildContainer(1, route1, context,
                              busTime[selectedIndex], getBusses),
                          buildContainer(2, route2, context,
                              busTime[selectedIndex], getBusses),
                          buildContainer(3, route3, context,
                              busTime[selectedIndex], getBusses),
                          buildContainer(4, route4, context,
                              busTime[selectedIndex], getBusses),
                        ],
                      ),
                    );
                  },
                )
        ],
      ),
    );
  }

  setIndex() {
    switch (DateTime.now().hour) {
      case 11:
        {
          selectedIndex = 0;
        }
        break;

      case 12:
        {
          selectedIndex = 1;
        }
        break;
      case 13:
        {
          selectedIndex = 2;
        }
        break;
      case 14:
        {
          selectedIndex = 3;
        }
        break;

      case 15:
        {
          selectedIndex = 4;
        }
        break;
      default:
        {
          selectedIndex = 0;
        }
        break;
    }
  }
}
