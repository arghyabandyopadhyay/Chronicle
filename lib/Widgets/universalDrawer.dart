import 'package:chronicle/Models/DrawerActionModel.dart';
import 'package:chronicle/Models/userModel.dart';
import 'package:chronicle/Modules/auth.dart';
import 'package:chronicle/Modules/database.dart';
import 'package:chronicle/Modules/sharedPreferenceHandler.dart';
import 'package:chronicle/Modules/universalModule.dart';
import 'package:chronicle/Pages/TutorPages/qrCodePage.dart';
import 'package:chronicle/Pages/TutorPages/registersPage.dart';
import 'package:chronicle/Pages/TutorPages/tutorTestsPage.dart';
import 'package:chronicle/Pages/TutorPages/videosPage.dart';
import 'package:chronicle/globalClass.dart';
import 'package:chronicle/Pages/notificationsPage.dart';
import 'package:chronicle/Pages/routingPage.dart';
import 'package:chronicle/Pages/settingsPage.dart';
import 'package:chronicle/Pages/userInfoScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_code_tools/qr_code_tools.dart';

import 'DrawerContent.dart';

class UniversalDrawerWidget extends StatelessWidget
{
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey;
  final state;
  final bool isNotRegisterPage;
  final BuildContext masterContext;

  const UniversalDrawerWidget({Key key,this.masterContext, this.scaffoldMessengerKey, this.state,this.isNotRegisterPage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: DrawerContent(
        scaffoldMessengerKey: scaffoldMessengerKey,
        drawerItems: [
          DrawerActionModel(Icons.notifications, "Notifications", ()async{
            Navigator.pop(masterContext);
            Navigator.of(masterContext).push(CupertinoPageRoute(builder: (notificationPageContext)=>NotificationsPage()));
          }),
          if(isNotRegisterPage)DrawerActionModel(Icons.book, "Registers", ()async{
            setLastRegister("");
            GlobalClass.lastRegister="";
            Navigator.pop(masterContext);
            Navigator.of(masterContext).pushReplacement(CupertinoPageRoute(builder: (registerPageContext)=>RegistersPage()));
          }),
          DrawerActionModel(Icons.video_collection_sharp, "Videos", ()async{
            Navigator.pop(masterContext);
            Navigator.of(masterContext).push(CupertinoPageRoute(builder: (videosPageContext)=>VideosPage()));
          }),
          DrawerActionModel(FontAwesomeIcons.bookOpen, "Tests", ()async{
            Navigator.pop(masterContext);
            Navigator.of(masterContext).push(CupertinoPageRoute(builder: (tutorTestContext)=>TutorTestsPage()));
          }),
          DrawerActionModel(Icons.qr_code, "QR code", ()async{
            Navigator.pop(masterContext);
            UserModel userModel=await getUserDetails();
            if(userModel.qrcodeDetail!=null){
              Navigator.of(masterContext).push(new CupertinoPageRoute(builder: (qrCodePageContext)=>QrCodePage(qrCode: userModel.qrcodeDetail)));
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
                state.setState(() {
                  QrCodeToolsPlugin.decodeFrom(pickedFile.path).then((value) {
                    _data = value;
                    userModel.qrcodeDetail=_data;
                    updateUserDetails(userModel, userModel.id);
                  });

                });
              } catch (e) {
                globalShowInSnackBar(scaffoldMessengerKey,"Invalid File!!");
                state.setState(() {
                  _data = '';
                });
              }
            }
          }),
          DrawerActionModel(Icons.account_circle, "Profile", ()async{
            Navigator.pop(masterContext);
            Navigator.of(masterContext).push(CupertinoPageRoute(builder: (userInfoContext)=>UserInfoScreen()));
          }),
          DrawerActionModel(Icons.logout, "Log out", ()async{
            await Authentication.signOut(context: masterContext);
            Navigator.popUntil(masterContext, (route) => route.isFirst);
            Navigator.of(masterContext).pushReplacement(PageRouteBuilder(
              pageBuilder: (routingPageContext, animation, secondaryAnimation) => RoutingPage(),
              transitionsBuilder: (routingPageContext, animation, secondaryAnimation, child) {
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
          DrawerActionModel(Icons.settings, "Settings", ()async{
            Navigator.pop(masterContext);
            Navigator.of(masterContext).push(CupertinoPageRoute(builder: (settingsContext)=>SettingsPage()));
          }),
        ],
      ),
    );
  }

}