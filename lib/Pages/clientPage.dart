import 'package:Chronicle/Models/registerModel.dart';
import 'package:Chronicle/Widgets/registerOptionBottomSheet.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Chronicle/database.dart';
import '../Models/clientModel.dart';
import '../clientList.dart';
import '../registerNewClientWidget.dart';

class ClientPage extends StatefulWidget {
  final User user;
  final RegisterModel register;

  ClientPage(this.user,this.register);

  @override
  _ClientPageState createState() => _ClientPageState();
}

class _ClientPageState extends State<ClientPage> {
  List<ClientModel> clients = [];

  void newClientModel(ClientModel client) {
    client.setId(registerUser(client,widget.user,widget.register.id.key));
    this.setState(() {
      clients.add(client);
    });
  }
  void updateClientModel() {
    this.setState(() {
    });
  }

  void getClientModels() {
    getAllClients(widget.user,widget.register.id.key.replaceAll("registers", "")).then((clients) => {
      this.setState(() {
        this.clients = clients;
      })
    });
  }

  @override
  void initState() {
    super.initState();
    getClientModels();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: GestureDetector(child: Container(child: Text(widget.register.name),),
        onTap: (){showModalBottomSheet(context: context, builder: (_)=>RegisterOptionBottomSheet(list: [],));},),
        actions: [
          IconButton(icon: Icon(Icons.notifications_active,), onPressed: null),
        ],),
      body: Column(children: <Widget>[
        Expanded(child: ClientList(this.clients, widget.user)),
      ]),
      floatingActionButton: RegisterNewClientWidget(this.newClientModel),
    );
  }
}
