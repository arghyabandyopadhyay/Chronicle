import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:chronicle/Models/CourseModels/courseIndexModel.dart';
import 'package:chronicle/Models/CourseModels/courseModel.dart';
import 'package:chronicle/Models/client_model.dart';
import 'package:chronicle/Models/data_model.dart';
import 'package:chronicle/Models/excel_client_model.dart';
import 'package:chronicle/Models/payment_detail_model.dart';
import 'package:chronicle/Models/register_index_model.dart';
import 'package:chronicle/Models/CourseModels/videoIndexModel.dart';
import 'package:chronicle/Modules/utils.dart';
import 'package:chronicle/PdfModule/api/pdfApi.dart';
import 'package:chronicle/PdfModule/api/pdfInvoiceApi.dart';
import 'package:chronicle/PdfModule/model/invoice.dart';
import 'package:chronicle/PdfModule/model/supplier.dart';
import 'package:chronicle/global_class.dart';
import 'package:chronicle/Widgets/add_quantity_dialog.dart';
import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_archive/flutter_archive.dart';
import 'package:flutter_mailer/flutter_mailer.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'database.dart';
import 'package:excel/excel.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:chronicle/Models/register_model.dart';

void globalShowInSnackBar(
    GlobalKey<ScaffoldMessengerState> messengerState, String content) {
  messengerState.currentState.hideCurrentSnackBar();
  messengerState.currentState
      .showSnackBar(new SnackBar(content: Text(content)));
}

String encrypt(String password) {
  String encryptedPassword = "";
  Uint8List encode = utf8.encode(password);
  encryptedPassword = base64Encode(encode);
  return encryptedPassword;
}

String getMonth(int month) {
  String monthString;
  switch (month) {
    case 1:
      monthString = "Jan ";
      break;
    case 2:
      monthString = "Feb ";
      break;
    case 3:
      monthString = "Mar ";
      break;
    case 4:
      monthString = "Apr ";
      break;
    case 5:
      monthString = "May ";
      break;
    case 6:
      monthString = "Jun ";
      break;
    case 7:
      monthString = "Jul ";
      break;
    case 8:
      monthString = "Aug ";
      break;
    case 9:
      monthString = "Sep ";
      break;
    case 10:
      monthString = "Oct ";
      break;
    case 11:
      monthString = "Nov ";
      break;
    case 12:
      monthString = "Dec ";
      break;
    default:
      monthString = "$month";
      break;
  }
  return monthString;
}
// Future<void> sendNotifications(GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey,String messageString) async {
//   if (GlobalClass.applicationToken == null) {
//     globalShowInSnackBar(scaffoldMessengerKey,'Unable to send FCM message, no token exists.');
//     return;
//   }
//   try {
//     GlobalClass.registerList.forEach((registerElement)  {
//       registerElement.clients.forEach((clientElement) async{
//         if(clientElement.notificationCount<3)
//         {
//           int a=clientElement.endDate.difference(DateTime.now()).inDays;
//           if((a>-3&&a<1)&&clientElement.due>=0)
//           {
//             await http.post(
//               Uri.parse('https://fcm.googleapis.com/fcm/send'),
//               headers: <String, String>{
//                 'Content-Type': 'application/json; charset=UTF-8',
//                 'Authorization':'key=${messageString}'
//               },
//               body: constructFCMPayload(GlobalClass.applicationToken,clientElement,registerElement.name),
//             );
//             clientElement.notificationCount++;
//             updateClient(clientElement, clientElement.id);
//           }
//         }
//       });
//     });
//   } catch (e) {
//     globalShowInSnackBar(scaffoldMessengerKey,e);
//   }
// }

addDueModule(ClientModel clientData, state) {
  state.setState(() {
    clientData.due = clientData.due + 1;
    if (clientData.due <= 1) {
      clientData.startDate = DateTime(clientData.startDate.year,
          clientData.startDate.month + 1, clientData.startDate.day);
    }
    if (clientData.due >= 1) {
      clientData.endDate = DateTime(clientData.endDate.year,
          clientData.endDate.month + 1, clientData.endDate.day);
    }
    updateClient(clientData, clientData.id);
  });
}

callModule(ClientModel clientData,
    GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey) async {
  if (clientData.mobileNo != null && clientData.mobileNo != "") {
    var url = 'tel:<${clientData.mobileNo}>';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      globalShowInSnackBar(
          scaffoldMessengerKey, 'Oops!! Something went wrong.');
    }
  }
}

