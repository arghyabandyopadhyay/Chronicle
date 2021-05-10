import 'package:chronicle/Models/clientModel.dart';
import 'package:chronicle/Models/modalOptionModel.dart';
import 'package:chronicle/Modules/sharedPreferenceHandler.dart';
import 'package:chronicle/Modules/universalModule.dart';
import 'package:chronicle/Pages/clientPage.dart';
import 'package:chronicle/Modules/database.dart';
import 'package:chronicle/Pages/globalClass.dart';
import 'package:chronicle/Widgets/optionModalBottomSheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class RegisterList extends StatefulWidget {
  final List<ClientModel> selectedClients;
  final bool isDialog;
  final bool isAddToRegister;
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey;
  RegisterList(this.isDialog,this.isAddToRegister,this.selectedClients,this.scaffoldMessengerKey);
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
              if(widget.isAddToRegister){
                if(GlobalClass.registerList[index].id.key==GlobalClass.lastRegister){
                  globalShowInSnackBar(widget.scaffoldMessengerKey, "You can't add to the same register!!");
                }
                else{
                  showModalBottomSheet(context: context, builder: (_)=>
                      OptionModalBottomSheet(
                        appBarText: "Adding To Register",
                        list: [
                          ModalOptionModel(
                              particulars: "Move",
                              icon: Icons.drive_file_move,
                              onTap: (){
                                moveClientsModule(widget.selectedClients, GlobalClass.registerList[index]);
                                Navigator.of(context).pop();
                                Navigator.of(_).pop();

                              }),
                          ModalOptionModel(
                              particulars: "Copy",
                              icon: Icons.copy,
                              onTap: (){
                                copyClientsModule(widget.selectedClients, GlobalClass.registerList[index]);
                                Navigator.of(context).pop();
                                Navigator.of(_).pop();
                              }),],));
                }
              }
              else{
                if(widget.isDialog)Navigator.of(context).pop();
                Navigator.of(context).pushReplacement(CupertinoPageRoute(builder: (context)=>ClientPage(GlobalClass.registerList[index] )));
                GlobalClass.lastRegister=GlobalClass.registerList[index].id.key;
                setLastRegister(GlobalClass.registerList[index].id.key);
              }
            },
            onLongPress: (){
              showDialog(context: context, builder: (_)=>new AlertDialog(
                  title: Text("Confirm Delete"),
                  content: Text("Are you sure to delete \"${GlobalClass.registerList[index].name}\" ? All the client data will be deleted."),
                  actions: [
                    ActionChip(label: Text("Yes"), onPressed: (){
                      setState(() {
                        deleteDatabaseNode(GlobalClass.registerList[index].id);
                        deleteDatabaseNode(getDatabaseReference("registers/${GlobalClass.registerList[index].uid}"));
                        if(GlobalClass.lastRegister!=null&&GlobalClass.lastRegister==GlobalClass.registerList[index].id.key)setLastRegister("");
                        GlobalClass.registerList.removeAt(index);
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
            },),
      staggeredTileBuilder: (int index) =>
      new StaggeredTile.count(2, index%3==0?1:index%3.toDouble()),
      mainAxisSpacing: 5.0,
      crossAxisSpacing: 5.0,
    );
  }
}
