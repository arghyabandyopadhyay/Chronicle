import 'package:chronicle/Modules/database.dart';
import 'package:firebase_database/firebase_database.dart';

class UserModel
{
  DatabaseReference id;
  String displayName;
  String email;
  String phoneNumber;
  String qrcodeDetail;
  String token;
  int canAccess;
  int isOwner;
  String messageString;
  String reminderMessage;
  UserModel({this.displayName,this.email,this.phoneNumber,this.canAccess,this.qrcodeDetail,this.token,this.isOwner,this.messageString,this.reminderMessage});
  factory UserModel.fromJson(Map<String, dynamic> json1) {
    return UserModel(
        displayName: json1['DisplayName'],
        email: json1['Email'],
        phoneNumber: json1['PhoneNumber'],
        canAccess: json1['CanAccess'],
        isOwner: json1['IsOwner']!=null?json1['IsOwner']:0,
        qrcodeDetail: json1['QrCodeDetail'],
        token: json1['Token'],
        messageString:json1['MessageString'],
        reminderMessage:json1['ReminderMessage']
    );
  }
  void setId(DatabaseReference id)
  {
    this.id=id;
  }
  void update() {
    updateUserDetails(this, this.id);
  }
  Map<String,dynamic> toJson() =>
      {
        "DisplayName":this.displayName,
        "Email":this.email,
        "PhoneNumber":this.phoneNumber,
        "CanAccess":this.canAccess,
        "QrCodeDetail":this.qrcodeDetail,
        "Token":this.token,
        "ReminderMessage":this.reminderMessage
      };
}