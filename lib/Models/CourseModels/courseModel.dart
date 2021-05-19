import 'dart:convert';

import 'package:chronicle/Models/CourseModels/videoIndexModel.dart';
import 'package:chronicle/Modules/database.dart';
import 'package:firebase_database/firebase_database.dart';
import '../../globalClass.dart';

class CourseModel {
  String previewThumbnailUrl;
  String authorUid;
  String title;
  String description;
  String whatWillYouLearn;
  double authorPrice;
  double sellingPrice;
  int coursePackageDurationInMonths;
  DateTime lastUpdated;
  int totalUsers;
  DatabaseReference id;
  List<VideoIndexModel> videos;
  VideoIndexModel previewVideo;

  CourseModel({this.videos,this.previewThumbnailUrl,this.previewVideo,this.totalUsers,this.authorUid, this.title,this.description,this.whatWillYouLearn,this.authorPrice,this.sellingPrice,this.coursePackageDurationInMonths,this.lastUpdated});

  factory CourseModel.fromJson(Map<String, dynamic> json1,String idKey) {
    List<VideoIndexModel> getVideos(Map<String, dynamic> jsonList){
      List<VideoIndexModel> clientsList = [];
      if (jsonList!= null) {
        jsonList.keys.forEach((key) {
          VideoIndexModel clientModel = VideoIndexModel.fromJson(jsonDecode(jsonEncode(jsonList[key])),key);
          clientModel.setId(databaseReference.child('VideoIndex/${GlobalClass.user.uid}/' + key));
          clientsList.add(clientModel);
        });
      }
      return clientsList;
    }
    VideoIndexModel getPreviewVideo(Map<String, dynamic> json){
      VideoIndexModel previewVideo;
      if (json!= null) {
        json.keys.forEach((key) {
          previewVideo = VideoIndexModel.fromJson(jsonDecode(jsonEncode(json[key])),key);
          previewVideo.setId(databaseReference.child('VideoIndex/${GlobalClass.user.uid}/' + key));
        });
      }
      return previewVideo;
    }
    return CourseModel(
        totalUsers: json1['TotalUsers'],
        authorUid: json1['AuthorUid'],
        title:json1['Title'],
        description:json1['Description'],
        whatWillYouLearn:json1['WhatWillYouLearn'],
        coursePackageDurationInMonths:json1['CoursePackageDurationInMonths']!=null?json1['CoursePackageDurationInMonths']:1,
        authorPrice:json1['AuthorPrice'],
        sellingPrice:json1['SellingPrice'],
        lastUpdated:json1['LastUpdated'],
        previewThumbnailUrl: json1['PreviewThumbnailUrl'],
        videos: getVideos(jsonDecode(jsonEncode(json1['Videos']))),
        previewVideo: getPreviewVideo(jsonDecode(jsonEncode(json1['Videos'])))
    );
  }

  void setId(DatabaseReference id)
  {
    this.id=id;
  }

  Map<String,dynamic> toJson() =>
      {
        "TotalUsers": this.totalUsers,
        "AuthorUid": this.authorPrice,
        "Title":this.title,
        "PreviewThumbnailUrl":this.previewThumbnailUrl,
        "Description":this.description,
        "WhatWillYouLearn":this.whatWillYouLearn,
        "CoursePackageDurationInMonths":this.coursePackageDurationInMonths,
        "AuthorPrice":this.authorPrice,
        "SellingPrice":this.sellingPrice,
        "LastUpdated":this.lastUpdated,
      };
}