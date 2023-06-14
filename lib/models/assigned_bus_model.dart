class AssignedBusModel {
  String? sId;
  String? route;
  String? busNumber;
  String? departureTime;

  AssignedBusModel({this.sId, this.route, this.busNumber, this.departureTime});

  AssignedBusModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    route = json['route'];
    busNumber = json['busNumber'];
    departureTime = json['departureTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();

    data['route'] = route;
    data['busNumber'] = busNumber;
    data['departureTime'] = departureTime;

    return data;
  }
}