whatsAppModule(ClientModel clientData,
    GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey) async {
  if (clientData.mobileNo != null && clientData.mobileNo != "") {
    var url =
        "https://wa.me/+91${clientData.mobileNo}?text=${clientData.name}, ${GlobalClass.userDetail.reminderMessage != null && GlobalClass.userDetail.reminderMessage != "" ? GlobalClass.userDetail.reminderMessage : "Your subscription has come to an end"
            ", please clear your dues for further continuation of services."}\npowered by Chronicle Business Solutions";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      globalShowInSnackBar(
          scaffoldMessengerKey, 'Oops!! Something went wrong.');
    }
  } else
    globalShowInSnackBar(scaffoldMessengerKey, "Please Enter Mobile No");
}

smsModule(ClientModel clientData,
    GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey) async {
  if (clientData.mobileNo != null && clientData.mobileNo != "") {
    // SmsSender sender = new SmsSender();
    String address = clientData.mobileNo;
    String message =
        "${clientData.name}, ${GlobalClass.userDetail.reminderMessage != null && GlobalClass.userDetail.reminderMessage != "" ? GlobalClass.userDetail.reminderMessage : "Your subscription has come to an end"
            ", please clear your dues for further continuation of services."}\npowered by Chronicle Business Solutions";
    if (address != null && address != "") {
      // sender.sendSms(new SmsMessage(address, message)).then((value) => globalShowInSnackBar(scaffoldMessengerKey,"Message has been sent to ${clientData.name}!!"));
      sendSMS(message: message, recipients: [address]).then((value) =>
          globalShowInSnackBar(scaffoldMessengerKey,
              "Message has been sent to ${clientData.name}!!"));
    }
  } else
    globalShowInSnackBar(scaffoldMessengerKey, "No Mobile no present!!");
}

Future<void> sendRegisterAppEmail(
    GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey,
    File pdfFile) async {
  String platformResponse;
  final MailOptions mailOptions = MailOptions(
    body:
        'Respected Sir, \nPlease register my account. My token is ${GlobalClass.user.uid}',
    subject: 'Register Chronicle ${GlobalClass.user.email}',
    recipients: ['chroniclebusinesssolutions@gmail.com'],
    isHTML: false,
    attachments: [
      pdfFile.path,
    ],
  );

  final MailerResponse response = await FlutterMailer.send(mailOptions);
  switch (response) {
    case MailerResponse.saved:

      /// ios only
      platformResponse = 'mail was saved to draft';
      break;
    case MailerResponse.sent:

      /// ios only
      platformResponse = 'mail was sent';
      break;
    case MailerResponse.cancelled:

      /// ios only
      platformResponse = 'mail was cancelled';
      break;
    case MailerResponse.android:
      platformResponse =
          'Registration Successful, Wait for the admin to grant access..';
      break;
    default:
      platformResponse = 'Something went wrong!!';
      break;
  }
  globalShowInSnackBar(scaffoldMessengerKey, platformResponse);
}

