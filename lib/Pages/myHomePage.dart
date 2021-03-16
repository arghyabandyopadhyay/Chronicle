import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Chronicle/database.dart';
import '../Models/clientModel.dart';
import '../clientList.dart';
import '../registerNewClientWidget.dart';
import 'addRegisterPage.dart';

class MyHomePage extends StatefulWidget {
  final User user;

  MyHomePage(this.user);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<ClientModel> clients = [];

  void newClientModel(ClientModel client) {
    client.setId(registerUser(client,widget.user));
    this.setState(() {
      clients.add(client);
    });
  }
  void updateClientModel() {
    this.setState(() {
    });
  }

  void updateClientModels() {
    getAllClients(widget.user).then((clients) => {
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
        appBar: AppBar(title: Text("Client List"),
        actions: [
          IconButton(icon: Icon(Icons.notifications_active,color: Colors.black,), onPressed: null),
          IconButton(icon: Icon(Icons.addchart_outlined,color: Colors.black,), onPressed: (){
            Navigator.of(context).push(new CupertinoPageRoute(builder: (context)=>AddRegisterPage()));
          })
        ],),
        body: Column(children: <Widget>[
          Expanded(child: ClientList(this.clients, widget.user)),
        ]),
      floatingActionButton: RegisterNewClientWidget(this.newClientModel),
    );
  }
}
