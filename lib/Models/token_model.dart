
import 'package:firebase_database/firebase_database.dart';


class TokenModel {
  String token;
  String deviceId;
  String deviceModel;
  DatabaseReference id;
  TokenModel({this.deviceId, this.token,this.deviceModel});

  factory TokenModel.fromJson(Map<String, dynamic> json1) {
    return TokenModel(
      deviceId: json1['DeviceId'],
      deviceModel: json1['DeviceModel'],
      token: json1['Token'],
    );
  }
  void setId(DatabaseReference id)
  {
    this.id=id;
  }
  Map<String,dynamic> toJson() =>
      {
        "DeviceId":this.deviceId,
        "DeviceModel":this.deviceModel,
        "Token":this.token,
      };
}