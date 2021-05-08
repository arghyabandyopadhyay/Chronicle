import 'package:chronicle/Models/chronicleUserModel.dart';
import 'package:chronicle/Modules/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChronicleUsersList extends StatefulWidget {
  final List<ChronicleUserModel> listItems;
  ChronicleUsersList(this.listItems);
  @override
  _ChronicleUsersListState createState() => _ChronicleUsersListState();
}

class _ChronicleUsersListState extends State<ChronicleUsersList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: this.widget.listItems.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(this.widget.listItems[index].displayName,style: TextStyle(fontWeight: FontWeight.w900),),
          subtitle: Text(this.widget.listItems[index].email,style: TextStyle(fontWeight: FontWeight.w300),),
          trailing: IconButton(icon: this.widget.listItems[index].canAccess==1?Icon(Icons.clear,color: Colors.red,):Icon(Icons.done,color: Colors.green,),onPressed: (){
            setState(() {
              this.widget.listItems[index].canAccess=(this.widget.listItems[index].canAccess+1)%2;
              updateChronicleUserDetails(this.widget.listItems[index], this.widget.listItems[index].id);
            });
          },)
        );
      },
    );
  }
}