List<ClientModel> sortClientsModule(
    String sortType, List<ClientModel> listToBeSorted) {
  List<ClientModel> sortedList = [];
  if (sortType == "Dues First") {
    List<ClientModel> temp =
        listToBeSorted.where((element) => element.due > 0).toList();
    sortedList.addAll(temp);
    temp = listToBeSorted.where((element) => element.due <= 0).toList();
    sortedList.addAll(temp);
  } else if (sortType == "Last Months First") {
    List<ClientModel> temp =
        listToBeSorted.where((element) => element.due == 0).toList();
    sortedList.addAll(temp);
    temp = listToBeSorted.where((element) => element.due != 0).toList();
    sortedList.addAll(temp);
  } else if (sortType == "Registration Id Ascending") {
    var temp = listToBeSorted
        .where((element) =>
            element.registrationId == null || element.registrationId == "")
        .toList();
    listToBeSorted.removeWhere((element) =>
        element.registrationId == null || element.registrationId == "");
    listToBeSorted.sort((a, b) => a.registrationId
        .toLowerCase()
        .compareTo(b.registrationId.toLowerCase()));
    listToBeSorted.addAll(temp);
    sortedList = listToBeSorted;
  } else if (sortType == "Registration Id Descending") {
    var temp = listToBeSorted
        .where((element) =>
            element.registrationId == null || element.registrationId == "")
        .toList();
    listToBeSorted.removeWhere((element) =>
        element.registrationId == null || element.registrationId == "");
    listToBeSorted.sort((a, b) => b.registrationId
        .toLowerCase()
        .compareTo(a.registrationId.toLowerCase()));
    listToBeSorted.addAll(temp);
    sortedList = listToBeSorted;
  } else if (sortType == "Paid First") {
    List<ClientModel> temp =
        listToBeSorted.where((element) => element.due < 0).toList();
    sortedList.addAll(temp);
    temp = listToBeSorted.where((element) => element.due >= 0).toList();
    sortedList.addAll(temp);
  } else if (sortType == "A-Z") {
    listToBeSorted
        .sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    sortedList = listToBeSorted;
  } else if (sortType == "Z-A") {
    listToBeSorted
        .sort((a, b) => b.name.toLowerCase().compareTo(a.name.toLowerCase()));
    sortedList = listToBeSorted;
  } else if (sortType == "Start Date Ascending") {
    listToBeSorted.sort((a, b) =>
        a.startDate.toIso8601String().compareTo(b.startDate.toIso8601String()));
    sortedList = listToBeSorted;
  } else if (sortType == "Start Date Descending") {
    listToBeSorted.sort((a, b) =>
        b.startDate.toIso8601String().compareTo(a.startDate.toIso8601String()));
    sortedList = listToBeSorted;
  } else if (sortType == "End Date Ascending") {
    listToBeSorted.sort((a, b) =>
        a.endDate.toIso8601String().compareTo(b.endDate.toIso8601String()));
    sortedList = listToBeSorted;
  } else if (sortType == "End Date Descending") {
    listToBeSorted.sort((a, b) =>
        b.endDate.toIso8601String().compareTo(a.endDate.toIso8601String()));
    sortedList = listToBeSorted;
  }
  return sortedList;
}

String getFormattedDate(DateTime dateTime) {
  if (dateTime != null)
    return "${dateTime.day}${dateTime.month}${dateTime.year}";
  else
    return null;
}

String getLaymanDueValue(int due) {
  int temp = (due + (due < 0 ? -1 : 0)) * -1;
  return temp.toString();
}

Future<void> backupModule(
    GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey,
    Function(double) update) async {
  var status = await Permission.storage.status;
  if (!status.isGranted) {
    await Permission.storage.request();
  }
  final appDirectory = await getExternalStorageDirectory();
  Directory tempDir = await DownloadsPathProvider.downloadsDirectory;
  Excel excel = Excel.createExcel();
  Sheet sheetObject = excel['Sheet1'];
  List<String> dataList = [
    "RegistrationId",
    "Name",
    "FathersName",
    "Dob(DDMMYYYY)",
    "JoiningDate(DDMMYYYY)",
    "MobileNo",
    "Education",
    "Occupation",
    "Address",
    "Injuries",
    "Sex",
    "Caste",
    "Height",
    "Weight",
    "NoOfPayments",
    "StartDate(DDMMYYYY)"
  ];
  sheetObject.insertRowIterables(dataList, 0);
  int i = 1;
  String backupFolderName = "backup_${DateTime.now().toIso8601String()}";
  DataModel data = await getBackupData();
  double progress = 0;
  double iteration = 0.9 / data.registers.length;
  update(progress);
  await Future.forEach(data.registers, (RegisterModel registerElement) async {
    progress += iteration;
    update(progress);
    await Future.forEach(registerElement.clients,
        (ClientModel clientElement) async {
      List<String> dataList1 = [
        clientElement.registrationId,
        clientElement.name,
        clientElement.fathersName,
        getFormattedDate(clientElement.dob),
        getFormattedDate(clientElement.joiningDate),
        clientElement.mobileNo,
        clientElement.education,
        clientElement.occupation,
        clientElement.address,
        clientElement.injuries,
        clientElement.sex,
        clientElement.caste,
        clientElement.height != null ? clientElement.height.toString() : null,
        clientElement.weight != null ? clientElement.weight.toString() : null,
        getLaymanDueValue(clientElement.due),
        getFormattedDate(clientElement.startDate)
      ];
      sheetObject.insertRowIterables(dataList1, i++);
    });
    await Future.delayed(Duration(milliseconds: 100));

    File(
        "${appDirectory.path}/${backupFolderName}_temp/${registerElement.name + "_" + registerElement.id.key}.xlsx")
      ..createSync(recursive: true)
      ..writeAsBytesSync(excel.encode());
  });

  final dataDir = Directory("${appDirectory.path}/${backupFolderName}_temp/");
  try {
    final zipFile = File("${tempDir.path}/$backupFolderName.zip");
    ZipFile.createFromDirectory(
            sourceDir: dataDir, zipFile: zipFile, recurseSubDirs: true)
        .then((value) => File("${appDirectory.path}/${backupFolderName}_temp/")
            .delete(recursive: true));
  } catch (e) {
    globalShowInSnackBar(scaffoldMessengerKey, "An error has occurred");
  }
  update(1);
  await Future.delayed(Duration(milliseconds: 500));
  globalShowInSnackBar(scaffoldMessengerKey,
      "Backup $backupFolderName.zip has been created at Download/");
}

