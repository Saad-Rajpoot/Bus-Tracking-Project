import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lu_bird/models/notice_model.dart';
import 'package:lu_bird/providers/profile_provider.dart';
import 'package:lu_bird/repository/notice_repo.dart';
import 'package:lu_bird/view/notice/widgets/single_notice.dart';
import 'package:provider/provider.dart';

import '../public_widgets/custom_loading.dart';

class Notice extends StatefulWidget {
  const Notice({Key? key}) : super(key: key);

  @override
  State<Notice> createState() => _NoticeState();
}

class _NoticeState extends State<Notice> {
  late ScrollController scrollController;
  bool isLoading = false;
  bool hasMore = true;
  List<NoticeModel> listOfNotice = [];

  @override
  void initState() {
    super.initState();
    getData(false);

    scrollController = ScrollController();

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent * 0.95 &&
          !isLoading) {
        if (hasMore) {
          getData(false);
        }
      }
    });
  }

  getData(bool refresh) async {
    if (refresh) {
      hasMore = true;
      listOfNotice.clear();
    }
    setState(() {
      isLoading = true;
    });
    var response = await NoticeRepo().getNotices(listOfNotice.length);
    listOfNotice.addAll(response);
    setState(() {
      isLoading = false;
      hasMore = response.isNotEmpty;
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var pro = Provider.of<ProfileProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(

        title: const Text("Notices", style: TextStyle(color: Colors.black)),

        centerTitle: true,
        leading: Padding(
          padding: EdgeInsets.only(left: 20.w),
          child: InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: const Icon(Icons.arrow_back),
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (pro.role == "admin")
            IconButton(
              padding: EdgeInsets.only(right: 20.w),
              onPressed: () {
                Navigator.of(context).pushNamed("AddNotice");
              },
              icon: const Icon(
                Icons.add,
                color: Colors.black,
              ),
            ),
        ],
      ),
      body: ListView.builder(
        physics: const BouncingScrollPhysics(),
        controller: scrollController,
        itemBuilder: (context, index) {
          if (index == listOfNotice.length) {
            return buildThreeInOutLoadingWidget();
          }

          return SingleNotice(
            notice: listOfNotice[index],
            role: pro.role,
            reloadPage: getData,
          );
        },
        itemCount: listOfNotice.length + (hasMore ? 1 : 0),
      ),
    );
  }
}
