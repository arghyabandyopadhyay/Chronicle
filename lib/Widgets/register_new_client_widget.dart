import 'package:chronicle/Pages/TutorPages/registerClientPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Models/client_model.dart';

class RegisterNewClientWidget extends StatefulWidget {
  final Function(ClientModel) callback;
  final BuildContext mainScreenContext;

  RegisterNewClientWidget(this.callback, this.mainScreenContext);

  @override
  _RegisterNewClientWidgetState createState() =>
      _RegisterNewClientWidgetState();
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
      heroTag: "registerClients2",
      child: Icon(Icons.person_add),
      tooltip: "Register Clients",
      onPressed: () {
        Navigator.of(widget.mainScreenContext).push(new CupertinoPageRoute(
            builder: (context) => RegisterClientPage(callback: this.click)));
      },
    );
  }
}
