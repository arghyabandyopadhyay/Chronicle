import 'package:chronicle/Models/registerIndexModel.dart';
import 'package:chronicle/Models/registerModel.dart';
import 'package:chronicle/Modules/errorPage.dart';
import 'package:chronicle/Modules/universalModule.dart';
import 'package:chronicle/Widgets/Simmers/clientListSimmerWidget.dart';
import 'package:chronicle/Widgets/registerList.dart';
import 'package:chronicle/Widgets/universalDrawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chronicle/Modules/database.dart';
import '../../globalClass.dart';

class RegistersPage extends StatefulWidget {
  RegistersPage();
  @override
  _RegistersPageState createState() => _RegistersPageState();
}

class _RegistersPageState extends State<RegistersPage> {
  GlobalKey<ScaffoldState> scaffoldKey=GlobalKey<ScaffoldState>();
  GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey=GlobalKey<ScaffoldMessengerState>();
  void newRegisterModel(RegisterModel register) {
    register.setId(addRegister(register.name));
    RegisterIndexModel registerIndex=RegisterIndexModel(uid: register.id.key,name: register.name);
    registerIndex.setId(addRegisterIndex(registerIndex));
    if(mounted)this.setState(() {
      GlobalClass.registerList.add(registerIndex);
    });
  }
  void updateRegisterModel() {
    if(mounted)this.setState(() {
    });
  }

  void getRegisters() {
      getAllRegisterIndex().then((registers) => {
      setState(() {
        GlobalClass.registerList = registers;
      }),
        // sendNotifications(scaffoldMessengerKey,GlobalClass.userDetail.messageString),
      });

  }
  @override
  void initState() {
    super.initState();
    getRegisters();
  }
  TextEditingController textEditingController=new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(child: Scaffold(
      key:scaffoldKey,
      appBar: AppBar(title: Text("Registers"),),
      drawer: UniversalDrawerWidget(scaffoldMessengerKey: scaffoldMessengerKey,state: this,isNotRegisterPage: false,masterContext: context),
      body: GlobalClass.registerList!=null?GlobalClass.registerList.length==0?NoDataError():Column(children: <Widget>[
        Expanded(child: RegisterList(false,false,null,scaffoldMessengerKey)),
      ]):
      ClientListSimmerWidget(),
      floatingActionButton: FloatingActionButton.extended(onPressed: (){
        // Navigator.of(context).push(CupertinoPageRoute(builder: (context)=>AddRegisterPage(user:widget.user)));
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
              Navigator.pop(_);
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
      },
        label: Text("Add Registers"),icon: Icon(Icons.addchart_outlined),),
    ),key: scaffoldMessengerKey,);
  }
}
