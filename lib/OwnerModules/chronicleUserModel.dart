import 'package:firebase_database/firebase_database.dart';

class ChronicleUserModel
{
  DatabaseReference id;
  String displayName;
  String email;
  String uid;
  int canAccess;
  ChronicleUserModel({this.displayName,this.email,this.uid,this.canAccess});
  factory ChronicleUserModel.fromJson(Map<String, dynamic> json1) {
    return ChronicleUserModel(
        displayName: json1['DisplayName'],
        email: json1['Email'],
        uid: json1['UID'],
        canAccess: json1['CanAccess'],
    );
  }
  void setId(DatabaseReference id)
  {
    this.id=id;
  }
  Map<String,dynamic> toJson() =>
      {
        "DisplayName":this.displayName,
        "Email":this.email,
        "UID":this.uid,
        "CanAccess":this.canAccess,
      };
}