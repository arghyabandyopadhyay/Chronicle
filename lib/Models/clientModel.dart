import 'package:firebase_database/firebase_database.dart';

import '../database.dart';

class ClientModel
{
  DatabaseReference id;
  String name;
  String fathersName;
  String education;
  String occupation;
  String address;
  String injuries;
  String fitnessGoal;
  String bloodGroup;
  String mobileNo;
  DateTime startDate;
  DateTime endDate;
  DateTime dob;
  int height;
  int weight;
  int due;
  ClientModel({this.name,this.mobileNo,this.fathersName,this.education,this.occupation,this.address,this.injuries,this.fitnessGoal,this.startDate,this.endDate,this.height,this.dob,this.weight,this.due,this.bloodGroup});
  void setId(DatabaseReference id)
  {
    this.id=id;
  }
  void update() {
    updateClient(this, this.id);
  }
  factory ClientModel.fromJson(Map<String, dynamic> json1) {
    return ClientModel(
        name: json1['Name'],
        fathersName: json1['FathersName'],
        mobileNo: json1['MobileNo'],
        education: json1['Education'],
        occupation: json1['Occupation'],
        address: json1['Address'],
        injuries: json1['Injuries'],
        fitnessGoal: json1['FitnessGoal'],
        bloodGroup: json1['BloodGroup'],
        startDate: json1['StartDate']!=null?DateTime.parse(json1['StartDate']):null,
        endDate: json1['EndDate']!=null?DateTime.parse(json1['EndDate']):null,
        dob: json1['Dob']!=null?DateTime.parse(json1['Dob']):null,
        height: json1['Height'],
        weight: json1['Weight'],
        due: json1['Due']
    );
  }
  Map<String,dynamic> toJson() =>
      {
        "Name":this.name,
        "FathersName":this.fathersName,
        "MobileNo":this.mobileNo,
        "Education":this.education,
        "Occupation":this.occupation,
        "Address":this.address,
        "Injuries":this.injuries,
        "FitnessGoal":this.fitnessGoal,
        "StartDate":this.startDate!=null?this.startDate.toIso8601String():null,
        "EndDate":this.endDate!=null?this.endDate.toIso8601String():null,
        "BloodGroup":this.bloodGroup,
        "Dob":this.dob!=null?this.dob.toIso8601String():null,
        "Height":this.height,
        "Weight":this.weight,
        "Due":this.due
      };
}