import 'dart:convert';
import 'package:chronicle/Modules/database.dart';
import 'package:chronicle/Modules/universalModule.dart';
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
  String repo;
  String reminderMessage;
  String smsApiUrl;
  String smsUserId;
  String smsMobileNo;
  String smsAccessToken;
  int isAppRegistered;
  UserModel({this.displayName,this.email,this.phoneNumber,this.canAccess,this.qrcodeDetail,this.token,this.isOwner,this.messageString,this.reminderMessage,this.isAppRegistered,this.repo,this.smsApiUrl,this.smsMobileNo,this.smsUserId,this.smsAccessToken});
  factory UserModel.fromJson(Map<String, dynamic> json1) {
    String decrypt(String encryptedPassword){
      String decryptedPassword = utf8.decode(base64Decode(encryptedPassword));
      return decryptedPassword;
    }
    return UserModel(
        displayName: json1['DisplayName'],
        email: json1['Email'],
        phoneNumber: json1['PhoneNumber'],
        canAccess: json1['CanAccess'],
        isOwner: json1['IsOwner']!=null?json1['IsOwner']:0,
        smsApiUrl: json1['SmsApiUrl'],
        smsMobileNo: json1['SmsMobileNo'],
        smsUserId: json1['SmsUserId']!=null?decrypt(json1['SmsUserId']):null,
        smsAccessToken: json1['SmsAccessToken']!=null?decrypt(json1['SmsAccessToken']):null,
        qrcodeDetail: json1['QrCodeDetail'],
        token: json1['Token'],
        messageString:json1['MessageString'],
        repo:json1['Repo'],
        reminderMessage:json1['ReminderMessage'],
        isAppRegistered: json1['IsAppRegistered']!=null?json1['IsAppRegistered']:0
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
        "ReminderMessage":this.reminderMessage,
        "IsAppRegistered":this.isAppRegistered,
        "SmsApiUrl":this.smsApiUrl,
        "SmsUserId":this.smsUserId!=null?encrypt(this.smsUserId):null,
        "SmsMobileNo":this.smsMobileNo,
        "SmsAccessToken":this.smsAccessToken!=null?encrypt(this.smsAccessToken):null,
      };
}