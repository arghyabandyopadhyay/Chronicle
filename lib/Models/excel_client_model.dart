import 'package:chronicle/Models/client_model.dart';

class ExcelClientModel {
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
  DateTime joiningDate;
  DateTime dob;
  double height;
  double weight;
  int noOfPayments;
  ExcelClientModel(
      {this.registrationId,
      this.name,
      this.sex,
      this.caste,
      this.mobileNo,
      this.fathersName,
      this.education,
      this.occupation,
      this.address,
      this.injuries,
      this.startDate,
      this.endDate,
      this.joiningDate,
      this.height,
      this.dob,
      this.weight,
      this.noOfPayments,
      this.masterFilter});

  factory ExcelClientModel.fromJson(Map<String, dynamic> json1) {
    DateTime getDate(String date) {
      date = date.replaceFirst(".0", "");
      date = date.replaceAll(" ", "");
      try {
        int length = date.length;
        if (length == 7) date = "0" + date;
        return DateTime(int.parse(date.substring(4, 8)),
            int.parse(date.substring(2, 4)), int.parse(date.substring(0, 2)));
      } catch (E) {
        return null;
      }
    }

    String getSex(String string) {
      string = string.toLowerCase().replaceAll(" ", "");
      if (string.length > 0) {
        if (string[0] == "m")
          return "Male";
        else if (string[0] == "f")
          return "Female";
        else
          return null;
      } else
        return null;
    }

    String getCaste(String string) {
      string = string.toLowerCase().replaceAll(" ", "");
      if (string.length > 0) {
        if (string[0] == "g")
          return "General";
        else if (string[0] == "o")
          return "OBC";
        else if (string[0] == "s")
          return "SC/ST";
        else
          return null;
      } else
        return null;
    }

    String getFormattedMobileNo(String value) {
      value = value.replaceFirst(".0", "");
      value = value.replaceAll(" ", "");
      RegExp mobileNoRegex = new RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)');
      if (value.length == 0) {
        return value;
      } else if (mobileNoRegex.hasMatch(value)) {
        if (value.length == 10) {
          return value.substring(0, 5) + " " + value.substring(5);
        } else if (value.length == 11) {
          return value.substring(1, 6) + " " + value.substring(6);
        } else if (value.length == 12) {
          return value.substring(2, 7) + " " + value.substring(7);
        } else if (value.length == 13) {
          return value.substring(3, 8) + " " + value.substring(8);
        } else
          return "";
      } else {
        return "";
      }
    }

    int getNoOfPayments(String noOfPaymentsString) {
      try {
        int noOfPayments = int.parse(noOfPaymentsString);
        return noOfPayments != 0 ? noOfPayments : 1;
      } catch (E) {
        return 1;
      }
    }

    int months = getNoOfPayments(json1['NoOfPayments']);
    DateTime startDate;
    if (json1['StartDate(DDMMYYYY)'] != null) {
      startDate = getDate(json1['StartDate(DDMMYYYY)']);
      if (startDate == null) {
        DateTime now = DateTime.now();
        startDate = DateTime(now.year, now.month, now.day);
      }
    } else {
      DateTime now = DateTime.now();
      startDate = DateTime(now.year, now.month, now.day);
    }
    DateTime endDate = DateTime(
        startDate.year, startDate.month + (months).abs(), startDate.day);
    String name = json1['Name'] != null ? json1['Name'] : "";
    String mobile = json1['MobileNo'] != null
        ? getFormattedMobileNo(json1['MobileNo'])
        : null;
    return ExcelClientModel(
        registrationId: json1['RegistrationId'],
        name: name,
        fathersName: json1['FathersName'],
        mobileNo: mobile,
        education: json1['Education'],
        occupation: json1['Occupation'],
        address: json1['Address'],
        injuries: json1['Injuries'],
        sex: json1['Sex'] != null ? getSex(json1['Sex']) : null,
        caste: json1['Caste'] != null ? getCaste(json1['Caste']) : null,
        startDate: startDate,
        endDate: endDate,
        joiningDate: json1['JoiningDate(DDMMYYYY)'] != null
            ? getDate(json1['JoiningDate(DDMMYYYY)'])
            : null,
        dob: json1['Dob(DDMMYYYY)'] != null
            ? getDate(json1['Dob(DDMMYYYY)'])
            : null,
        height: json1['Height'] != null ? double.parse(json1['Height']) : null,
        weight: json1['Weight'] != null ? double.parse(json1['Weight']) : null,
        noOfPayments: months,
        masterFilter: null);
  }
  ClientModel toClientModel() => ClientModel(
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
      joiningDate: joiningDate,
      height: height,
      weight: weight,
      due: noOfPayments > 0 ? (noOfPayments - 1) * -1 : noOfPayments.abs(),
      masterFilter: masterFilter);
}
