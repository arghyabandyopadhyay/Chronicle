
import 'package:firebase_database/firebase_database.dart';


class RegisterIndexModel {
  final String uid;
  final String name;
  DatabaseReference id;

  RegisterIndexModel({this.uid, this.name});

  factory RegisterIndexModel.fromJson(Map<String, dynamic> json1,String idKey) {
    return RegisterIndexModel(
      uid: json1['UID'],
      name: json1['Name'],
    );
  }

  void setId(DatabaseReference id)
  {
    this.id=id;
  }

  Map<String,dynamic> toJson() =>
      {
        "Name":this.name,
        "UID":this.uid,
      };
}