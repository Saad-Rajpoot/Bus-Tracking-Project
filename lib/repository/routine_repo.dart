import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_storage/firebase_storage.dart' as storage;
import '../client/routine_client.dart';
import '../models/routine_model.dart';
import '../view/public_widgets/error_dialoge.dart';

class RoutineRepo {
  static final RoutineRepo _instance = RoutineRepo();
  RoutineClient? _routineClient;

  RoutineClient getRoutineClient() {
    _routineClient ??= RoutineClient();
    return _routineClient!;
  }

  void initializeClient() {
    _routineClient = RoutineClient();
  }

  static RoutineRepo get instance => _instance;

  Future<bool> createRoutine(String type, String routineUrl) async {
    int retry = 0;
    RoutineModel routineModel =
        RoutineModel(type: type, routineUrl: routineUrl);

    bool response = false;

    while (retry++ < 2) {
      try {
        response = await RoutineRepo.instance
            .getRoutineClient()
            .createRoutine(routineModel);

        return response;
      } catch (err) {
        throw Exception("Something went wrong");
      }
    }
    return response;
  }

  Future<RoutineModel> getRoutine(String type) async {
    try {
      RoutineModel response =
          await RoutineRepo.instance.getRoutineClient().getRoutine(type);

      return response;
    } catch (err) {
      print("------------------------------- err");
      return RoutineModel(routineUrl: "", sId: "", type: "");
    }
  }

  Future<String> uploadPDF(File file, String text) async {
    try {
      final ref =
          storage.FirebaseStorage.instance.ref().child("PDF").child(text);

      final result = await ref.putFile(file);
      final url = await result.ref.getDownloadURL();

      return url;
    } catch (e) {
      return "error";
    }
  }
}
