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
      date=date.replaceFirst(".0", "");
      date=date.replaceAll(" ", "");
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
    String getSex(String string){
      string=string.toLowerCase().replaceAll(" ", "");
      if(string.length>0)
      {
        if(string[0]=="m")return "Male";
        else if(string[0]=="f") return "Female";
        else return null;
      }
      else return null;
    }
    String getCaste(String string){
      //'General', 'OBC', 'SC/ST'
      string=string.toLowerCase().replaceAll(" ", "");
      if(string.length>0)
      {
        if(string[0]=="g")return "General";
        else if(string[0]=="o") return "OBC";
        else if(string[0]=="s") return "SC/ST";
        else return null;
      }
      else return null;
    }
    String getFormattedMobileNo(String value) {
      value=value.replaceFirst(".0", "");
      value=value.replaceAll(" ", "");
      RegExp mobileNoRegex = new RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)');
      if (value.length == 0) {
        return value;
      }
      else if (mobileNoRegex.hasMatch(value)) {
        if(value.length==10){
          return value.substring(0,5)+" "+value.substring(5);
        }
        else if(value.length==11){
          return value.substring(1,6)+" "+value.substring(6);
        }
        else if(value.length==12){
          return value.substring(2,7)+" "+value.substring(7);
        }
        else if(value.length==13){
          return value.substring(3,8)+" "+value.substring(8);
        }
        else return "";
      }
      else{
        return "";
      }
    }
    int getNoOfPayments(dynamic noOfPayments){
      try{
        return json1['NoOfPayments']!=null||json1['NoOfPayments']>0?json1['NoOfPayments']:1;
      }
      catch(E){
        return 1;
      }
    }
    int months=getNoOfPayments(json1['NoOfPayments']);
    DateTime startDate;
    if(json1['StartDate(DDMMYYYY)']!=null){
      startDate=getDate(json1['StartDate(DDMMYYYY)'].toString());
      if(startDate==null){
        DateTime now=DateTime.now();
        startDate=DateTime(now.year,now.month,now.day);
      }
    }
    else {
      DateTime now=DateTime.now();
      startDate=DateTime(now.year,now.month,now.day);
    }
    DateTime endDate = DateTime(startDate.year,startDate.month+months,startDate.day);
    String name=json1['Name']!=null?json1['Name'].toString():"";
    String mobile=json1['MobileNo']!=null?getFormattedMobileNo(json1['MobileNo'].toString()):null;
    return ExcelClientModel(
        registrationId: json1['RegistrationId']!=null?json1['RegistrationId'].toString():null,
        name: name,
        fathersName: json1['FathersName']!=null?json1['FathersName'].toString():null,
        mobileNo: mobile,
        education: json1['Education']!=null?json1['Education'].toString():null,
        occupation: json1['Occupation']!=null?json1['Occupation'].toString():null,
        address: json1['Address']!=null?json1['Address'].toString():null,
        injuries: json1['Injuries']!=null?json1['Injuries'].toString():null,
        sex: json1['Sex']!=null?getSex(json1['Sex'].toString()):null,
        caste: json1['Caste']!=null?getCaste(json1['Caste'].toString()):null,
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