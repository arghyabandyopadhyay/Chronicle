import 'dart:convert';

import 'package:chronicle/Modules/database.dart';
import 'package:chronicle/Pages/globalClass.dart';
import 'package:firebase_database/firebase_database.dart';

import 'clientModel.dart';

class RegisterModel {
  final List<ClientModel> clients;
  String name;
  DatabaseReference id;

  RegisterModel({this.clients, this.name});

  factory RegisterModel.fromJson(Map<String, dynamic> json1,String idKey) {
    List<ClientModel> getClients(Map<String, dynamic> jsonList){
      List<ClientModel> clientsList = [];
      if (jsonList!= null) {
        jsonList.keys.forEach((key) {
          ClientModel clientModel = ClientModel.fromJson(jsonDecode(jsonEncode(jsonList[key])));
          clientModel.setId(databaseReference.child('${GlobalClass.user.uid}/registers/$idKey/client/' + key));
          clientsList.add(clientModel);
        });
      }
      return clientsList;
    }

    return RegisterModel(
        clients: getClients(jsonDecode(jsonEncode(json1['client']))),
        name: json1['Name'],
    );
  }

  void setId(DatabaseReference id)
  {
    this.id=id;
  }

  Map<String,dynamic> toJson() =>
      {
        "Name":this.name,
        "Clients":this.clients,
      };
}