import 'package:Chronicle/Models/registerModel.dart';
import 'package:Chronicle/Pages/userInfoScreen.dart';
import 'package:Chronicle/Widgets/registerOptionBottomSheet.dart';
import 'package:Chronicle/registerList.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Chronicle/database.dart';
import '../Models/clientModel.dart';
import '../clientList.dart';
import '../registerNewClientWidget.dart';

class MyHomePage extends StatefulWidget {
  final User user;

  MyHomePage(this.user);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<RegisterModel> registers = [];

  void newRegisterModel(RegisterModel register) {
    register.setId(addToRegister(widget.user,register.name));
    this.setState(() {
      registers.add(register);
    });
  }
  void updateRegisterModel() {
    this.setState(() {
    });
  }

  void getRegisters() {
    getAllRegisters(widget.user).then((registers) => {
      this.setState(() {
        this.registers = registers;
      })
    });
  }

  @override
  void initState() {
    super.initState();
    // getClientModels();
    getRegisters();
  }
  TextEditingController textEditingController=new TextEditingController();
  @override
  Widget build(BuildContext context) {
    // print(registers[0]);
    return Scaffold(
        appBar: AppBar(title: Text("My Registers"),
        actions: [
          IconButton(icon: Icon(Icons.account_circle_outlined,), onPressed: (){
            Navigator.of(context).push(CupertinoPageRoute(builder: (context)=>UserInfoScreen(user: widget.user,)));
          }),
        ],),
        body: Column(children: <Widget>[
          Expanded(child: RegisterList(this.registers, widget.user)),
        ]),
      floatingActionButton: FloatingActionButton.extended(onPressed: (){
        // Navigator.of(context).push(CupertinoPageRoute(builder: (context)=>AddRegisterPage(user:widget.user)));
        showDialog(context: context, builder: (_)=>new AlertDialog(
          title: Text("Type The Name Of Register"),
          content: TextField(controller: textEditingController,),
          actions: [ElevatedButton(child: Text("Add"),onPressed: (){
            newRegisterModel(new RegisterModel(name: textEditingController.text));
            textEditingController.clear();
            Navigator.of(context).pop();
          },),
          ElevatedButton(onPressed: (){Navigator.of(context).pop();}, child: Text("Cancel"))],
        ));
      },
        label: Text("Add Registers"),icon: Icon(Icons.addchart_outlined),),
    );
  }
}
