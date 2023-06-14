import 'package:lu_bird/providers/map_provider.dart';
import 'package:lu_bird/providers/profile_provider.dart';
import 'package:lu_bird/view/home/socketTester.dart';
import 'package:lu_bird/view/home/widgets/home_explore.dart';
import 'package:lu_bird/view/home/widgets/home_profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../auth/widgets/snackBar.dart';
import 'custom_map.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<bool> requestLocationPermission() async {
    /// status can either be: granted, denied, restricted or permanentlyDenied
    var status = await Permission.location.status;
    if (status.isGranted) {
      return true;
    } else if (status.isDenied) {
      // We didn't ask for permission yet or the permission has been denied before but not permanently.
      if (await Permission.location.request().isGranted) {
        // Either the permission was already granted before or the user just granted it.
        return true;
      }
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  getLocation() async {
    bool result = await requestLocationPermission();
    if (result) {
      if (mounted) {
        Provider.of<MapProvider>(context, listen: false)
            .getUserCurrentLocation();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            bottom: 0,
            child: GestureDetector(
              onTap: () async {
                bool result = await requestLocationPermission();
                if (result) {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const CustomMap()));
                } else {
                  snackBar(context, "Location is not granted");
                }

               /* Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => SocketTester()));*/
              },
              child: ShaderMask(
                shaderCallback: (rect) {
                  return LinearGradient(
                    begin: Alignment.center,
                    end: Alignment.topCenter,
                    colors: [Colors.white, Colors.white.withOpacity(0.4)],
                  ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
                },
                blendMode: BlendMode.dstIn,
                child: SizedBox(
                  height: 450.h,
                  width: 360.w,
                  child: Image.asset(
                    "assets/map.png",
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 90.h,
            child: buildExplore(),
          ),
          buildHomeProfile(context),
        ],
      ),
    );
  }
}
