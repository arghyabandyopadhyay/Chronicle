import 'package:chronicle/Modules/universalModule.dart';
import 'package:chronicle/Pages/clientInformationPage.dart';
import 'package:chronicle/Widgets/addQuantityDialog.dart';
import 'package:chronicle/Modules/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Models/clientModel.dart';
import 'AddPaymentDialog.dart';

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
        return Slidable(
            actionPane: SlidableDrawerActionPane(),
        actionExtentRatio: 0.25,
            child:ListTile(
              onTap: () async {
                Navigator.of(context).push(CupertinoPageRoute(builder: (context)=>ClientInformationPage(user:this.widget.listItems[index])));
              },
          title: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(this.widget.listItems[index].name!,style: TextStyle(fontWeight: FontWeight.w900),),
                Text((this.widget.listItems[index].registrationId!=null&&this.widget.listItems[index].registrationId!=""?this.widget.listItems[index].registrationId:this.widget.listItems[index].id!.key)!,style: TextStyle(fontWeight: FontWeight.w300),)
              ]
          ),
          subtitle: Text("\u2709: "+this.widget.listItems[index].address.toString(),style: TextStyle(fontWeight: FontWeight.bold),),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text((this.widget.listItems[index].startDate!=null?this.widget.listItems[index].startDate!.day.toString()+"-"+this.widget.listItems[index].startDate!.month.toString()+"-"+this.widget.listItems[index].startDate!.year.toString()+" to ":"")+((this.widget.listItems[index].endDate!=null)?this.widget.listItems[index].endDate!.day.toString()+"-"+this.widget.listItems[index].endDate!.month.toString()+"-"+this.widget.listItems[index].endDate!.year.toString():""),style: TextStyle(fontWeight: FontWeight.w900),),
              Text("\u2706: "+this.widget.listItems[index].mobileNo!),
              Text("${this.widget.listItems[index].due!=null&&this.widget.listItems[index].due!<0?"Paid":"Due"}: "+this.widget.listItems[index].due!.abs().toString(),style: TextStyle(color: this.widget.listItems[index].due!=null&&this.widget.listItems[index].due==0?null:this.widget.listItems[index].due!>0?Colors.red:Colors.green,fontWeight: FontWeight.bold),)
            ]
          ),
        ),
          secondaryActions: <Widget>[
            IconSlideAction(
              caption: this.widget.listItems[index].due!>-1?'Add Due':'Reduce Payment',
              icon: this.widget.listItems[index].due!>-1?Icons.more_time:Icons.remove_circle,
              color: Colors.red,
              onTap: () async {
                setState(() {
                  this.widget.listItems[index].due=this.widget.listItems[index].due!+1;
                  if(this.widget.listItems[index].due!<=1){
                    this.widget.listItems[index].startDate=this.widget.listItems[index].startDate!.add(Duration(days: getDuration(this.widget.listItems[index].startDate!.month,this.widget.listItems[index].startDate!.year,1)));
                  }
                  if(this.widget.listItems[index].due!>=1)
                    {
                      this.widget.listItems[index].endDate=this.widget.listItems[index].endDate!.add(Duration(days: getDuration(this.widget.listItems[index].startDate!.month,this.widget.listItems[index].startDate!.year,1)));
                    }
                  updateClient(this.widget.listItems[index], this.widget.listItems[index].id!);
                });
              },
              closeOnTap: false,
            ),
            IconSlideAction(
              caption: 'Add Payment',
              icon: Icons.payment,
              color: Colors.green,
              onTap: () {
                  showDialog(context: context, builder: (_) =>new AddQuantityDialog()
                  ).then((value) {
                    int intVal=int.parse(value.toString());
                    setState(() {
                      this.widget.listItems[index].due=this.widget.listItems[index].due!-intVal;
                      if(this.widget.listItems[index].due!>0){
                        this.widget.listItems[index].startDate=this.widget.listItems[index].startDate!.add(Duration(days: getDuration(this.widget.listItems[index].startDate!.month,this.widget.listItems[index].startDate!.year,intVal)));
                      }
                      else if(this.widget.listItems[index].due!<0)
                      {
                        this.widget.listItems[index].endDate=this.widget.listItems[index].endDate!.add(Duration(days: getDuration(this.widget.listItems[index].startDate!.month,this.widget.listItems[index].startDate!.year,intVal)));
                      }
                      updateClient(this.widget.listItems[index], this.widget.listItems[index].id!);
                    });
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
                if(this.widget.listItems[index].mobileNo!=null&&this.widget.listItems[index].mobileNo!="")
                {
                  var url = 'tel:<${this.widget.listItems[index].mobileNo}>';
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
                if(this.widget.listItems[index].mobileNo!=null&&this.widget.listItems[index].mobileNo!="")
                {
                  var url = "https://wa.me/+91${this.widget.listItems[index].mobileNo}?text=${this.widget.listItems[index].name}, Your subscription has come to an end"
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
