class NoticeModel {
  String? sId;
  String? name;
  String? description;
  String? imageUrl;
  String? createdOn;

  NoticeModel(
      {this.sId, this.name, this.description, this.imageUrl, this.createdOn});

  NoticeModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    description = json['description'];
    imageUrl = json['imageUrl'];
    createdOn = json['createdOn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();

    data['name'] = name;
    data['description'] = description;
    data['imageUrl'] = imageUrl;

    return data;
  }
}
