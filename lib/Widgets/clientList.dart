import 'package:chronicle/Modules/universalModule.dart';
import 'package:chronicle/Pages/clientInformationPage.dart';
import 'package:chronicle/Pages/globalClass.dart';
import 'package:chronicle/Widgets/addQuantityDialog.dart';
import 'package:chronicle/Modules/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Models/clientModel.dart';

class ClientList extends StatefulWidget {
  final List<ClientModel> listItems;
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey;

  ClientList(this.listItems,this.scaffoldMessengerKey);

  @override
  _ClientListState createState() => _ClientListState();
}

class _ClientListState extends State<ClientList> {

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.only(bottom: 100),
      itemCount: this.widget.listItems.length,
      itemBuilder: (context, index) {
        return Slidable(
            actionPane: SlidableDrawerActionPane(),
        actionExtentRatio: 0.25,
            child:ListTile(
              onLongPress: (){
                showDialog(context: context, builder: (_)=>new AlertDialog(
                  title: Text("Confirm Delete"),
                  content: Text("Are you sure to delete ${this.widget.listItems[index].name}?"),
                  actions: [
                    ActionChip(label: Text("Yes"), onPressed: (){
                      setState(() {
                        deleteDatabaseNode(this.widget.listItems[index].id);
                        this.widget.listItems.removeAt(index);
                        Navigator.of(_).pop();
                      });
                    }),
                    ActionChip(label: Text("No"), onPressed: (){
                      setState(() {
                        Navigator.of(_).pop();
                      });
                    })
                  ],
                ));
              },
              onTap: () async {
                Navigator.of(context).push(CupertinoPageRoute(builder: (context)=>ClientInformationPage(client:this.widget.listItems[index])));
              },
          title: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(this.widget.listItems[index].name,style: TextStyle(fontWeight: FontWeight.w900),),
                Text((this.widget.listItems[index].registrationId!=null&&this.widget.listItems[index].registrationId!=""?this.widget.listItems[index].registrationId:this.widget.listItems[index].id.key),style: TextStyle(fontWeight: FontWeight.w300),)
              ]
          ),
          subtitle: Text("\u2709: "+this.widget.listItems[index].address.toString(),style: TextStyle(fontWeight: FontWeight.bold),),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text((this.widget.listItems[index].startDate!=null?this.widget.listItems[index].startDate.day.toString()+"-"+this.widget.listItems[index].startDate.month.toString()+"-"+this.widget.listItems[index].startDate.year.toString()+" to ":"")+((this.widget.listItems[index].endDate!=null)?this.widget.listItems[index].endDate.day.toString()+"-"+this.widget.listItems[index].endDate.month.toString()+"-"+this.widget.listItems[index].endDate.year.toString():""),style: TextStyle(fontWeight: FontWeight.w900),),
              Text("\u2706: "+(this.widget.listItems[index].mobileNo!=null?this.widget.listItems[index].mobileNo:"N/A")),
              Text(this.widget.listItems[index].due==0?"Last Month":("${this.widget.listItems[index].due<0?"Paid":"Due"}: "+(this.widget.listItems[index].due.abs()+(this.widget.listItems[index].due<0?1:0)).toString()),style: TextStyle(color: this.widget.listItems[index].due<=0?this.widget.listItems[index].due==0?Colors.orangeAccent:Colors.green:Colors.red,fontWeight: FontWeight.bold),)
            ]
          ),
        ),
          secondaryActions: <Widget>[
            if(this.widget.listItems[index].due>-1)IconSlideAction(
              caption: 'Add Due',
              icon: Icons.more_time,
              color: Colors.red,
              onTap: () async {
                setState(() {
                  this.widget.listItems[index].due=this.widget.listItems[index].due+1;
                  if(this.widget.listItems[index].due<=1){
                    this.widget.listItems[index].startDate=DateTime(this.widget.listItems[index].startDate.year,this.widget.listItems[index].startDate.month+1,this.widget.listItems[index].startDate.day);
                  }
                  if(this.widget.listItems[index].due>=1)
                  {
                    this.widget.listItems[index].endDate=DateTime(this.widget.listItems[index].endDate.year,this.widget.listItems[index].endDate.month+1,this.widget.listItems[index].endDate.day);
                  }
                  updateClient(this.widget.listItems[index], this.widget.listItems[index].id);
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
                    try
                      {
                        int intVal=int.parse(value.toString());
                        setState(() {
                          if(this.widget.listItems[index].due>intVal) {
                            this.widget.listItems[index].startDate=DateTime(this.widget.listItems[index].startDate.year,this.widget.listItems[index].startDate.month+intVal,this.widget.listItems[index].startDate.day);
                          }
                          else{
                            if(this.widget.listItems[index].due<0){
                              this.widget.listItems[index].endDate=DateTime(this.widget.listItems[index].endDate.year,this.widget.listItems[index].endDate.month+intVal,this.widget.listItems[index].endDate.day);
                            }
                            else{
                              this.widget.listItems[index].startDate=DateTime(this.widget.listItems[index].endDate.year,this.widget.listItems[index].endDate.month-1,this.widget.listItems[index].endDate.day);
                              this.widget.listItems[index].endDate=DateTime(this.widget.listItems[index].endDate.year,this.widget.listItems[index].endDate.month+(intVal-this.widget.listItems[index].due),this.widget.listItems[index].endDate.day);
                            }
                          }
                          this.widget.listItems[index].due=this.widget.listItems[index].due-intVal;

                          // if(this.widget.listItems[index].due>0){
                          //   this.widget.listItems[index].startDate=DateTime(this.widget.listItems[index].startDate.year,this.widget.listItems[index].startDate.month+intVal,this.widget.listItems[index].startDate.day);
                          // }
                          // else if(this.widget.listItems[index].due<0)
                          // {
                          //   this.widget.listItems[index].endDate=DateTime(this.widget.listItems[index].endDate.year,this.widget.listItems[index].endDate.month+intVal,this.widget.listItems[index].endDate.day);
                          // }
                          updateClient(this.widget.listItems[index], this.widget.listItems[index].id);
                        });
                      }
                    catch(E){
                      globalShowInSnackBar(widget.scaffoldMessengerKey, "Invalid Quantity!!");
                    }
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
              caption: 'Send Reminder',
              icon: Icons.send,
              onTap: () async {
                if(this.widget.listItems[index].mobileNo!=null&&this.widget.listItems[index].mobileNo!="")
                {
                  var url = "https://wa.me/+91${this.widget.listItems[index].mobileNo}?text=${this.widget.listItems[index].name}, ${GlobalClass.userDetail.reminderMessage!=null&&GlobalClass.userDetail.reminderMessage!=""?GlobalClass.userDetail.reminderMessage:"Your subscription has come to an end"
                      ", please clear your dues for further continuation of services."}";
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
