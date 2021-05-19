import 'package:firebase_database/firebase_database.dart';

class DoubtModel {
  DatabaseReference id;
  String userUid;
  String videoUid;
  String question;
  String answer;

  DoubtModel({this.userUid,this.videoUid,this.question,this.answer});

  factory DoubtModel.fromJson(Map<String, dynamic> json1) {
    return DoubtModel(
        userUid: json1['UserUid'],
        videoUid: json1['VideoUid'],
        question:json1['Question'],
        answer:json1['Answer'],
    );
  }

  void setId(DatabaseReference id)
  {
    this.id=id;
  }

  Map<String,dynamic> toJson() =>
      {
        "UserUid": userUid,
        "VideoUid": videoUid,
        "Question":question,
        "Answer":answer,
      };
}