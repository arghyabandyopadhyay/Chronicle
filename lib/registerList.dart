import 'package:Chronicle/Models/registerModel.dart';
import 'package:Chronicle/Pages/clientPage.dart';
import 'package:Chronicle/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class RegisterList extends StatefulWidget {
  final List<RegisterModel> listItems;
  final User user;

  RegisterList(this.listItems, this.user);

  @override
  _RegisterListState createState() => _RegisterListState();
}

class _RegisterListState extends State<RegisterList> {

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: this.widget.listItems.length,
      itemBuilder: (context, index) {
        var register = this.widget.listItems[index];
        return Slidable(
          actionPane: SlidableDrawerActionPane(),
          actionExtentRatio: 0.25,
          child:ListTile(
            onTap: (){
              Navigator.of(context).push(CupertinoPageRoute(builder: (context)=>ClientPage(widget.user,register )));
            },
            title: Text(register.name),
          ),
          secondaryActions: <Widget>[
            IconSlideAction(
              caption: 'Delete',
              icon: Icons.add,
              color: Colors.red,
              onTap: () async {
                setState(() {
                });
              },
              closeOnTap: false,
            ),
          ],
        );
      },
    );
  }
}
