import 'package:chronicle/Models/clientModel.dart';

class ExcelClientModel
{
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
  int noOfPayments;
  ExcelClientModel({this.registrationId,this.name,this.sex,this.caste,this.mobileNo,this.fathersName,this.education,this.occupation,this.address,this.injuries,this.startDate,this.endDate,this.height,this.dob,this.weight,this.noOfPayments,this.masterFilter});

  factory ExcelClientModel.fromJson(Map<String, dynamic> json1) {
    DateTime getDate(String date){
      try{
        int length=date.length;
        if(length==7)date="0"+date;
        return DateTime(int.parse(date.substring(4,8)),int.parse(date.substring(2,4)),int.parse(date.substring(0,2)));
      }
      catch(E)
      {
        return null;
      }
    }
    int months=json1['NoOfPayments']!=null?json1['NoOfPayments']:0;
    DateTime startDate;
    if(json1['StartDate(DDMMYYYY)']!=null)
    startDate=getDate(json1['StartDate(DDMMYYYY)'].toString());
    else {
      DateTime now=DateTime.now();
      startDate=DateTime(now.year,now.month,now.day);
    }
    DateTime endDate = DateTime(startDate.year,startDate.month+months,startDate.day);
    String name=json1['Name']!=null?json1['Name'].toString():"";
    String mobile=json1['MobileNo']!=null?json1['MobileNo'].toString():null;
    return ExcelClientModel(
        registrationId: json1['RegistrationId']!=null?json1['RegistrationId'].toString():null,
        name: name,
        fathersName: json1['FathersName']!=null?json1['FathersName'].toString():null,
        mobileNo: mobile,
        education: json1['Education']!=null?json1['Education'].toString():null,
        occupation: json1['Occupation']!=null?json1['Occupation'].toString():null,
        address: json1['Address']!=null?json1['Address'].toString():null,
        injuries: json1['Injuries']!=null?json1['Injuries'].toString():null,
        sex: json1['Sex']!=null?json1['Sex'].toString():null,
        caste: json1['Caste']!=null?json1['Caste'].toString():null,
        startDate: startDate,
        endDate: endDate,
        dob: json1['Dob(DDMMYYYY)']!=null?getDate(json1['Dob(DDMMYYYY)'].toString()):null,
        height: json1['Height']!=null?double.parse(json1['Height'].toString()):null,
        weight: json1['Weight']!=null?double.parse(json1['Weight'].toString()):null,
        noOfPayments: months,
        masterFilter: null
    );
  }
  ClientModel toClientModel()=>ClientModel(
      registrationId: registrationId,
      name: name,
      fathersName: fathersName,
      mobileNo: mobileNo,
      education: education,
      occupation: occupation,
      address: address,
      injuries: injuries,
      sex: sex,
      caste: caste,
      startDate: startDate,
      endDate: endDate,
      dob: dob,
      height: height,
      weight: weight,
      due: (noOfPayments-1)*-1,
      masterFilter:masterFilter
  );
}