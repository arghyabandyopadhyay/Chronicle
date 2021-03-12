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
  DateTime startDate;
  DateTime endDate;
  DateTime dob;
  int height;
  int weight;
  int due;
  ClientModel({this.name,this.fathersName,this.education,this.occupation,this.address,this.injuries,this.fitnessGoal,this.startDate,this.endDate,this.height,this.dob,this.weight,this.due});
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
        education: json1['Education'],
        occupation: json1['Occupation'],
        address: json1['Address'],
        injuries: json1['Injuries'],
        fitnessGoal: json1['FitnessGoal'],
        startDate: DateTime.parse(json1['StartDate']),
        endDate: DateTime.parse(json1['EndDate']),
        dob: DateTime.parse(json1['EndDate']),
        height: json1['Height'],
        weight: json1['Weight'],
        due: json1['Due']
    );
  }
  Map toJson() =>
      {
        "Name":this.name,
        "FathersName":this.fathersName,
        "Education":this.education,
        "Occupation":this.occupation,
        "Address":this.address,
        "Injuries":this.injuries,
        "FitnessGoal":this.fitnessGoal,
        "StartDate":this.startDate.toIso8601String(),
        "EndDate":this.endDate.toIso8601String(),
        "Dob":this.dob.toIso8601String(),
        "Height":this.height,
        "Weight":this.weight,
        "Due":this.due
      };
}