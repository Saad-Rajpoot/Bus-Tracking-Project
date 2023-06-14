import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketTester extends StatefulWidget {
  const SocketTester({Key? key}) : super(key: key);

  @override
  State<SocketTester> createState() => _SocketTesterState();
}

class _SocketTesterState extends State<SocketTester> {
  late IO.Socket socket;
  var result = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initSocket();
  }

  Future<void> initSocket() async {
    try {
      socket = IO.io("http://10.0.2.2:8000/", {
        'transports': ['websocket'],
        'autoConnect': true,
      });

      socket.connected;
      socket.on("locationChange", (data) {
        setState(() {
          result = data;
        });
      });
    } catch (err) {
      print(err);
      print("------------------------------------- err");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Center(
        child: result.isEmpty
            ? SizedBox()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(result["id"]),
                  Text(result["latitude"].toString()),
                  Text(result["longitude"].toString()),
                ],
              ),
      ),
    );
  }
}
