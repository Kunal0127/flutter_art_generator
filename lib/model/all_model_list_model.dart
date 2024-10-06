class AllModelListModel {
  String? object;
  List<Data>? data;

  AllModelListModel({this.object, this.data});

  AllModelListModel.fromJson(Map<String, dynamic> json) {
    object = json['object'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['object'] = this.object;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? id;
  String? object;
  int? created;
  String? ownedBy;

  Data({this.id, this.object, this.created, this.ownedBy});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    object = json['object'];
    created = json['created'];
    ownedBy = json['owned_by'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['object'] = this.object;
    data['created'] = this.created;
    data['owned_by'] = this.ownedBy;
    return data;
  }
}
