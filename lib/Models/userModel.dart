import 'package:chronicle/Modules/database.dart';
import 'package:firebase_database/firebase_database.dart';

class UserModel
{
  DatabaseReference? id;
  String? displayName;
  String? email;
  String? phoneNumber;
  String? qrcodeDetail;
  int? canAccess;
  UserModel({this.displayName,this.email,this.phoneNumber,this.canAccess,this.qrcodeDetail});
  factory UserModel.fromJson(Map<String, dynamic> json1) {
    return UserModel(
        displayName: json1['DisplayName'],
        email: json1['Email'],
        phoneNumber: json1['PhoneNumber'],
        canAccess: json1['CanAccess'],
        qrcodeDetail: json1['QrCodeDetail']
    );
  }
  void setId(DatabaseReference id)
  {
    this.id=id;
  }
  void update() {
    updateUserDetails(this, this.id!);
  }
  Map<String,dynamic> toJson() =>
      {
        "DisplayName":this.displayName,
        "Email":this.email,
        "PhoneNumber":this.phoneNumber,
        "CanAccess":this.canAccess,
        "QrCodeDetail":this.qrcodeDetail,
      };
}