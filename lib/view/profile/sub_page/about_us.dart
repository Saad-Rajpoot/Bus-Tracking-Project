import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About Us", style: TextStyle(color: Colors.black)),
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
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.w),
            child: Text(
              "This project is a collaboration between the CSE and EEE departments. Individuals who are involved in this project are :",
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          buildPadding("From Department of CSE"),
          buildStudent(
              "Prithwiraj Bhattacharjee",
              "prithwiraj_cse@lus.ac.bd",
              "Lecturer",
              "https://firebasestorage.googleapis.com/v0/b/lu-bird-15429.appspot.com/o/profileImage%2FPrithwiraj-Bhattacharjee-2%20(1).jpg?alt=media&token=836bc59a-968d-44df-9cf6-7da3b25a5750",
              "Project Supervisor"),
          buildStudent(
              "Sajid Mohammad Ikram",
              "cse_1912020102@lus.ac.bd",
              "1912020102",
              "https://firebasestorage.googleapis.com/v0/b/lu-bird-15429.appspot.com/o/profileImage%2FK0KyPCMT2MMia7uvuXLHJDtRDnU2?alt=media&token=265e63bb-f9f6-4f90-88a1-57493c7ec92b",
              "Developed Software"),
          buildPadding("From Department of EEE"),
          buildStudent(
              "Ishmam Ahmed Chowdhury",
              "ishmamahmed_eee@lus.ac.bd",
              "Lecturer",
              "https://firebasestorage.googleapis.com/v0/b/lu-bird-15429.appspot.com/o/profileImage%2F1611067799995.jfif?alt=media&token=68ed75a8-6f68-496c-a8c4-924ea5bc53dc",
              "Project Supervisor"),
          buildStudent("Abdus Salam", "eee_1912070001@lus.ac.bd", "1912070001",
              "https://firebasestorage.googleapis.com/v0/b/lu-bird-15429.appspot.com/o/profileImage%2FAbdus%20Salam%20.jpeg?alt=media&token=f4db754b-0e32-465b-b422-c68c9119cc69", "Developed Hardware"),
          buildStudent("Mynul Islam Chowdhury", "eee_1912070005@lus.ac.bd",
              "1912070005", "https://firebasestorage.googleapis.com/v0/b/lu-bird-15429.appspot.com/o/profileImage%2FMynul%20Islam%20Mahin.jpeg?alt=media&token=97364035-8959-4a54-a48f-4d12b19ed1cc", "Developed Hardware"),
          buildStudent("Khondoker Fahmiduzzaman", "eee_1912070018@lus.ac.bd",
              "1912070018", "https://firebasestorage.googleapis.com/v0/b/lu-bird-15429.appspot.com/o/profileImage%2FKhondokar%20Fahmiduzzaman%20.jpg?alt=media&token=cb9bb19e-f603-401a-b671-f133eea5bf12", "Developed Hardware"),
          buildStudent("Ashraful Islam", "eee_1912070022@lus.ac.bd",
              "1912070022", "https://firebasestorage.googleapis.com/v0/b/lu-bird-15429.appspot.com/o/profileImage%2FAshraful%20Islam.jpg?alt=media&token=0e41b8f3-675d-4411-947b-0325634a7f54", "Developed Hardware"),
          buildStudent("Abdul Majid Nihad", "eee_1912070042@lus.ac.bd",
              "1912070042", "https://firebasestorage.googleapis.com/v0/b/lu-bird-15429.appspot.com/o/profileImage%2FAbdul%20Majid%20Nihad%20.jpg?alt=media&token=88e5bcce-aaec-4ecf-90c7-4da5bf8f53f5", "Developed Hardware"),
          buildStudent("Syed Owalidur Rahman", "eee_1912070051@lus.ac.bd",
              "1912070051", "https://firebasestorage.googleapis.com/v0/b/lu-bird-15429.appspot.com/o/profileImage%2FSyed%20Owalidur%20Rahman.png?alt=media&token=67ad89d0-c591-4207-8b3b-79cbfb14b016", "Developed Hardware")
        ],
      ),
    );
  }

  Padding buildPadding(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.w),
      child: Text(
        title,
        style: TextStyle(
          overflow: TextOverflow.ellipsis,
          fontSize: 14.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Container buildStudent(
      String name, String email, String id, String url, String role) {
    return Container(
        height: 110.h,
        margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.w),
        decoration: BoxDecoration(
          color: id == "Lecturer"
              ? Colors.green.withOpacity(0.2)
              : Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15.sp),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 100.w,
              child: url.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(15.sp),
                      child: Image.network(url, fit: BoxFit.cover,),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(15.sp),
                      child: Image.asset("assets/profile.jpg"),
                    ),
            ),
            SizedBox(width: 15.w),
            SizedBox(
              width: 190.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    name,
                    softWrap: true,
                    style: TextStyle(
                      overflow: TextOverflow.ellipsis,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5.w),
                  Text(
                    role,
                    style: TextStyle(
                      overflow: TextOverflow.ellipsis,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 5.w),
                  Text(
                    id,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 5.w),
                  Text(
                    email,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            )
          ],
        ));
  }
}
