import 'package:chronicle/Models/DrawerActionModel.dart';
import 'package:chronicle/Models/registerModel.dart';
import 'package:chronicle/Models/userModel.dart';
import 'package:chronicle/Modules/auth.dart';
import 'package:chronicle/Pages/aboutUsPage.dart';
import 'package:chronicle/Pages/notificationsPage.dart';
import 'package:chronicle/Pages/qrCodePage.dart';
import 'package:chronicle/Pages/settingsPage.dart';
import 'package:chronicle/Pages/userInfoScreen.dart';
import 'package:chronicle/Widgets/DrawerContent.dart';
import 'package:chronicle/Widgets/registerOptionBottomSheet.dart';
import 'package:chronicle/Widgets/registerList.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chronicle/Modules/database.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_code_tools/qr_code_tools.dart';
import '../Models/clientModel.dart';
import '../Widgets/clientList.dart';
import '../customColors.dart';
import '../Widgets/registerNewClientWidget.dart';
import 'SignInScreen.dart';

class MyHomePage extends StatefulWidget {
  final User user;

  MyHomePage(this.user);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<RegisterModel> registers = [];
  PickedFile? _imageFile;
  GlobalKey<ScaffoldState> scaffoldKey=GlobalKey<ScaffoldState>();

  void newRegisterModel(RegisterModel register) {
    register.setId(addToRegister(widget.user,register.name!));
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
      key:scaffoldKey,
      drawer: Drawer(
        child: DrawerContent(
          user: widget.user,
          drawerItems: [
            DrawerActionModel(Icons.notifications, "Notifications", ()async{
              Navigator.pop(context);
              Navigator.of(context).push(CupertinoPageRoute(builder: (context)=>NotificationsPage()));
            }),
            DrawerActionModel(Icons.qr_code, "QR code", ()async{
              Navigator.pop(context);
              UserModel? userModel=await getUserDetails(widget.user);
              if(userModel!.qrcodeDetail!=null){
                Navigator.of(context).push(new CupertinoPageRoute(builder: (context)=>QrCodePage(qrCode: userModel.qrcodeDetail,user: widget.user,)));
              }
              else {
                String _data = '';
                try {
                  final pickedFile = await ImagePicker().getImage(
                    source: ImageSource.gallery,
                    maxWidth: 300,
                    maxHeight: 300,
                    imageQuality: 30,
                  );
                  setState(() {
                    _imageFile = pickedFile;
                    QrCodeToolsPlugin.decodeFrom(pickedFile!.path).then((value) {
                      _data = value;
                      userModel.qrcodeDetail=_data;
                      updateUserDetails(userModel, userModel.id!);

                    });

                  });
                } catch (e) {
                  print(e);
                  setState(() {
                    _data = '';
                  });
                }
              }
            }),
            DrawerActionModel(Icons.account_circle, "Profile", ()async{
              Navigator.pop(context);
              Navigator.of(context).push(CupertinoPageRoute(builder: (context)=>UserInfoScreen(user: widget.user,)));
            }),
            DrawerActionModel(Icons.info, "About Us", ()async{
              Navigator.pop(context);
              Navigator.of(context).push(CupertinoPageRoute(builder: (context)=>AboutUsPage()));
            }),
            DrawerActionModel(Icons.settings, "Settings", ()async{
              Navigator.pop(context);
              Navigator.of(context).push(CupertinoPageRoute(builder: (context)=>SettingsPage(user: widget.user,)));
            }),
            DrawerActionModel(Icons.logout, "Log out", ()async{
              await Authentication.signOut(context: context);
              Navigator.pop(context);
              Navigator.of(context).pushReplacement(PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => SignInScreen(),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  var begin = Offset(-1.0, 0.0);
                  var end = Offset.zero;
                  var curve = Curves.ease;
                  var tween =
                  Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
              ));
            }),
          ],
        ),
      ),
      appBar: AppBar(
        elevation: 0,title: Text("Registers"),
      ),
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
