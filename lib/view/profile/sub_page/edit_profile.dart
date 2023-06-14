import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lu_bird/view/public_widgets/app_colors.dart';
import 'package:provider/provider.dart';

import '../../../providers/profile_provider.dart';
import '../../auth/widgets/text_field.dart';
import '../../public_widgets/custom_button.dart';
import '../../public_widgets/custom_loading.dart';
import '../../public_widgets/error_dialoge.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  late TextEditingController changeNameController;
  late TextEditingController changeDepartmentController;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    var pro = Provider.of<ProfileProvider>(context, listen: false);
    changeNameController = TextEditingController(text: pro.profileName);
    changeDepartmentController = TextEditingController(text: pro.department);

    super.initState();
  }

  validate() async {
    if (_formKey.currentState!.validate()) {
      try {
        buildLoadingIndicator(context);
        Provider.of<ProfileProvider>(context, listen: false)
            .updateProfileInfo(
          name: changeNameController.text,
          department: changeDepartmentController.text,
          context: context,
        )
            .then(
          (value) async {
            Navigator.of(context, rootNavigator: true).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  "Profile updated successfully",
                  style: TextStyle(color: Colors.white, ),
                ),

              ),
            );
          },
        );
      } catch (e) {
        return onError(context, "Having problem connecting to the server");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text("Edit Profile", style: TextStyle(color: Colors.black)),
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
          padding: EdgeInsets.only(left: 25.w),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          height: 650.h,
          padding: EdgeInsets.all(32.sp),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 10.h),
              const Spacer(),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    customTextField(changeNameController, "Full name", context,
                        Icons.person_outline_rounded),
                    SizedBox(height: 15.h),
                    customTextField(changeDepartmentController, "Department",
                        context, Icons.laptop),

                    /*if (role == "Student" || role == "Moderator")
                      _buildContainer(
                          "Change Batch", changeBatchController, context),
                    if (role == "Student" || role == "Moderator")
                      _buildContainer(
                          "Change Section", changeSectionController, context),*/
                  ],
                ),
              ),
              const Spacer(),
              InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () {
                  validate();
                },
                child: customButton(
                    text: "Update",
                    width: 400,
                    height: 50,
                    color: Colors.black,
                    fontSize: 16.sp),
              ),
              SizedBox(
                height: 10.h,
              )
            ],
          ),
        ),
      ),
    );
  }
}