Future<void> uploadBackupModule(
    GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey) async {
  //Todo: First we need to clear old data
  //Todo: Then add new data
  //Todo: Also take an backup of current data
  //Todo: If there is an error, upload old backup data
  var status = await Permission.storage.status;
  if (!status.isGranted) {
    await Permission.storage.request();
  }
  final appDirectory = await getExternalStorageDirectory();
  FilePickerResult filePickerResult = await FilePicker.platform
      .pickFiles(type: FileType.custom, allowedExtensions: ['zip']);
  String filePath = filePickerResult.paths[0];
  if (filePath == '') {
    return;
  }
  final zipFile = File(filePath);
  final destinationDir = Directory(appDirectory.path + "/backupZipTemp/");
  try {
    ZipFile.extractToDirectory(
        zipFile: zipFile, destinationDir: destinationDir);
  } catch (e) {
    print(e);
  }

  await for (var entity
      in destinationDir.list(recursive: true, followLinks: false)) {
    File registerExcel = File(entity.path);
    String registerName =
        ((registerExcel.path.split('/').last).split('.').first)
            .split('_')
            .first;
    DatabaseReference registerId = addRegister(registerName);
    RegisterIndexModel registerIndex =
        RegisterIndexModel(uid: registerId.key, name: registerName);
    registerIndex.setId(addRegisterIndex(registerIndex));
    GlobalClass.registerList.add(registerIndex);

    var bytes = File(entity.path).readAsBytesSync();
    var excel = Excel.decodeBytes(bytes);
    int i = 0;
    List<dynamic> keys = [];
    List<Map<String, dynamic>> json = [];
    for (var table in excel.tables.keys) {
      for (List<Data> row in excel.tables[table].rows) {
        if (i == 0) {
          keys = row;
          i++;
        } else {
          Map<String, dynamic> temp = Map<String, dynamic>();
          int j = 0;
          String tk = '';
          for (Data key in keys) {
            tk = key.value;
            temp[tk] = row[j] != null ? row[j].value.toString() : null;
            j++;
          }
          json.add(temp);
        }
      }
    }
    json.forEach((jsonItem) {
      ExcelClientModel excelClientModel = ExcelClientModel.fromJson(jsonItem);
      ClientModel temp = excelClientModel.toClientModel();
      temp.setId(addClientInRegister(temp, registerIndex.uid));
    });
  }
  await File(appDirectory.path + "/backupZipTemp/").delete(recursive: true);
  globalShowInSnackBar(scaffoldMessengerKey, "Backup loaded");
}

List<CourseIndexModel> sortCoursesModule(
    String sortType, List<CourseIndexModel> listToBeSorted) {
  List<CourseIndexModel> sortedList = [];
  if (sortType == "NoOfUsers") {
    listToBeSorted.sort((a, b) => b.totalUsers - a.totalUsers);
    sortedList = listToBeSorted;
  } else if (sortType == "A-Z") {
    listToBeSorted
        .sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
    sortedList = listToBeSorted;
  } else if (sortType == "Z-A") {
    listToBeSorted
        .sort((a, b) => b.title.toLowerCase().compareTo(a.title.toLowerCase()));
    sortedList = listToBeSorted;
  }
  return sortedList;
}

