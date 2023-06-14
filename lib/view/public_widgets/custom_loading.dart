import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lu_bird/view/public_widgets/app_colors.dart';

buildLoadingIndicator(BuildContext context) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return  Center(
        child: SpinKitDoubleBounce(
          itemBuilder: (BuildContext context, int index) {
            return DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: index.isEven ? const Color(0xff2C3639) : const Color(0xff2C3639).withOpacity(0.5),
              ),
            );
          },
        ),
      );
    },
  );
}


Center buildLoadingWidget(){
  return Center(
    child: SpinKitDoubleBounce(
      itemBuilder: (BuildContext context, int index) {
        return DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: index.isEven ? primaryColor : primaryColor.withOpacity(0.5),
          ),
        );
      },
    ),
  );
}


Center buildThreeInOutLoadingWidget(){
  return Center(
    child: SpinKitThreeInOut(
      itemBuilder: (BuildContext context, int index) {
        return DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: index.isEven ? primaryColor : primaryColor.withOpacity(0.5),
          ),
        );
      },
    ),
  );
}