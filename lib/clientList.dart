import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'Models/clientModel.dart';

class ClientList extends StatefulWidget {
  final List<ClientModel> listItems;
  final User user;

  ClientList(this.listItems, this.user);

  @override
  _ClientListState createState() => _ClientListState();
}

class _ClientListState extends State<ClientList> {
  void like(Function callBack) {
    this.setState(() {
      callBack();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: this.widget.listItems.length,
      itemBuilder: (context, index) {
        var client = this.widget.listItems[index];
        return Card(
            child: Row(children: <Widget>[
              Expanded(
                  child: ListTile(
                    title: Text(client.name),
                    subtitle: Text(client.fathersName),
                  )),
              Row(
                children: <Widget>[
                  Container(
                    child: Text(client.startDate.toIso8601String(),
                        style: TextStyle(fontSize: 20)),
                    padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                  ),
                  // IconButton(
                  //     icon: Icon(Icons.thumb_up),
                  //     onPressed: () => this.like(() => client.likeClient(widget.user)),
                  //     color: client.usersLiked.contains(widget.user.uid)
                  //         ? Colors.green
                  //         : Colors.black)
                ],
              )
            ]));
      },
    );
  }
}
