
import 'package:firebase_database/firebase_database.dart';


class VideoIndexModel {
  final String directory;
  String downloadUrl;
  String thumbnailUrl;
  String name;
  String sharedRegisterKeys;
  int cloudStorageSize;
  int thumbnailSize;
  bool isSelected=false;
  DatabaseReference id;

  VideoIndexModel({this.directory, this.name,this.sharedRegisterKeys,this.downloadUrl,this.thumbnailSize,this.thumbnailUrl,this.cloudStorageSize});

  factory VideoIndexModel.fromJson(Map<String, dynamic> json1,String idKey) {
    return VideoIndexModel(
      directory: json1['Directory'],
      name: json1['Name'],
      sharedRegisterKeys:json1['Registers'],
      downloadUrl:json1['DownloadUrl'],
      cloudStorageSize:json1['CloudStorageSize']!=null?json1['CloudStorageSize']:0,
      thumbnailSize:json1['ThumbnailSize']!=null?json1['ThumbnailSize']:0,
      thumbnailUrl:json1['ThumbnailUrl']
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
        "CloudStorageSize":this.cloudStorageSize,
        "ThumbnailSize":this.thumbnailSize,
        "ThumbnailUrl":this.thumbnailUrl,
      };
}