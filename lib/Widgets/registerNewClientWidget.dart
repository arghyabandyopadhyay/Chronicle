import 'package:chronicle/Pages/registerClientPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Models/clientModel.dart';
import '../customColors.dart';

class RegisterNewClientWidget extends StatefulWidget {
  final Function(ClientModel) callback;

  RegisterNewClientWidget(this.callback);

  @override
  _RegisterNewClientWidgetState createState() => _RegisterNewClientWidgetState();
}

class _RegisterNewClientWidgetState extends State<RegisterNewClientWidget> {
  final controller = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  void click(ClientModel client) {
    widget.callback(client);
    FocusScope.of(context).unfocus();
    controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.person_add),
      splashColor: Colors.blue,
      tooltip: "Register Clients",
      onPressed: (){
        Navigator.of(context).push(new CupertinoPageRoute(builder: (context)=>RegisterClientPage(callback:this.click)));
      },
    );
  }
}
