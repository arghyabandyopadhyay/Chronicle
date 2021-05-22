import 'dart:convert';

import 'package:chronicle/Models/CourseModels/doubtModel.dart';
import 'package:chronicle/Modules/database.dart';
import 'package:firebase_database/firebase_database.dart';
import '../../globalClass.dart';

class VideoIndexModel {
  String directory;
  String downloadUrl;
  String thumbnailUrl;
  String name;
  String description;
  String masterFilter;
  int cloudStorageSize;
  int thumbnailSize;
  bool isSelected=false;
  DatabaseReference id;
  List<DoubtModel> doubts;

  VideoIndexModel({this.directory, this.name,this.description,this.masterFilter,this.downloadUrl,this.thumbnailSize,this.thumbnailUrl,this.cloudStorageSize,this.doubts});

  factory VideoIndexModel.fromJson(Map<String, dynamic> json1,String idKey) {
    List<DoubtModel> getDoubts(Map<String, dynamic> jsonList){
      List<DoubtModel> doubts = [];
      if (jsonList!= null) {
        jsonList.keys.forEach((key) {
          DoubtModel doubt = DoubtModel.fromJson(jsonDecode(jsonEncode(jsonList[key])));
          doubt.setId(databaseReference.child('${GlobalClass.user.uid}/registers/$idKey/client/' + key));
          doubts.add(doubt);
        });
      }
      return doubts;
    }
    return VideoIndexModel(
      directory: json1['Directory'],
      name: json1['Name'],
      description: json1['Description'],
      masterFilter: json1['MasterFilter'],
      downloadUrl:json1['DownloadUrl'],
      cloudStorageSize:json1['CloudStorageSize']!=null?json1['CloudStorageSize']:0,
      thumbnailSize:json1['ThumbnailSize']!=null?json1['ThumbnailSize']:0,
      thumbnailUrl:json1['ThumbnailUrl'],
      // doubts:getDoubts(jsonDecode(jsonEncode(json1['Doubts'])))
    );
  }

  void setId(DatabaseReference id)
  {
    this.id=id;
  }

  Map<String,dynamic> toJson() =>
      {
        "Name":this.name,
        "Description":this.description,
        "MasterFilter":this.masterFilter,
        "Directory":this.directory,
        "DownloadUrl":this.downloadUrl,
        "CloudStorageSize":this.cloudStorageSize,
        "ThumbnailSize":this.thumbnailSize,
        "ThumbnailUrl":this.thumbnailUrl,
      };
}