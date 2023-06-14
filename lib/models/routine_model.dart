class RoutineModel {
  String? sId;
  String? type;
  String? routineUrl;

  RoutineModel({this.sId, this.type, this.routineUrl});

  RoutineModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    type = json['type'];
    routineUrl = json['routineUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();

    data['type'] = type;
    data['routineUrl'] = routineUrl;

    return data;
  }
}
