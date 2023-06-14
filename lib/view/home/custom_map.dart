import 'dart:async';
import 'dart:typed_data';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:location/location.dart' as loc;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lu_bird/constants/api_endpoints.dart';
import 'package:lu_bird/constants/route_coordinate.dart';
import 'package:lu_bird/providers/map_provider.dart';
import 'package:provider/provider.dart';
import '../auth/widgets/snackBar.dart';
import '../public_widgets/custom_loading.dart';
import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:firebase_database/firebase_database.dart';

class CustomMap extends StatefulWidget {
  const CustomMap({Key? key}) : super(key: key);

  @override
  State<CustomMap> createState() => _CustomMapState();
}

class _CustomMapState extends State<CustomMap> {
  final loc.Location location = loc.Location();
  bool isIconSelected = false;
  bool _added = false;
  StreamSubscription<loc.LocationData>? _locationSub;
  late GoogleMapController _controller;
  bool firstTime = false;

  Uint8List? userLocationIcon;
  Uint8List? busLocationIcon;
  CameraPosition? userCameraPosition;

  List<Map> locationList = [];
  final Set<Polyline> _polyline = {};

  List<LatLng> latLen = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getMarkers();
    initSocket();

    FirebaseDatabase.instance.ref().child('GPS').onValue.listen((event) {
      final data = event.snapshot.value;

      if (data != null) {
        var map = Map<String, dynamic>.from(data as Map<dynamic, dynamic>);
        int index =
            locationList.indexWhere((element) => element['id'] == map['id']);
        if (index >= 0) {
          locationList[index]["latitude"] = map["f_latitude"];
          locationList[index]["longitude"] = map["f_longitude"];
        } else {
          if (firstTime) {
            locationList.add({
              "id": map["id"],
              "longitude": map["f_longitude"],
              "latitude": map["f_latitude"],
              "route": map["route"],
              "availableSeat": map["availableSeat"],
              "serial": 34
            });
          } else {
            firstTime = true;
          }
        }

        if (mounted) {
          Provider.of<MapProvider>(context, listen: false).onLocationChange();
        }
      } else {
        print("no data");
      }
    });

    _polyline.addAll([
      Polyline(
        polylineId: const PolylineId('1'),
        points: RoutesCoordinate().route1,
        color: const Color(0xff625757),
      ),
      Polyline(
        polylineId: const PolylineId('2'),
        points: RoutesCoordinate().route2,
        color: const Color(0xff30475E),
      ),
      Polyline(
        polylineId: const PolylineId('3'),
        points: RoutesCoordinate().route3,
        color: const Color(0xffF96666),
      ),
      Polyline(
        polylineId: const PolylineId('4'),
        points: RoutesCoordinate().route4,
        color: const Color(0xff999B84),
      ),
      Polyline(
        polylineId: const PolylineId('5'),
        points: RoutesCoordinate().commonLetLng,
        color: const Color(0xff6D9886),
      )
    ]);
  }

  @override
  void dispose() {
    super.dispose();

    _controller.dispose();
    _locationSub!.cancel();
  }

  late IO.Socket socket;
  var result = {};

  Future<void> initSocket() async {
    try {
      socket = IO.io(Api_Endpoints.baseUrl, {
        'transports': ['websocket'],
        'autoConnect': true,
      });

      socket.connected;
      socket.on("locationChange", (data) {
        int index =
            locationList.indexWhere((element) => element['id'] == data['id']);
        if (index >= 0) {
          locationList[index]["latitude"] = data["latitude"];
          locationList[index]["longitude"] = data["longitude"];
        } else {
          locationList.add(data);
        }

        if (mounted) {
          Provider.of<MapProvider>(context, listen: false).onLocationChange();
        }
      });
    } catch (err) {
      print(err);
      print("------------------------------------- err");
    }
  }

  @override
  Widget build(BuildContext context) {
    var pro = Provider.of<MapProvider>(context, listen: false);
    return Scaffold(
      body: isIconSelected
          ? Consumer<MapProvider>(
              builder: (BuildContext context, value, Widget? child) {
                return buildGoogleMap(pro);
              },
            )
          : buildLoadingWidget(),
    );
  }

  GoogleMap buildGoogleMap(MapProvider pro) {
    print("----------------------------------");
    return GoogleMap(
      zoomGesturesEnabled: true,
      zoomControlsEnabled: true,
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      padding: EdgeInsets.only(top: 35.h),
      onCameraMove: (CameraPosition cameraPosition) {
        userCameraPosition = cameraPosition;
      },
      polylines: _polyline,
      initialCameraPosition: CameraPosition(
        target: pro.userLocation == null
            ? const LatLng(34.1961732167, 73.2361753966)
            : LatLng(pro.userLocation!.latitude!, pro.userLocation!.longitude!),
        zoom: 15,
      ),
      mapType: MapType.normal,
      markers: Set<Marker>.of(
        locationList.map(
          (element) {
            print("-----------------------------------");
            return Marker(
              position: LatLng(element['latitude'], element['longitude']),
              markerId: MarkerId(element["id"]),
              infoWindow: InfoWindow(
                title: "Route ${element['route']}",
                snippet: "${element['availableSeat']} seat available",
              ),
              icon: BitmapDescriptor.fromBytes(busLocationIcon!),
            );
          },
        ),
      ),
      onMapCreated: (GoogleMapController controller) async {
        if (!_added) {
          _controller = controller;
          _added = true;
          _onUserLocationChange(pro);
        }
      },
    );
  }

  Future<void> changeMyMap(MapProvider pro) async {
    await _controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: userCameraPosition == null
              ? pro.userLocation == null
                  ? const LatLng(34.1961732167, 73.2361753966)
                  : LatLng(
                      pro.userLocation!.latitude!, pro.userLocation!.longitude!)
              : userCameraPosition!.target,
          zoom: userCameraPosition == null ? 15 : userCameraPosition!.zoom,
          tilt: userCameraPosition == null ? 0 : userCameraPosition!.tilt,
          bearing: userCameraPosition == null ? 0 : userCameraPosition!.bearing,
        ),
      ),
    );
  }

  getMarkers() async {
    userLocationIcon = await getBytesFromAssets("assets/user.png", 100);
    busLocationIcon = await getBytesFromAssets("assets/bus.png", 80);

    if (userLocationIcon != null && busLocationIcon != null) {
      setState(() {
        isIconSelected = true;
      });
    } else {
      return snackBar(context, "Something Went Wrong");
    }
  }

  Future<void> _onUserLocationChange(MapProvider pro) async {
    _locationSub = location.onLocationChanged.handleError((onError) {
      _locationSub!.cancel();
      setState(() {
        _locationSub = null;
      });
    }).listen((loc.LocationData currentLocation) async {
      pro.userLocation = currentLocation;
      print("---------------------------------- user location change");

      if (mounted) {
        Provider.of<MapProvider>(context, listen: false).onLocationChange();
      }

      changeMyMap(pro);
    });
  }

  Future<Uint8List> getBytesFromAssets(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }
}
