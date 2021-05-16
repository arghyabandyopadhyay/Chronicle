
import 'package:firebase_database/firebase_database.dart';


class VideoIndexModel {
  final String directory;
  String downloadUrl;
  String name;
  String sharedRegisterKeys;
  bool isSelected=false;
  DatabaseReference id;

  VideoIndexModel({this.directory, this.name,this.sharedRegisterKeys,this.downloadUrl});

  factory VideoIndexModel.fromJson(Map<String, dynamic> json1,String idKey) {
    return VideoIndexModel(
      directory: json1['Directory'],
      name: json1['Name'],
      sharedRegisterKeys:json1['Registers'],
      downloadUrl:json1['DownloadUrl']
    );
  }

  void setId(DatabaseReference id)
  {
    this.id=id;
  }

  Map<String,dynamic> toJson() =>
      {
        "Name":this.name,
        "Directory":this.directory,
        "Registers":this.sharedRegisterKeys,
        "DownloadUrl":this.downloadUrl,
      };
}