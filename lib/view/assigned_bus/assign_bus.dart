import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../repository/assigned_bus_repo.dart';
import '../auth/widgets/flat_button.dart';
import '../auth/widgets/snackBar.dart';
import '../auth/widgets/text_field.dart';
import '../public_widgets/custom_loading.dart';

class AssignBus extends StatelessWidget {
  AssignBus({Key? key, required this.route, required this.departureTime})
      : super(key: key);
  String route;
  String departureTime;

  final TextEditingController busNumberController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void dispose() {
    busNumberController.clear();
  }

  validate(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      try {
        buildLoadingIndicator(context);

        await AssignedBusRepo()
            .assignBus(route, busNumberController.text, departureTime);

        Navigator.of(context, rootNavigator: true).pop();
      } catch (e) {
        Navigator.of(context, rootNavigator: true).pop();
        snackBar(context, "An error accor");
      }
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    return Container(
      padding: EdgeInsets.all(10.sp),
      margin: EdgeInsets.only(top: 10.sp),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: const [
          BoxShadow(
              color: Colors.black12, offset: Offset(0, 10), blurRadius: 10),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(height: 10.h),
          IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(FontAwesomeIcons.circleXmark)),
          SizedBox(height: 30.h),
          Text(
            "Enter bus number",
            style: TextStyle(
                fontSize: 14.sp,
                color: Colors.black,
                fontWeight: FontWeight.bold),
          ),
          Text(
            "to assign a bus",
            style: TextStyle(
                fontSize: 10.sp, color: Colors.black.withOpacity(0.5)),
          ),
          SizedBox(height: 30.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Form(
              key: _formKey,
              child: customTextField(busNumberController, "Bus Number", context,
                  Icons.directions_bus),
            ),
          ),
          SizedBox(height: 30.h),
          InkWell(
            onTap: () {
              validate(context);
            },
            child: flatButton(name: 'Assign'),
          ),
          SizedBox(height: 50.h),
        ],
      ),
    );
  }
}
