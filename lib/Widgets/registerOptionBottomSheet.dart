import 'package:chronicle/Models/clientModel.dart';
import 'package:chronicle/Models/registerIndexModel.dart';
import 'package:chronicle/Models/registerModel.dart';
import 'package:chronicle/Modules/database.dart';
import 'package:chronicle/Modules/errorPage.dart';
import 'package:chronicle/Modules/universalModule.dart';
import 'package:chronicle/Pages/globalClass.dart';
import 'package:chronicle/Widgets/registerList.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class RegisterOptionBottomSheet extends StatelessWidget {
  final bool isAddToRegister;
  final List<ClientModel> selectedClients;
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey=GlobalKey();
  final TextEditingController textEditingController=new TextEditingController();
  //list of options you want to show in the bottom sheet
  RegisterOptionBottomSheet({Key key, this.isAddToRegister,this.selectedClients}) : super(key: key);
  void newRegisterModel(RegisterModel register) {
    register.setId(addToRegister(register.name));
    RegisterIndexModel registerIndex=RegisterIndexModel(uid: register.id.key,name: register.name);
    registerIndex.setId(addToRegisterIndex(registerIndex));
    GlobalClass.registerList.add(registerIndex);
  }
  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(child: Scaffold(
      appBar:AppBar(
        title: Text(this.isAddToRegister?"Add To Registers":"Registers"),
        leading: IconButton(
          icon: Icon(Icons.book),
          onPressed: (){},
        ),
        actions: <Widget>[
          new IconButton(icon: Icon(Icons.add), onPressed:(){
            //closes the modal on pressing the Icons Button
            showDialog(context: context, builder: (_)=>new AlertDialog(
              title: Text("Name your Register"),
              content: TextField(controller: textEditingController,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: "Name of the Register",
                  contentPadding:
                  EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0),
                ),
              ),
              actions: [ActionChip(label: Text("Add"), onPressed: (){
                if(textEditingController.text!=""){
                  newRegisterModel(new RegisterModel(name: textEditingController.text));
                  textEditingController.clear();
                  Navigator.of(_).pop();
                }
                else{
                  globalShowInSnackBar(scaffoldMessengerKey, "Please enter a valid name for your register!!");
                  Navigator.of(_).pop();
                }
              }),
                ActionChip(label: Text("Cancel"), onPressed: (){
                  Navigator.of(_).pop();
                }),],
            ));
          }),
          new IconButton(icon: Icon(Icons.clear), onPressed:(){
            //closes the modal on pressing the Icons Button
            Navigator.pop(context);
          }),
        ],
      ),
      body: GlobalClass.registerList==null||GlobalClass.registerList.length==0?NoDataError():Column(children: <Widget>[
        Expanded(child: RegisterList(true,this.isAddToRegister,this.selectedClients,scaffoldMessengerKey)),
      ]),
    ),key: scaffoldMessengerKey,);

  }
}