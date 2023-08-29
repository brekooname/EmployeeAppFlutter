// To parse this JSON data, do
//
//     final imageModel = imageModelFromJson(jsonString);

import 'dart:convert';

List<ImageModel> imageModelFromJson(String str) => List<ImageModel>.from(json.decode(str).map((x) => ImageModel.fromJson(x)));

String imageModelToJson(List<ImageModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ImageModel {
  String imageName;
  String imagePath;
  bool imageSelected;

  ImageModel({
    required this.imageName,
    required this.imagePath,
    required this.imageSelected,
  });

  factory ImageModel.fromJson(Map<String, dynamic> json) => ImageModel(
    imageName: json["image_name"],
    imagePath: json["image_path"],
    imageSelected: json["image_selected"],
  );

  Map<String, dynamic> toJson() => {
    "image_name": imageName,
    "image_path": imagePath,
    "image_selected": imageSelected,
  };
}
