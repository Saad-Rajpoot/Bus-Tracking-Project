import 'package:flutter/cupertino.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lu_bird/custom_nev.dart';
import 'package:lu_bird/providers/profile_provider.dart';
import 'package:lu_bird/view/auth/landing_page.dart';
import 'package:lu_bird/view/auth/verification.dart';
import 'package:lu_bird/view/home/home.dart';
import 'package:lu_bird/view/public_widgets/custom_loading.dart';
import 'package:provider/provider.dart';

class Initial extends StatefulWidget {
  const Initial({Key? key}) : super(key: key);

  @override
  State<Initial> createState() => _InitialState();
}

class _InitialState extends State<Initial> {
  late Future<FirebaseApp> _initialization;

  @override
  void initState() {
    super.initState();
    _initializeFirebase();
  }

  Future<void> _initializeFirebase() async {
    try {
      _initialization = Firebase.initializeApp(
          name: "Bus Tracking Project",
          options: FirebaseOptions(
              apiKey: 'AIzaSyC9DgR5g4elQjgH_6jabIWmUCMK8GAsQDc',
              appId: '1:1067691145431:android:50908935e39ebdbbb8d892',
              messagingSenderId: '1067691145431',
              projectId: 'bus-tracking-system-60b77'));
      await _initialization;
    } catch (e) {
      // Handle the error appropriately, such as printing the error message
      print('Firebase initialization error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        } else if (snapshot.hasError) {
          return const Scaffold(body: Center(child: Text("Error")));
        } else {
          return const MiddleOfHomeAndSignIn();
        }
      },
    );
  }
}

class MiddleOfHomeAndSignIn extends StatefulWidget {
  const MiddleOfHomeAndSignIn({Key? key}) : super(key: key);

  @override
  _MiddleOfHomeAndSignInState createState() => _MiddleOfHomeAndSignInState();
}

class _MiddleOfHomeAndSignInState extends State<MiddleOfHomeAndSignIn> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<ProfileProvider>(context, listen: false).getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return buildLoadingWidget();
        }
        if (snapshot.data != null && snapshot.data!.emailVerified) {
          return const CustomNavigation();
        }
        return snapshot.data == null
            ? const LandingPage()
            : const Verification();
      },
    );
  }
}