deleteModule(ClientModel clientData, BuildContext context, state) async {
  showDialog(
      context: context,
      builder: (_) => new AlertDialog(
            title: Text("Confirm Delete"),
            content: Text(
                "Are you sure to delete ${clientData.name}?\n The change is irreversible."),
            actions: [
              ActionChip(
                  label: Text("Yes"),
                  onPressed: () {
                    state.setState(() {
                      deleteDatabaseNode(clientData.id);
                      Navigator.of(_).pop();
                      Navigator.of(context).pop(true);
                    });
                  }),
              ActionChip(
                  label: Text("No"),
                  onPressed: () {
                    state.setState(() {
                      Navigator.of(_).pop();
                    });
                  })
            ],
          ));
}

deleteCourseModule(
    CourseIndexModel courseIndex, BuildContext context, state) async {
  showDialog(
      context: context,
      builder: (_) => new AlertDialog(
            title: Text("Confirm Delete"),
            content: Text(
                "Are you sure to delete ${courseIndex.title}?\n The change is irreversible."),
            actions: [
              ActionChip(
                  label: Text("Yes"),
                  onPressed: () {
                    state.setState(() {
                      deleteCourseAsync(courseIndex);
                      Navigator.of(_).pop();
                      Navigator.of(context).pop(true);
                    });
                  }),
              ActionChip(
                  label: Text("No"),
                  onPressed: () {
                    state.setState(() {
                      Navigator.of(_).pop();
                    });
                  })
            ],
          ));
}

deleteCourseAsync(CourseIndexModel courseIndexModel) async {
  CourseModel course = await getCourse(courseIndexModel);
  course.delete();
  deleteDatabaseNode(courseIndexModel.id);
}

generateInvoice(
    ClientModel clientData,
    int noOfMonths,
    double unitPrice,
    String title,
    String invoiceNumber,
    String remarks,
    String modeOfPayment,
    DateTime fromDate,
    DateTime toDate) async {
  String downloadDir = await localPath;

  final date = DateTime.now();
  final invoice = Invoice(
    title: title,
    modeOfPayment: modeOfPayment,
    supplier: Supplier(
      name: GlobalClass.userDetail.organizationName,
      address: GlobalClass.userDetail.organizationAddress,
      email: GlobalClass.userDetail.email,
    ),
    customer: clientData,
    info: InvoiceInfo(
        date: date,
        remarks: remarks,
        number: invoiceNumber,
        termsAndConditions: GlobalClass.userDetail.termsAndConditions),
    items: [
      InvoiceItem(
          description:
              "From ${Utils.formatDate(fromDate)} to ${Utils.formatDate(toDate)}",
          quantity: noOfMonths,
          gst: 0.0,
          unitPrice: unitPrice),
    ],
  );

  final pdfFile = await PdfInvoiceApi.generate(invoice);
  String registrationIdTemp =
      (clientData.registrationId != null && clientData.registrationId != ""
          ? clientData.registrationId
          : clientData.id.key);
  // PdfApi.openFile(pdfFile);
  File(
      "$downloadDir/Invoices/${registrationIdTemp}_${clientData.name}/$invoiceNumber.pdf")
    ..createSync(recursive: true)
    ..writeAsBytesSync(pdfFile.readAsBytesSync());
  Share.shareFiles([
    "$downloadDir/Invoices/${registrationIdTemp}_${clientData.name}/$invoiceNumber.pdf"
  ], text: title);
}

