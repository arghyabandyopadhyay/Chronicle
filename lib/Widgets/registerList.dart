import 'package:chronicle/Models/registerModel.dart';
import 'package:chronicle/Pages/clientPage.dart';
import 'package:chronicle/Modules/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class RegisterList extends StatefulWidget {
  final List<RegisterModel> listItems;

  RegisterList(this.listItems);

  @override
  _RegisterListState createState() => _RegisterListState();
}

class _RegisterListState extends State<RegisterList> {

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: this.widget.listItems.length,
      itemBuilder: (context, index) {
        return Slidable(
          actionPane: SlidableDrawerActionPane(),
          actionExtentRatio: 0.25,
          child:ListTile(
            onTap: (){
              Navigator.of(context).push(CupertinoPageRoute(builder: (context)=>ClientPage(this.widget.listItems[index] )));
            },
            title: Text(this.widget.listItems[index].name),
          ),
          secondaryActions: <Widget>[
            IconSlideAction(
              caption: 'Delete',
              icon: Icons.delete,
              color: Colors.red,
              onTap: () async {
                showDialog(context: context, builder: (_)=>new AlertDialog(
                  title: Text("Confirm Delete"),
                  content: Text("Are you sure?"),
                  actions: [
                    ActionChip(label: Text("Yes"), onPressed: (){
                      setState(() {
                        deleteDatabaseNode(this.widget.listItems[index].id);
                        this.widget.listItems.removeAt(index);
                        Navigator.of(context).pop();
                      });
                    }),
                    ActionChip(label: Text("No"), onPressed: (){
                      setState(() {
                        Navigator.of(context).pop();
                      });
                    })
                  ],
                ));
              },
            ),
          ],
        );
      },
    );
  }
}
