import 'package:Chronicle/Widgets/addQuantityDialog.dart';
import 'package:Chronicle/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:url_launcher/url_launcher.dart';
import 'Models/clientModel.dart';
import 'Pages/addPaymentPage.dart';
import 'Widgets/AddPaymentDialog.dart';

class ClientList extends StatefulWidget {
  final List<ClientModel> listItems;
  final User user;

  ClientList(this.listItems, this.user);

  @override
  _ClientListState createState() => _ClientListState();
}

class _ClientListState extends State<ClientList> {

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: this.widget.listItems.length,
      itemBuilder: (context, index) {
        var client = this.widget.listItems[index];
        return Slidable(
            actionPane: SlidableDrawerActionPane(),
        actionExtentRatio: 0.25,
            child:ListTile(
              onTap: (){
              },
          title: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(client.name),
                Text(client.fathersName)
              ]
          ),
          subtitle: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(client.fitnessGoal+" | Injuries: "+client.injuries),
                Text(client.height.toString()+" cm | "+client.weight.toString()+" kg")
              ]
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text((client.startDate!=null?client.startDate.day.toString()+"-"+client.startDate.month.toString()+"-"+client.startDate.year.toString()+" to ":"")+((client.endDate!=null)?client.endDate.day.toString()+"-"+client.endDate.month.toString()+"-"+client.endDate.year.toString():"")),
              Text(client.mobileNo),
              Text("Due: "+client.due.toString(),style: TextStyle(color: client.due!=null&&client.due==0?Colors.green:Colors.red,),)
            ]
          ),
        ),
          secondaryActions: <Widget>[
            IconSlideAction(
              caption: 'Add Due',
              icon: Icons.add,
              color: Colors.red,
              onTap: () async {
                setState(() {
                  client.due=client.due+1;
                  updateClient(client, client.id);
                });
              },
              closeOnTap: false,
            ),
            IconSlideAction(
              caption: 'Add Payment',
              icon: Icons.add,
              color: Colors.green,
              onTap: () {

                  showDialog(context: context, builder: (_) =>new AddQuantityDialog()
                  ).then((value) {
                    setState(() {client.due=client.due-value>=0?client.due-value:0;
                    updateClient(client, client.id);});
                  });


              },
              closeOnTap: false,
            ),
          ],
          actions: <Widget>[
            IconSlideAction(
              caption: 'Call',
              icon: Icons.call,
              onTap: () async {
                if(client.mobileNo!=null&&client.mobileNo!="")
                {
                  var url = 'tel:<${client.mobileNo}>';
                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                }
              },
            ),
            IconSlideAction(
              caption: 'Send Remainder',
              icon: Icons.send,
              onTap: () async {
                if(client.mobileNo!=null&&client.mobileNo!="")
                {
                  var url = "https://wa.me/+91${client.mobileNo}?text=${client.name}, Your subscription has come to an end"
                      ", please clear your dues for further continuation of services.";
                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }
}
