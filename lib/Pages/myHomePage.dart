import 'package:chronicle/Models/DrawerActionModel.dart';
import 'package:chronicle/Models/registerModel.dart';
import 'package:chronicle/Models/userModel.dart';
import 'package:chronicle/Modules/auth.dart';
import 'package:chronicle/Modules/errorPage.dart';
import 'package:chronicle/Modules/universalModule.dart';
import 'package:chronicle/Pages/notificationsPage.dart';
import 'package:chronicle/Pages/qrCodePage.dart';
import 'package:chronicle/Pages/userInfoScreen.dart';
import 'package:chronicle/Widgets/DrawerContent.dart';
import 'package:chronicle/Widgets/registerList.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chronicle/Modules/database.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_code_tools/qr_code_tools.dart';
import 'package:shimmer/shimmer.dart';
import 'SignInScreen.dart';
import 'globalClass.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage();
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  PickedFile _imageFile;
  GlobalKey<ScaffoldState> scaffoldKey=GlobalKey<ScaffoldState>();
  GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey=GlobalKey<ScaffoldMessengerState>();
  void newRegisterModel(RegisterModel register) {
    register.setId(addToRegister(register.name));
    this.setState(() {
      GlobalClass.registerList.add(register);
    });
  }
  void updateRegisterModel() {
    this.setState(() {
    });
  }

  void getRegisters() {
      getAllRegisters().then((registers) => {
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
      drawer: Drawer(
        child: DrawerContent(
          scaffoldMessengerKey: scaffoldMessengerKey,
          drawerItems: [
            DrawerActionModel(Icons.notifications, "Notifications", ()async{
              Navigator.pop(context);
              Navigator.of(context).push(CupertinoPageRoute(builder: (context)=>NotificationsPage()));
            }),
            DrawerActionModel(Icons.qr_code, "QR code", ()async{
              Navigator.pop(context);
              UserModel userModel=await getUserDetails();
              if(userModel.qrcodeDetail!=null){
                Navigator.of(context).push(new CupertinoPageRoute(builder: (context)=>QrCodePage(qrCode: userModel.qrcodeDetail)));
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
                    QrCodeToolsPlugin.decodeFrom(pickedFile.path).then((value) {
                      _data = value;
                      userModel.qrcodeDetail=_data;
                      updateUserDetails(userModel, userModel.id);
                    });

                  });
                } catch (e) {
                  globalShowInSnackBar(scaffoldMessengerKey,e);
                  setState(() {
                    _data = '';
                  });
                }
              }
            }),
            DrawerActionModel(Icons.account_circle, "Profile", ()async{
              Navigator.pop(context);
              Navigator.of(context).push(CupertinoPageRoute(builder: (context)=>UserInfoScreen()));
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
      body: GlobalClass.registerList!=null?GlobalClass.registerList.length==0?NoDataError():Column(children: <Widget>[
        Expanded(child: RegisterList(false)),
      ]):
      Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                child: Shimmer.fromColors(
                    baseColor: Colors.white,
                    highlightColor: Colors.grey.withOpacity(0.5),
                    enabled: true,
                    child: ListView.builder(
                      itemBuilder: (_, __) => Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 48.0,
                              height: 48.0,
                              color: Colors.white,
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    width: double.infinity,
                                    height: 8.0,
                                    color: Colors.white,
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 2.0),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    height: 8.0,
                                    color: Colors.white,
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 2.0),
                                  ),
                                  Container(
                                    width: 40.0,
                                    height: 8.0,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      itemCount: 4,
                    )
                ),
              ),
            ],
          )
      ),
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
