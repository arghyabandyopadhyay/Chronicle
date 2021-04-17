import 'package:chronicle/Models/userModel.dart';
import 'package:chronicle/Modules/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UsersList extends StatefulWidget {
  final List<UserModel> listItems;

  UsersList(this.listItems);

  @override
  _UsersListState createState() => _UsersListState();
}

class _UsersListState extends State<UsersList> {

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
              updateUserDetails(this.widget.listItems[index], this.widget.listItems[index].id);
            });
          },)
        );
      },
    );
  }
}
