import 'package:firebase_database/firebase_database.dart';


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
  DateTime joiningDate;
  double height;
  double weight;
  int lastInvoiceNo;
  int due;
  bool isSelected=false;
  ClientModel({this.registrationId,this.name,this.lastInvoiceNo,this.sex,this.caste,this.joiningDate,this.mobileNo,this.fathersName,this.education,this.occupation,this.address,this.injuries,this.startDate,this.endDate,this.height,this.dob,this.weight,this.due,this.masterFilter});
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
        joiningDate: json1['JoiningDate']!=null?DateTime.parse(json1['JoiningDate']):null,
        height: json1['Height']!=null?double.parse(json1['Height'].toString()):null,
        weight: json1['Weight']!=null?double.parse(json1['Weight'].toString()):null,
        due: json1['Due']!=null?json1['Due']:0,
        lastInvoiceNo: json1['LastInvoiceNumber']!=null?json1['LastInvoiceNumber']:0,
        masterFilter:masterFilter
    );
  }
  ClientModel copyClient(){
    return new ClientModel(
        registrationId: this.registrationId,
        name: this.name,
        fathersName: this.fathersName,
        mobileNo: this.mobileNo,
        education: this.education,
        occupation: this.occupation,
        address: this.address,
        injuries: this.injuries,
        sex: this.sex,
        caste: this.caste,
        startDate: this.startDate,
        endDate: this.endDate,
        dob: this.dob,
        joiningDate: this.joiningDate,
        height: this.height,
        weight: this.weight,
        due: this.due,
        lastInvoiceNo: this.lastInvoiceNo,
        masterFilter: this.masterFilter
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
        "JoiningDate":(this.joiningDate!=null)?this.joiningDate.toIso8601String():null,
        "Height":this.height,
        "Weight":this.weight,
        "Due":this.due,
        "LastInvoiceNumber":this.lastInvoiceNo,
        "MasterFilter":this.masterFilter,
      };
}