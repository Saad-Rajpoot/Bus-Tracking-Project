import 'dart:async';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart' as loc;
import 'package:lu_bird/view/public_widgets/app_colors.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:simple_ripple_animation/simple_ripple_animation.dart';
import '../../constants/api_endpoints.dart';

class GPSSetting extends StatefulWidget {
  const GPSSetting({Key? key}) : super(key: key);

  @override
  State<GPSSetting> createState() => _GPSSettingState();
}

class _GPSSettingState extends State<GPSSetting> {
  final loc.Location location = loc.Location();
  StreamSubscription<loc.LocationData>? _locationSub;
  bool isSendingData = false;

  var url = Uri.parse(Api_Endpoints.CHANGE_LOCATION);

  @override
  void dispose() {
    super.dispose();
    _locationSub!.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Send Location",
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black87),
        ),
        body: RippleAnimation(
          color: isSendingData ? Color(0xffA0E4CB) : Colors.white,
          delay: const Duration(milliseconds: 10),
          repeat: true,
          minRadius: 90,
          ripplesCount: 7,
          duration: const Duration(milliseconds: 6 * 600),
          child: InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () {
              setState(() {
                isSendingData = !isSendingData;
                if (isSendingData) {
                  _onLocationChange();
                } else {
                  _stopListening();
                }
              });
            },
            child: Center(
              child: Container(
                width: 200.w,
                height: 200.w,
                decoration: const BoxDecoration(
                    color: primaryColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 10,
                          spreadRadius: 1,
                          offset: Offset(0, 0),
                          color: Colors.black45)
                    ]),
                child: Center(
                  child: Text(
                    isSendingData ? "Stop" : "Start",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 32.sp,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
        ));
  }

  Future<void> _onLocationChange() async {
    location.changeSettings(
        accuracy: LocationAccuracy.high, interval: 5000, distanceFilter: 1);
    _locationSub = location.onLocationChanged.handleError((onError) {
      _locationSub!.cancel();
      setState(() {
        _locationSub = null;
      });
    }).listen((loc.LocationData currentLocation) async {
      try {
        await http.post(
          url,
          body: {
            "id": "121",
            "longitude": currentLocation.longitude.toString(),
            "latitude": currentLocation.latitude.toString(),
            "route": "2",
            "availableSeat": "Unknown",
            "serial": "34"
          },
        );
      } catch (err) {
        print("-----============================= eeeeeeee");
      }
    });
  }

  _stopListening() {
    _locationSub?.cancel();
    setState(() {
      _locationSub = null;
    });
  }

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
}
