import 'package:chronicle/Models/register_index_model.dart';
import 'package:chronicle/Models/register_model.dart';
import 'package:chronicle/Modules/error_page.dart';
import 'package:chronicle/Modules/universal_module.dart';
import 'package:chronicle/Widgets/loader_widget.dart';
import 'package:chronicle/Widgets/register_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chronicle/Modules/database.dart';
import '../../app_bar_variables.dart';
import '../../global_class.dart';
import '../notificationsPage.dart';

class RegistersPage extends StatefulWidget {
  final BuildContext mainScreenContext;
  RegistersPage(this.mainScreenContext);
  @override
  _RegistersPageState createState() => _RegistersPageState();
}

class _RegistersPageState extends State<RegistersPage> {
  GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  void newRegisterModel(RegisterModel register) {
    register.setId(addRegister(register.name));
    RegisterIndexModel registerIndex =
        RegisterIndexModel(uid: register.id.key, name: register.name);
    registerIndex.setId(addRegisterIndex(registerIndex));
    if (mounted)
      this.setState(() {
        GlobalClass.registerList.add(registerIndex);
      });
  }

  void updateRegisterModel() {
    if (mounted) this.setState(() {});
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

  TextEditingController textEditingController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      child: Scaffold(
        appBar: AppBar(
          title: AppBarVariables.appBarLeading(widget.mainScreenContext),
          actions: [
            if (GlobalClass.userDetail.isAppRegistered == 1)
              new IconButton(
                  icon: Icon(Icons.notifications_outlined),
                  onPressed: () {
                    setState(() {
                      Navigator.of(widget.mainScreenContext).push(
                          CupertinoPageRoute(
                              builder: (notificationPageContext) =>
                                  NotificationsPage()));
                    });
                  }),
          ],
        ),
        // drawer: UniversalDrawerWidget(scaffoldMessengerKey: scaffoldMessengerKey,state: this,isNotRegisterPage: false,masterContext: context),
        body: GlobalClass.registerList != null
            ? GlobalClass.registerList.length == 0
                ? NoDataError()
                : Column(children: <Widget>[
                    Expanded(
                        child: RegisterList(false, false, null,
                            scaffoldMessengerKey, widget.mainScreenContext)),
                  ])
            : LoaderWidget(),
        floatingActionButton: FloatingActionButton.extended(
          heroTag: "registerPageHeroTag",
          onPressed: () {
            // Navigator.of(context).push(CupertinoPageRoute(builder: (context)=>AddRegisterPage(user:widget.user)));
            showDialog(
                context: context,
                builder: (_) => new AlertDialog(
                      title: Text("Name your Register"),
                      content: TextField(
                        controller: textEditingController,
                        textCapitalization: TextCapitalization.words,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: "Name of the Register",
                          contentPadding: EdgeInsets.only(
                              bottom: 10.0, left: 10.0, right: 10.0),
                        ),
                      ),
                      actions: [
                        ActionChip(
                            label: Text("Add"),
                            onPressed: () {
                              if (textEditingController.text != "") {
                                newRegisterModel(new RegisterModel(
                                    name: textEditingController.text));
                                textEditingController.clear();
                                Navigator.pop(_);
                              } else {
                                globalShowInSnackBar(scaffoldMessengerKey,
                                    "Please enter a valid name for your register!!");
                                Navigator.of(_).pop();
                              }
                            }),
                        ActionChip(
                            label: Text("Cancel"),
                            onPressed: () {
                              Navigator.of(_).pop();
                            }),
                      ],
                    ));
          },
          label: Text("Add Registers"),
          icon: Icon(Icons.addchart_outlined),
        ),
      ),
      key: scaffoldMessengerKey,
    );
  }
}
