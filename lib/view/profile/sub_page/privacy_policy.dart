import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:photo_view/photo_view.dart';

import '../../public_widgets/custom_loading.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text("Privacy Policy", style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        leading: IconButton(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onPressed: () {
            Navigator.of(context).pop();
          },
          padding: EdgeInsets.only(left: 10.w),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          buildContainer(
              "https://firebasestorage.googleapis.com/v0/b/lu-bird-15429.appspot.com/o/privacy_policy%2FLU%20Bus%20trracker%20Privacy%20Policy-1.jpg?alt=media&token=f7ef5110-fa68-4b8e-b319-572fbd7a43d9",
              context),
          buildContainer(
              "https://firebasestorage.googleapis.com/v0/b/lu-bird-15429.appspot.com/o/privacy_policy%2FLU%20Bus%20trracker%20Privacy%20Policy-2.jpg?alt=media&token=66b56fd9-0a16-46e0-bc5a-08dd46b1afc6",
              context)
        ],
      ),
    );
  }

  GestureDetector buildContainer(String url, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) {
            return PhotoView(
              imageProvider: NetworkImage(url),
            );
          }),
        );
      },
      child: Container(
        height: 550.h,
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(border: Border.all(width: 1)),
        child: Image.network(
          url,
          loadingBuilder: (BuildContext context, Widget child,
              ImageChunkEvent? loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: buildLoadingWidget(),
            );
          },
        ),
      ),
    );
  }
}
