import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lu_bird/repository/routine_repo.dart';
import 'package:lu_bird/view/public_widgets/app_colors.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import '../../../providers/profile_provider.dart';
import '../../auth/widgets/snackBar.dart';
import '../../public_widgets/custom_loading.dart';
import '../../public_widgets/error_dialoge.dart';

class BusSchedule extends StatefulWidget {
  BusSchedule({Key? key, required this.name}) : super(key: key);
  String name;

  @override
  _BusScheduleState createState() => _BusScheduleState();
}

class _BusScheduleState extends State<BusSchedule> {
  pickFile() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: false);
    if (result != null && result.files.single.path != null) {
      File file = File(result.files.single.path!);
      String url = await RoutineRepo().uploadPDF(file, widget.name);
      if (url != "error") {
        bool result = await RoutineRepo().createRoutine(widget.name, url);
        if (result) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                "PDF updated successfully",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          );
        }
      } else {
        return onError(context, "Having problem connecting to the server");
      }
    } else {
      return onError(context, "Having problem connecting to the server");
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  bool isLoading = false;
  String? url;

  getData() async {
    setState(() {
      isLoading = true;
    });

    try {
      var response = await RoutineRepo().getRoutine(widget.name);

      if (response.routineUrl!.isNotEmpty) {
        url = response.routineUrl;
      }
    } catch (err) {
      setState(() {
        isLoading = false;
      });
      return snackBar(context, "Something went wrong");
    }

    setState(() {
      isLoading = false;
    });
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
          widget.name,
          style: TextStyle(
            fontSize: 19.sp,
            fontWeight: FontWeight.w500,
            color: primaryColor,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: 20.sp,
          ),
        ),
        actions: [
          if (pro.role == "admin")
            IconButton(
              onPressed: () {
                pickFile();
              },
              icon: Icon(
                Icons.add,
                color: Colors.black,
                size: 24.sp,
              ),
            )
        ],
      ),
      body: isLoading
          ? buildLoadingWidget()
          : url == null
              ? pdfUnavailable()
              : const PDF(
                  swipeHorizontal: false,
                ).fromUrl(
                  url!,
                ),
    );
  }

  Center pdfUnavailable() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            widget.name == "Bus Schedule"
                ? "No bus schedule added yet!"
                : "No routine added yet!",
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          /*InkWell(
            onTap: () {
              pickFile();
            },
            child: const Padding(
              padding: EdgeInsets.all(20),
              child: Icon(Icons.add),
            ),
          ),*/
        ],
      ),
    );
  }
}
