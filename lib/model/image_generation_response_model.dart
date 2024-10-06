class ImageGenerationResponseModel {
  int? created;
  List<Data>? data;

  ImageGenerationResponseModel({this.created, this.data});

  ImageGenerationResponseModel.fromJson(Map<String, dynamic> json) {
    created = json['created'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['created'] = this.created;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? revisedPrompt;
  String? url;

  Data({this.revisedPrompt, this.url});

  Data.fromJson(Map<String, dynamic> json) {
    revisedPrompt = json['revised_prompt'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['revised_prompt'] = this.revisedPrompt;
    data['url'] = this.url;
    return data;
  }
}
