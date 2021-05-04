import 'package:firebase_database/firebase_database.dart';

import '../Modules/database.dart';

class ClientModel
{
  DatabaseReference id;
  String name;
  String registrationId;
  String fathersName;
  String education;
  String occupation;
  String address;
  String injuries;
  String sex;
  String caste;
  String mobileNo;
  String masterFilter;
  DateTime startDate;
  DateTime endDate;
  DateTime dob;
  double height;
  double weight;
  int due;
  bool isSelected=false;
  ClientModel({this.registrationId,this.name,this.sex,this.caste,this.mobileNo,this.fathersName,this.education,this.occupation,this.address,this.injuries,this.startDate,this.endDate,this.height,this.dob,this.weight,this.due,this.masterFilter});
  void setId(DatabaseReference id)
  {
    this.id=id;
  }
  factory ClientModel.fromJson(Map<String, dynamic> json1) {
    String startDate=json1['StartDate'];
    String endDate=json1['EndDate'];
    String name=json1['Name'];
    String mobile=json1['MobileNo'];
    String masterFilter=json1['MasterFilter']!=null?json1['MasterFilter']:((name+(mobile!=null?mobile:"")+(startDate!=null?startDate:"")+(endDate!=null?endDate:"")).replaceAll(new RegExp(r'\W+'),"").toLowerCase());
    return ClientModel(
        registrationId: json1['RegistrationId'],
        name: name,
        fathersName: json1['FathersName'],
        mobileNo: mobile,
        education: json1['Education'],
        occupation: json1['Occupation'],
        address: json1['Address'],
        injuries: json1['Injuries'],
        sex: json1['Sex'],
        caste: json1['Caste'],
        startDate: DateTime.parse(startDate),
        endDate: DateTime.parse(endDate),
        dob: json1['Dob']!=null?DateTime.parse(json1['Dob']):null,
        height: json1['Height']!=null?double.parse(json1['Height'].toString()):null,
        weight: json1['Weight']!=null?double.parse(json1['Weight'].toString()):null,
        due: json1['Due']!=null?json1['Due']:0,
        masterFilter:masterFilter
    );
  }
  Map<String,dynamic> toJson() =>
      {
        "RegistrationId":this.registrationId,
        "Name":this.name,
        "FathersName":this.fathersName,
        "MobileNo":this.mobileNo,
        "Education":this.education,
        "Occupation":this.occupation,
        "Address":this.address,
        "Injuries":this.injuries,
        "Sex":this.sex,
        "StartDate":(this.startDate!=null)?this.startDate.toIso8601String():null,
        "EndDate":(this.endDate!=null)?this.endDate.toIso8601String():null,
        "Caste":this.caste,
        "Dob":(this.dob!=null)?this.dob.toIso8601String():null,
        "Height":this.height,
        "Weight":this.weight,
        "Due":this.due,
        "MasterFilter":this.masterFilter,
      };
}