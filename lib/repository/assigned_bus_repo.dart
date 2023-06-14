import 'package:lu_bird/models/assigned_bus_model.dart';

import '../client/assigned_bus_client.dart';

class AssignedBusRepo {
  static final AssignedBusRepo _instance = AssignedBusRepo();
  AssignedBusClient? _assignedBusClient;

  AssignedBusClient getAssignedBusClient() {
    _assignedBusClient ??= AssignedBusClient();
    return _assignedBusClient!;
  }

  void initializeClient() {
    _assignedBusClient = AssignedBusClient();
  }

  static AssignedBusRepo get instance => _instance;

  Future<bool> assignBus(
      String route, String busNumber, String departureTime) async {
    int retry = 0;
    AssignedBusModel assignedBusModel = AssignedBusModel(
        route: route, busNumber: busNumber, departureTime: departureTime);

    bool response = false;

    while (retry++ < 2) {
      try {
        response = await AssignedBusRepo.instance
            .getAssignedBusClient()
            .assignBus(assignedBusModel);

        return response;
      } catch (err) {
        throw Exception("Something went wrong");
      }
    }
    return response;
  }

  Future<List<AssignedBusModel>> getAssignedBusses(String timeSlot) async {
    try {
      List<AssignedBusModel> response = await AssignedBusRepo.instance
          .getAssignedBusClient()
          .getAssignedBusses(timeSlot);

      return response;
    } catch (err) {
      throw Exception("Something went wrong");
    }
  }

  Future<bool> deleteBus(String busNumber) async {
    try {
      bool response =
          await AssignedBusRepo.instance.getAssignedBusClient().deleteBus(busNumber);

      return response;
    } catch (err) {
      throw Exception("Something went wrong");
    }
  }
}
