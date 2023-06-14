import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lu_bird/custom_nev.dart';
import 'package:provider/provider.dart';
import '../../providers/authentication.dart';
import '../home/home.dart';
import '../public_widgets/app_colors.dart';
import 'package:lu_bird/view/auth/widgets/flat_button.dart';

class Verification extends StatefulWidget {
  const Verification({
    Key? key,
  }) : super(key: key);

  @override
  _VerificationState createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {
  bool isVerified = false;
  bool isLoading = false;

  Future checkVerification() async {
    setState(() {
      isLoading = true;
    });

    User? user = FirebaseAuth.instance.currentUser;
    await user!.reload();
    user = FirebaseAuth.instance.currentUser;
    isVerified = user!.emailVerified;

    if (!isVerified) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Not verified yet',
            style: TextStyle(color: Colors.black),
            textAlign: TextAlign.center,
          ),
          duration: Duration(seconds: 4),
          backgroundColor: Color(0xffEF4F4F),
        ),
      );
    }

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  sendVerificationLink() async {
    final User? user = FirebaseAuth.instance.currentUser;

    try {
      if (user != null) {
        user.sendEmailVerification();
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Verification mail sent',
            style: TextStyle(color: Colors.black),
            textAlign: TextAlign.center,
          ),
          duration: Duration(seconds: 1),
          backgroundColor: Color(0xff50CB93),
        ),
      );
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    final User? user = FirebaseAuth.instance.currentUser;
    user!.sendEmailVerification();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: primaryColor),
            ),
          )
        : isVerified
            ? const CustomNavigation()
            : _buildScaffold();
  }

  Scaffold _buildScaffold() {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(30.sp),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              SizedBox(
                height: 50.h,
              ),
              SizedBox(
                height: 100.h,
                width: 100.h,
                child: Image.asset("assets/email.png"),
              ),
              SizedBox(height: 22.h),
              Text(
                "Check your email",
                style: GoogleFonts.inter(
                  fontSize: 25.sp,
                  color: primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 13.h),
              SizedBox(
                width: 300.w,
                child: Text(
                  "We have sent a verification link to your email to your email",
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    color: Colors.black54,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 25.h),
              InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () {
                  checkVerification();
                },
                child: flatButton(
                    name: 'Check Verification', height: 50, width: 200),
              ),
              SizedBox(height: 15.h),
              InkWell(
                onTap: () {
                  sendVerificationLink();
                },
                child: Text(
                  "Resend code",
                  style: GoogleFonts.inter(
                    fontSize: 15.sp,
                    color: primaryColor,
                    fontWeight: FontWeight.w400,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              const Spacer(),
              SizedBox(
                width: 414.w,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Did not receive the email? Check your spam filter, or",
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        color: Colors.black54,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            Provider.of<Authentication>(context, listen: false)
                                .deleteUser();
                            Navigator.of(context)
                                .pushReplacementNamed("Registration");
                          },
                          child: Text(
                            "Try another email address",
                            style: GoogleFonts.inter(
                              fontSize: 14.sp,
                              color: primaryColor,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(height: 50.h),
            ],
          ),
        ),
      ),
    );
  }
}
