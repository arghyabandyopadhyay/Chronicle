import 'package:chronicle/Models/registerModel.dart';
import 'package:chronicle/Modules/sharedPreferenceHandler.dart';
import 'package:chronicle/Pages/clientPage.dart';
import 'package:chronicle/Modules/database.dart';
import 'package:chronicle/Pages/globalClass.dart';
import 'package:chronicle/customColors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class RegisterList extends StatefulWidget {
  bool isDialog;
  RegisterList(this.isDialog);
  @override
  _RegisterListState createState() => _RegisterListState();
}

class _RegisterListState extends State<RegisterList> {
  @override
  Widget build(BuildContext context) {
    return StaggeredGridView.countBuilder(
      crossAxisCount: 4,
      itemCount: GlobalClass.registerList.length,
      itemBuilder: (BuildContext context, int index) => GestureDetector(child:Container(
          color: Colors.grey.withOpacity(0.1),
          alignment: Alignment.center,
          child: Text(GlobalClass.registerList[index].name,textAlign: TextAlign.center,style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),)),
          onTap: (){
              if(widget.isDialog)Navigator.of(context).pop();
              Navigator.of(context).pushReplacement(CupertinoPageRoute(builder: (context)=>ClientPage(GlobalClass.registerList[index] )));
              setLastRegister(GlobalClass.registerList[index].id.key);
            },
            onLongPress: (){
              showDialog(context: context, builder: (_)=>new AlertDialog(
                  title: Text("Confirm Delete"),
                  content: Text("Are you sure to delete \"${GlobalClass.registerList[index].name}\" ? All the client data will be deleted."),
                  actions: [
                    ActionChip(label: Text("Yes"), onPressed: (){
                      setState(() {
                        deleteDatabaseNode(GlobalClass.registerList[index].id);
                        GlobalClass.registerList.removeAt(index);
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
            },),
      staggeredTileBuilder: (int index) =>
      new StaggeredTile.count(2, index%3==0?1:index%3.toDouble()),
      mainAxisSpacing: 5.0,
      crossAxisSpacing: 5.0,
    );
  }
}
