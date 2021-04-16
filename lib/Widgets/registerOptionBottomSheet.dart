import 'package:chronicle/Models/registerModel.dart';
import 'package:chronicle/Modules/database.dart';
import 'package:chronicle/Modules/universalModule.dart';
import 'package:chronicle/Pages/globalClass.dart';
import 'package:chronicle/Widgets/registerList.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class RegisterOptionBottomSheet extends StatelessWidget {
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey=GlobalKey();
  TextEditingController textEditingController=new TextEditingController();
  //list of options you want to show in the bottom sheet
  RegisterOptionBottomSheet({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    void newRegisterModel(RegisterModel register) {
      register.setId(addToRegister(register.name));
        GlobalClass.registerList.add(register);
    }
    return ScaffoldMessenger(child: Scaffold(
      appBar:AppBar(
        title: Text("Registers"),
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
                  Navigator.of(context).pop();
                }
                else{
                  globalShowInSnackBar(scaffoldMessengerKey, "Please enter a valid name for your register!!");
                  Navigator.of(context).pop();
                }
              }),
                ActionChip(label: Text("Cancel"), onPressed: (){
                  Navigator.of(context).pop();
                }),],
            ));
          }),
          new IconButton(icon: Icon(Icons.clear), onPressed:(){
            //closes the modal on pressing the Icons Button
            Navigator.pop(context);
          }),
        ],
      ),
      // body: Column(
      //   children: [
      //     Expanded(child:ListView.builder(
      //       physics: BouncingScrollPhysics(),
      //       shrinkWrap: true,
      //       itemCount: GlobalClass.registerList.length,
      //       itemBuilder: (context, index) {
      //         return ListTile(
      //           title: Text(GlobalClass.registerList[index].name),
      //           onTap: (){
      //             globalShowInSnackBar(scaffoldMessengerKey,GlobalClass.registerList[index].name);
      //           }
      //         );
      //       },
      //     ),)
      //   ],
      // ),
      body: Column(children: <Widget>[
        Expanded(child: RegisterList(true)),
      ]),
    ),key: scaffoldMessengerKey,);

  }
}