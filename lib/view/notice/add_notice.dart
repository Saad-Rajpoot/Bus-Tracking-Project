import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lu_bird/models/notice_model.dart';
import 'package:lu_bird/providers/profile_provider.dart';
import 'package:lu_bird/repository/notice_repo.dart';
import 'package:firebase_storage/firebase_storage.dart' as storage;
import 'package:provider/provider.dart';
import '../auth/widgets/snackBar.dart';
import 'package:http/http.dart' as http;
import '../public_widgets/custom_button.dart';
import '../public_widgets/custom_loading.dart';

class AddNotice extends StatefulWidget {
  AddNotice({Key? key, this.notice, this.reloadPage}) : super(key: key);

  NoticeModel? notice;
  Function? reloadPage;

  @override
  State<AddNotice> createState() => _AddNoticeState();
}

class _AddNoticeState extends State<AddNotice> {
  late TextEditingController descriptionController;

  final picker = ImagePicker();
  late File _imageFile;
  bool isSelected = false;

  @override
  void initState() {
    descriptionController = TextEditingController(
        text: widget.notice != null ? widget.notice!.description : "");

    super.initState();
  }

  Future pickImage(ImageSource imageSource) async {
    try {
      final pickedFile = await picker.pickImage(
        source: imageSource,
        imageQuality: 50,
      );

      if (pickedFile != null) {
        setState(() {
          isSelected = true;
          _imageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      print("Error $e");
    }
  }

  validate() async {
    if (descriptionController.text.isNotEmpty) {
      var pro = Provider.of<ProfileProvider>(context, listen: false);
      buildLoadingIndicator(context);
      try {
        String url = "";

        if (isSelected) {
          final ref = storage.FirebaseStorage.instance
              .ref()
              .child("postImage/${DateTime.now()}");

          final result = await ref.putFile(_imageFile);
          url = await result.ref.getDownloadURL();
        }
        bool response = false;

        if (widget.notice == null) {
          response = await NoticeRepo()
              .createNotice(pro.profileName, descriptionController.text, url);
        } else {
          response = await NoticeRepo().updateNotice(
              pro.profileName,
              descriptionController.text,
              url.isEmpty ? widget.notice!.imageUrl ?? "" : url,
              widget.notice!.sId ?? "");
          if (response) {
            widget.reloadPage!(true);
          }
        }

        Navigator.of(context).pop();
        Navigator.of(context).pop();

        if (!response) {
          snackBar(context,
              "Fail to ${widget.notice == null ? "add" : "update"} notice");
        }
      } catch (e) {
        Navigator.of(context, rootNavigator: true).pop();
        snackBar(context, "Some error occur");
      }
    } else {
      snackBar(context, "Enter description");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 70.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Icon(
                        Icons.close,
                        size: 30.sp,
                      )),
                  InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () {
                      validate();
                    },
                    child: customButton(
                        text: widget.notice == null ? "Post" : "Update",
                        fontSize: 16.sp,
                        width: 100.w,
                        height: 40.h,
                        color: Colors.black),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(32, 30, 32, 0),
              child: TextField(
                maxLines: 10,
                style: const TextStyle(color: Colors.black),
                controller: descriptionController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Type Notice...",
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.h, vertical: 10.h),
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      pickImage(ImageSource.camera);
                    },
                    child: Container(
                      height: 60.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey.withOpacity(0.4)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            FontAwesomeIcons.cameraRetro,
                          ),
                          SizedBox(width: 10),
                          Text("Take a picture")
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 15.w),
                  InkWell(
                    onTap: () {
                      pickImage(ImageSource.gallery);
                    },
                    child: Container(
                      height: 60.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey.withOpacity(0.4)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            FontAwesomeIcons.image,
                          ),
                          SizedBox(width: 10),
                          Text("Select From Gallery")
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 15.w),
                ],
              ),
            ),
            Container(
                height: 250.h,
                width: double.infinity,
                margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 30.w),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.2),
                  border: Border.all(color: Colors.grey.withOpacity(0.4)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: isSelected
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(
                          _imageFile,
                          fit: BoxFit.cover,
                        ))
                    : widget.notice != null && widget.notice!.imageUrl != ""
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              widget.notice!.imageUrl!,
                              fit: BoxFit.cover,
                            ))
                        : const Center(child: Text("No Image Selected")))
          ],
        ),
      ),
    );
  }
}
