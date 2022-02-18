import 'dart:convert';
import 'package:chronicle/Models/token_model.dart';
import 'package:chronicle/Modules/database.dart';
import 'package:chronicle/Modules/universal_module.dart';
import 'package:firebase_database/firebase_database.dart';

import '../global_class.dart';

class UserModel {
  DatabaseReference id;
  String displayName;
  String email;
  String phoneNumber;
  String qrcodeDetail;
  int canAccess;
  int isOwner;
  String messageString;
  String repo;
  String reminderMessage;
  String termsAndConditions;
  String smsApiUrl;
  String smsUserId;
  String smsMobileNo;
  String smsAccessToken;
  String organizationName;
  String organizationAddress;
  int cloudStorageSize;
  int cloudStorageSizeLimit;
  int isAppRegistered;
  double yearlyPaymentPrice;
  List<TokenModel> tokens;
  UserModel(
      {this.displayName,
      this.termsAndConditions,
      this.cloudStorageSizeLimit,
      this.yearlyPaymentPrice,
      this.email,
      this.phoneNumber,
      this.canAccess,
      this.qrcodeDetail,
      this.tokens,
      this.isOwner,
      this.messageString,
      this.reminderMessage,
      this.isAppRegistered,
      this.repo,
      this.smsApiUrl,
      this.smsMobileNo,
      this.smsUserId,
      this.smsAccessToken,
      this.cloudStorageSize,
      this.organizationName,
      this.organizationAddress});
  factory UserModel.fromJson(Map<String, dynamic> json1, String idKey) {
    String decrypt(String encryptedPassword) {
      String decryptedPassword = utf8.decode(base64Decode(encryptedPassword));
      return decryptedPassword;
    }

    List<TokenModel> getToken(Map<String, dynamic> jsonList) {
      List<TokenModel> tokenList = [];
      if (jsonList != null) {
        jsonList.keys.forEach((key) {
          TokenModel tokenModel =
              TokenModel.fromJson(jsonDecode(jsonEncode(jsonList[key])));
          tokenModel.setId(databaseReference.child(
              '${GlobalClass.user.uid}/userDetails/$idKey/Tokens/' + key));
          tokenList.add(tokenModel);
        });
      }
      return tokenList;
    }

    return UserModel(
        displayName: json1['DisplayName'],
        email: json1['Email'],
        phoneNumber: json1['PhoneNumber'],
        canAccess: json1['CanAccess'],
        isOwner: json1['IsOwner'] != null ? json1['IsOwner'] : 0,
        smsApiUrl: json1['SmsApiUrl'],
        smsMobileNo: json1['SmsMobileNo'],
        smsUserId:
            json1['SmsUserId'] != null ? decrypt(json1['SmsUserId']) : null,
        smsAccessToken: json1['SmsAccessToken'] != null
            ? decrypt(json1['SmsAccessToken'])
            : null,
        qrcodeDetail: json1['QrCodeDetail'],
        tokens: json1['Tokens'] != null
            ? getToken(jsonDecode(jsonEncode(json1['Tokens'])))
            : null,
        messageString: json1['MessageString'],
        repo: json1['Repo'],
        reminderMessage: json1['ReminderMessage'],
        termsAndConditions: json1['TermsAndConditions'],
        organizationName: json1['OrganizationName'],
        organizationAddress: json1['OrganizationAddress'],
        cloudStorageSize:
            json1['CloudStorageSize'] != null ? json1['CloudStorageSize'] : 0,
        cloudStorageSizeLimit: json1['CloudStorageSizeLimit'] != null
            ? json1['CloudStorageSizeLimit']
            : 10000000000,
        yearlyPaymentPrice: json1['YearlyPaymentPrice'] != null
            ? json1['YearlyPaymentPrice']
            : 1000,
        isAppRegistered:
            json1['IsAppRegistered'] != null ? json1['IsAppRegistered'] : 0);
  }
  void setId(DatabaseReference id) {
    this.id = id;
  }

  void update() {
    updateUserDetails(this, this.id);
  }

  Map<String, dynamic> toJson() => {
        "DisplayName": this.displayName,
        "Email": this.email,
        "PhoneNumber": this.phoneNumber,
        "CanAccess": this.canAccess,
        "QrCodeDetail": this.qrcodeDetail,
        "CloudStorageSize":
            this.cloudStorageSize != null ? this.cloudStorageSize : 0,
        "ReminderMessage": this.reminderMessage,
        "TermsAndConditions": this.termsAndConditions,
        "OrganizationName": this.organizationName,
        "OrganizationAddress": this.organizationAddress,
        "IsAppRegistered": this.isAppRegistered,
        "SmsApiUrl": this.smsApiUrl,
        "SmsUserId": this.smsUserId != null ? encrypt(this.smsUserId) : null,
        "SmsMobileNo": this.smsMobileNo,
        "SmsAccessToken":
            this.smsAccessToken != null ? encrypt(this.smsAccessToken) : null,
        "CloudStorageSizeLimit": this.cloudStorageSizeLimit != null
            ? this.cloudStorageSizeLimit
            : 10000000000
      };
}
