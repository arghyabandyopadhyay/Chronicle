import 'package:firebase_database/firebase_database.dart';

import 'clientModel.dart';

class RegisterModel {
  final List<ClientModel>? clients;
  final String? name;
  DatabaseReference? id;

  RegisterModel({this.clients, this.name});

  factory RegisterModel.fromJson(Map<String, dynamic> json1) {
    return RegisterModel(
        clients: json1['Clients'],
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