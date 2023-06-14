import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lu_bird/view/public_widgets/app_colors.dart';
import 'dart:io';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lu_bird/providers/profile_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import '../../auth/widgets/snackBar.dart';

class ProfileImage extends StatelessWidget {
  const ProfileImage({Key? key}) : super(key: key);

  Future pickImage(BuildContext context) async {
    try {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 20,
      );
      if (pickedFile != null) {
        CroppedFile? croppedFile = await ImageCropper().cropImage(
          sourcePath: pickedFile.path,
          aspectRatioPresets: [CropAspectRatioPreset.square],
          uiSettings: [
            AndroidUiSettings(
                toolbarTitle: 'Cropper',
                toolbarColor: const Color(0xff2C3333),
                toolbarWidgetColor: Colors.white,

                initAspectRatio: CropAspectRatioPreset.original,
                lockAspectRatio: false),
          ],
        );

        if (croppedFile != null) {
          final File imageFile = File(croppedFile.path);
          Provider.of<ProfileProvider>(context, listen: false)
              .updateProfileUrl(imageFile, context);
        }
      }
    } catch (e) {
      snackBar(context, "Some error occur");
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var pro = Provider.of<ProfileProvider>(context, listen: false);
    return SizedBox(
      height: size.height * 0.18,
      width: size.height * 0.155,
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: 4.0,
              ),
            ),
            height: size.height * 0.155,
            width: size.height * 0.155,
            child: buildClipRRect(pro, context),
          ),
          Positioned(
            right: 5.sp,
            bottom: 22.sp,
            child: InkWell(
              onTap: () {},
              child: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: primaryColor,
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withOpacity(0.4),
                        blurRadius: 3,
                        offset: const Offset(3, 3), // Shadow position
                      ),
                    ]),
                child: InkWell(
                  onTap: () {
                    pickImage(context);
                  },
                  child: const Icon(
                    Icons.camera_alt_outlined,
                    size: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  ClipRRect buildClipRRect(ProfileProvider pro, BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(100),
      child: pro.profileUrl != ""
          ? GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return PhotoView(
                      imageProvider: NetworkImage(pro.profileUrl),
                    );
                  }),
                );
              },
              child: CircleAvatar(
                backgroundColor: Colors.grey,
                radius: 21,
                backgroundImage: NetworkImage(
                  pro.profileUrl,
                ),
              ),
            )
          : const CircleAvatar(
              backgroundColor: Colors.grey,
              radius: 21,
              backgroundImage: AssetImage("assets/profile.jpg"),
            ),
    );
  }
}
