import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lu_bird/view/auth/widgets/snackBar.dart';
import 'package:lu_bird/view/auth/widgets/switch_page.dart';
import 'package:lu_bird/view/auth/widgets/text_field.dart';
import 'package:lu_bird/view/auth/widgets/page_indicator.dart';
import 'package:lu_bird/view/auth/widgets/round_button.dart';
import 'package:provider/provider.dart';
import '../../providers/authentication.dart';
import '../public_widgets/custom_loading.dart';
import 'forgot_password.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Registration extends StatefulWidget {
  const Registration({Key? key}) : super(key: key);

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController departmentController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    nameController.clear();
    emailController.clear();
    passwordController.clear();
    departmentController.clear();
    super.dispose();
  }

  validate() async {
    if (_formKey.currentState!.validate()) {
      try {
        buildLoadingIndicator(context);
        Provider.of<Authentication>(context, listen: false)
            .signUp(
          name: nameController.text,
          email: emailController.text,
          password: passwordController.text,
          department: departmentController.text,
          context: context,
        )
            .then((value) async {
          if (value != "Success") {
            snackBar(context, value);
          } else {
            final User? user = FirebaseAuth.instance.currentUser;
            if (user != null) {
              user.sendEmailVerification();
            }
          }
        });
      } catch (e) {
        Navigator.of(context, rootNavigator: true).pop();
        snackBar(context, "Some error occur");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.all(30.sp),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 45.h),
              Image.asset("assets/registration.png"),
              SizedBox(height: 40.h),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    customTextField(nameController, "Full name", context,
                        Icons.person_outline_rounded),
                    SizedBox(height: 20.h),
                    customTextField(emailController, "Valid email", context,
                        Icons.email_outlined),
                    SizedBox(height: 20.h),
                    customTextField(passwordController, "Password", context,
                        Icons.lock_outline_rounded),
                    SizedBox(height: 20.h),
                    customTextField(departmentController, "Department", context,
                        Icons.laptop),
                  ],
                ),
              ),
              SizedBox(height: 17.h),
              switchPageButton("Already Have An Account? ", "Log In", context),
              SizedBox(height: 55.h),
              Row(
                children: [
                  pageIndicator(3, context),
                  const Spacer(),
                  InkWell(
                    splashColor: Colors.transparent,
                    onTap: () {
                      validate();
                    },
                    child: roundButton(),
                  ),
                ],
              ),
              SizedBox(height: 30.h),

            ],
          ),
        ),
      ),
    );
  }
}