addPaymentModule(
  ClientModel clientData,
  BuildContext context,
  GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey,
  state,
) {
  showDialog(
      context: context,
      builder: (_) => new AddQuantityDialog(
            scaffoldMessengerKey: scaffoldMessengerKey,
          )).then((value) {
    if (value != null) {
      PaymentDetailsModel paymentDetails = value;
      int intVal = paymentDetails.noOfPayments;
      DateTime paymentFromDate;
      DateTime paymentToDate;
      state.setState(() {
        if (clientData.due > intVal) {
          paymentFromDate = clientData.startDate;
          clientData.startDate = DateTime(clientData.startDate.year,
              clientData.startDate.month + intVal, clientData.startDate.day);
          paymentToDate = clientData.startDate;
        } else {
          if (clientData.due < 0) {
            paymentFromDate = clientData.endDate;
            clientData.endDate = DateTime(clientData.endDate.year,
                clientData.endDate.month + intVal, clientData.endDate.day);
            paymentToDate = clientData.endDate;
          } else {
            DateTime nowTemp = DateTime.now();
            DateTime today = DateTime(nowTemp.year, nowTemp.month, nowTemp.day);
            if (clientData.due == 0 &&
                DateTime(clientData.endDate.year, clientData.endDate.month,
                        clientData.endDate.day)
                    .isBefore(today)) {
              clientData.startDate = DateTime(clientData.endDate.year,
                  clientData.endDate.month, clientData.endDate.day);
              clientData.endDate = DateTime(
                  clientData.endDate.year,
                  clientData.endDate.month + (intVal - clientData.due),
                  clientData.endDate.day);
              intVal = intVal - 1;
              paymentFromDate = clientData.startDate;
              paymentToDate = clientData.endDate;
            } else {
              paymentFromDate = clientData.startDate;
              clientData.startDate = DateTime(clientData.endDate.year,
                  clientData.endDate.month - 1, clientData.endDate.day);
              clientData.endDate = DateTime(
                  clientData.endDate.year,
                  clientData.endDate.month + (intVal - clientData.due),
                  clientData.endDate.day);
              paymentToDate = clientData.endDate;
            }
          }
        }
        clientData.due = clientData.due - intVal;
        if (clientData.lastInvoiceNo == null) clientData.lastInvoiceNo = 0;
        clientData.lastInvoiceNo++;
        updateClient(clientData, clientData.id);
      });
      String invoiceNumber =
          (clientData.registrationId != null && clientData.registrationId != ""
                  ? clientData.registrationId
                  : clientData.id.key) +
              "_" +
              DateFormat('dd_MM_yyyy').format(DateTime.now()) +
              "_" +
              clientData.lastInvoiceNo.toString();
      generateInvoice(
          clientData,
          paymentDetails.noOfPayments,
          paymentDetails.unitPrice,
          '${clientData.name}_$invoiceNumber',
          invoiceNumber,
          paymentDetails.remarks,
          paymentDetails.paymentType,
          paymentFromDate,
          paymentToDate);
    }
  });
}

Future<String> get localPath async {
  var status = await Permission.storage.status;
  if (!status.isGranted) {
    await Permission.storage.request();
  }
  Directory directory = await DownloadsPathProvider.downloadsDirectory;
  return directory.path;
}

String getFormattedMobileNo(String value) {
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

copyClientsModule(
    List<ClientModel> selectedList, RegisterIndexModel toRegister) async {
  selectedList.forEach((client) {
    ClientModel newClient = client.copyClient();
    newClient.setId(addClientInRegister(newClient, toRegister.uid));
  });
}

moveClientsModule(
    List<ClientModel> selectedList, RegisterIndexModel toRegister) async {
  selectedList.forEach((client) {
    ClientModel newClient = client.copyClient();
    newClient.setId(addClientInRegister(newClient, toRegister.uid));
  });
  deleteClientsModule(selectedList);
}

deleteClientsModule(List<ClientModel> selectedList) {
  selectedList.forEach((element) {
    deleteDatabaseNode(element.id);
  });
}

shareModule(VideoIndexModel video,
    GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey) {}

String classifySize(int inBytes) {
  if (inBytes < 1000)
    return inBytes.toString() + " B";
  else if (inBytes < 1000000)
    return (inBytes / 1000).toStringAsFixed(2) + " KB";
  else if (inBytes < 1000000000)
    return (inBytes / 1000000).toStringAsFixed(2) + " MB";
  else if (inBytes < 1000000000000)
    return (inBytes / 1000000000).toStringAsFixed(2) + " GB";
  else
    return (inBytes / 1000000000000).toString() + " TB";
}

void changesSavedModule(BuildContext context,
    GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey) {
  FocusScopeNode currentFocus = FocusScope.of(context);
  currentFocus.unfocus();
  globalShowInSnackBar(scaffoldMessengerKey, "Changes have been saved");
}

String generateMasterFilter(ClientModel client) {
  return (client.name +
          ((client.mobileNo != null) ? client.mobileNo : "") +
          ((client.registrationId != null)
              ? client.registrationId
              : (client.id != null)
                  ? client.id.key
                  : ""))
      .replaceAll(new RegExp(r'\W+'), "")
      .toLowerCase();
}
