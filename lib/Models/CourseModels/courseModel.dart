import 'dart:convert';

import 'package:chronicle/Models/CourseModels/videoIndexModel.dart';
import 'package:chronicle/Modules/database.dart';
import 'package:firebase_database/firebase_database.dart';
import '../../globalClass.dart';

class CourseModel {
  DatabaseReference id;
  String previewThumbnailUrl;
  String authorUid;
  String authorName;
  String title;
  String description;
  String whatWillYouLearn;
  String courseIndexKey;
  double authorPrice;
  double sellingPrice;
  int coursePackageDurationInMonths;
  DateTime lastUpdated;
  int totalUsers;
  List<VideoIndexModel> videos;
  VideoIndexModel previewVideo;

  CourseModel({this.videos,this.previewThumbnailUrl,this.courseIndexKey,this.authorName,this.previewVideo,this.totalUsers,this.authorUid, this.title,this.description,this.whatWillYouLearn,this.authorPrice,this.sellingPrice,this.coursePackageDurationInMonths,this.lastUpdated});

  factory CourseModel.fromJson(Map<String, dynamic> json1,String path) {
    List<VideoIndexModel> getVideos(Map<String, dynamic> jsonList){
      List<VideoIndexModel> clientsList = [];
      if (jsonList!= null) {
        jsonList.keys.forEach((key) {
          VideoIndexModel clientModel = VideoIndexModel.fromJson(jsonDecode(jsonEncode(jsonList[key])),key);
          clientModel.setId(databaseReference.child('$path/Videos/' + key));
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
          previewVideo.setId(databaseReference.child('$path/PreviewVideo/' + key));
        });
      }
      return previewVideo;
    }
    return CourseModel(
        totalUsers: json1['TotalUsers'],
        authorUid: json1['AuthorUid'],
        authorName: json1['AuthorName'],
        title:json1['Title'],
        description:json1['Description'],
        previewThumbnailUrl: json1['PreviewThumbnailUrl'],
        courseIndexKey: json1['CourseIndexKey'],
        whatWillYouLearn:json1['WhatWillYouLearn'],
        coursePackageDurationInMonths:json1['CoursePackageDurationInMonths']!=null?json1['CoursePackageDurationInMonths']:1,
        authorPrice:json1['AuthorPrice']!=null?double.parse(json1['AuthorPrice'].toString()):null,
        sellingPrice:json1['SellingPrice']!=null?double.parse(json1['SellingPrice'].toString()):null,
        lastUpdated:json1['LastUpdated']!=null?DateTime.parse(json1['LastUpdated']):null,
        videos: getVideos(jsonDecode(jsonEncode(json1['Videos']))),
        previewVideo: getPreviewVideo(jsonDecode(jsonEncode(json1['PreviewVideo'])))
    );
  }

  void setId(DatabaseReference id)
  {
    this.id=id;
  }
  void addVideoIndexes(){
    this.videos.forEach((element) {
      var courseId=this.id.child("Videos").push();
      courseId.set(element.toJson());
    });
  }
  void addVideoIndex(VideoIndexModel video){
    var courseId=this.id.child("Videos/").push();
    courseId.set(video.toJson());
    video.setId(courseId);
    this.videos.add(video);
  }
  void deleteVideoIndex(VideoIndexModel video){
    print(video.id.path);
    print(id.path);
    deleteDatabaseNode(video.id);
    this.videos.remove(video);
  }
  void addPreviewVideoIndexes(){
    var courseId=this.id.child("PreviewVideo").push();
    courseId.set(this.previewVideo.toJson());
  }
  void deletePreviewVideoIndexes(){
    print(this.previewVideo.id.path);
    deleteDatabaseNode(this.previewVideo.id);
  }
  void updateVideoIndexes(){
    deleteDatabaseNode(this.id.child("Videos"));
    addVideoIndexes();
  }
  void updatePreviewVideoIndex(){
    deleteDatabaseNode(this.id.child("PreviewVideo"));
    this.id.update({"PreviewThumbnailUrl":this.previewThumbnailUrl});
    var tempId=databaseReference.child("CourseIndexes/${this.courseIndexKey}");
    tempId.update({"PreviewThumbnailUrl":this.previewThumbnailUrl});
    addPreviewVideoIndexes();
  }
  void delete(){
    var tempId=databaseReference.child("CourseIndexes/${this.courseIndexKey}");
    deleteDatabaseNode(tempId);
    deleteDatabaseNode(this.id);
  }
  Map<String,dynamic> toJson() =>
      {
        "TotalUsers": this.totalUsers,
        "AuthorUid": this.authorUid,
        "AuthorName": this.authorName,
        "Title":this.title,
        "PreviewThumbnailUrl":this.previewThumbnailUrl,
        "CourseIndexKey":this.courseIndexKey,
        "Description":this.description,
        "WhatWillYouLearn":this.whatWillYouLearn,
        "CoursePackageDurationInMonths":this.coursePackageDurationInMonths,
        "AuthorPrice":this.authorPrice,
        "SellingPrice":this.sellingPrice,
        "LastUpdated":(this.lastUpdated!=null)?this.lastUpdated.toIso8601String():null,
      };
}