import 'package:firebase_database/firebase_database.dart';

class DoubtModel {
  DatabaseReference id;
  String userName;
  String question;
  String answer;

  DoubtModel({this.userName,this.question,this.answer});
  factory DoubtModel.fromJson(Map<String, dynamic> json1,String path) {
    return DoubtModel(
        userName: json1['UserName'],
        question:json1['Question'],
        answer:json1['Answer'],
    );
  }
  void setId(DatabaseReference id){
    this.id=id;
  }
  //Reply to the doubt
  void replyToDoubtToVideo(){
    this.id.update(this.toJson());
  }
  Map<String,dynamic> toJson() =>
      {
        "UserName": userName,
        "Question":question,
        "Answer":answer,
      };
}