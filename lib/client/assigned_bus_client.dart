import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lu_bird/models/assigned_bus_model.dart';
import '../constants/api_endpoints.dart';

class AssignedBusClient {
  AssignedBusClient() {}

  Future<bool> assignBus(AssignedBusModel busModel) async {
    var url = Uri.parse(Api_Endpoints.ASSIGN_BUS);
    try {
      var response = await http.post(
        url,
        body: busModel.toJson(),
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

  Future<List<AssignedBusModel>> getAssignedBusses(String timeSlot) async {
    var url = Uri.parse("${Api_Endpoints.ASSIGN_BUS}?departureTime=$timeSlot");
    try {
      var response = await http.get(url);
      var listOfBus = jsonDecode(response.body) as List;
      if (response.statusCode == 200) {
        return listOfBus
            .map((element) => AssignedBusModel.fromJson(element))
            .toList();
      } else {
        throw Exception("Fail To load");
      }
    } catch (err) {
      throw Exception(err);
    }
  }

  Future<bool> deleteBus(String busNumber) async {
    var url = Uri.parse("${Api_Endpoints.ASSIGN_BUS}?busNumber=$busNumber");
    try {
      var response = await http.delete(url);
      print(response.body);
      if (response.statusCode == 200) {
        return true;
      } else {
        throw false;
      }
    } catch (err) {
      throw Exception(err);
    }
  }
}
