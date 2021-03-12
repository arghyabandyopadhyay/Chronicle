import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:Chronicle/database.dart';
import 'Models/clientModel.dart';
import 'clientList.dart';
import 'textInputWidget.dart';

class MyHomePage extends StatefulWidget {
  final User user;

  MyHomePage(this.user);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<ClientModel> clients = [];

  void newClientModel(String text) {
    var client = new ClientModel(name: "widget.user.displayName", startDate: DateTime.now(), endDate: DateTime.now().add(Duration(days: 30)),dob: DateTime.now(),due: 1,fathersName: text,address: text, education: text, fitnessGoal: text,weight: 100,height: 183);
    client.setId(registerUser(client));
    this.setState(() {
      clients.add(client);
    });
  }

  void updateClientModels() {
    getAllClients().then((clients) => {
          this.setState(() {
            this.clients = clients;
          })
        });
  }

  @override
  void initState() {
    super.initState();
    updateClientModels();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Hello World!')),
        body: Column(children: <Widget>[
          Expanded(child: ClientList(this.clients, widget.user)),
          TextInputWidget(this.newClientModel)
        ]));
  }
}
