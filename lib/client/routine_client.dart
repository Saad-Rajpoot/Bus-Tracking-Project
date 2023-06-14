import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:lu_bird/models/routine_model.dart';

import '../constants/api_endpoints.dart';

class RoutineClient {
  RoutineClient();

  Future<bool> createRoutine(RoutineModel routineModel) async {
    var url = Uri.parse(Api_Endpoints.ROUTINE);
    try {
      var response = await http.post(
        url,
        body: routineModel.toJson(),
      );

      if (response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (err) {
      throw Exception(err);
    }
  }

  Future<RoutineModel> getRoutine(String type) async {
    var url = Uri.parse("${Api_Endpoints.ROUTINE}?type=$type");
    try {

      var response = await http.get(url);

      List<dynamic> routine = jsonDecode(response.body);


      if (response.statusCode == 200) {
        print("------------------------------- res");
        print(response.body);
        print(routine);
        if (routine.isEmpty) {
          print("------------------------------- empty");
          throw Exception("No data found");
        }
        print("------------------------------- 2222222222222222222222 ");
        print(routine[0]);
        return RoutineModel.fromJson(routine[0]);
      } else {
        print("------------------------------- else ");
        throw Exception("Fail To load");
      }
    } catch (err) {
      print("------------------------------- catch ");
      throw Exception(err);
    }
  }
}
