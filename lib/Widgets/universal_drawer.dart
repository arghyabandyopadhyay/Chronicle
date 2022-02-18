import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'drawer_content.dart';

class UniversalDrawerWidget extends StatelessWidget {
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey;
  final state;
  final bool isNotRegisterPage;
  final BuildContext masterContext;

  const UniversalDrawerWidget(
      {Key key,
      this.masterContext,
      this.scaffoldMessengerKey,
      this.state,
      this.isNotRegisterPage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: DrawerContent(
        scaffoldMessengerKey: scaffoldMessengerKey,
        drawerItems: [
          // DrawerActionModel(Icons.notifications, "Notifications", ()async{
          //   Navigator.pop(masterContext);
          //   Navigator.of(masterContext).push(CupertinoPageRoute(builder: (notificationPageContext)=>NotificationsPage()));
          // }),
          // if(isNotRegisterPage)DrawerActionModel(Icons.book, "Registers", ()async{
          //   setLastRegister("");
          //   GlobalClass.lastRegister="";
          //   Navigator.pop(masterContext);
          //   Navigator.of(masterContext).pushReplacement(CupertinoPageRoute(builder: (registerPageContext)=>RegistersPage()));
          // }),
          // DrawerActionModel(Icons.video_collection_sharp, "Videos", ()async{
          //   Navigator.pop(masterContext);
          //   Navigator.of(masterContext).push(CupertinoPageRoute(builder: (videosPageContext)=>VideosPage()));
          // }),
          // DrawerActionModel(FontAwesomeIcons.bookOpen, "Courses", ()async{
          //   Navigator.pop(masterContext);
          //   Navigator.of(masterContext).push(CupertinoPageRoute(builder: (tutorTestContext)=>TutorCoursesPage()));
          // }),
          // DrawerActionModel(Icons.qr_code, "QR code", ()async{
          //   Navigator.pop(masterContext);
          //   UserModel userModel=await getUserDetails();
          //   if(userModel.qrcodeDetail!=null){
          //     Navigator.of(masterContext).push(new CupertinoPageRoute(builder: (qrCodePageContext)=>QrCodePage(qrCode: userModel.qrcodeDetail)));
          //   }
          //   else {
          //     String _data = '';
          //     try {
          //       final pickedFile = await ImagePicker().getImage(
          //         source: ImageSource.gallery,
          //         maxWidth: 300,
          //         maxHeight: 300,
          //         imageQuality: 30,
          //       );
          //       state.setState(() {
          //         QrCodeToolsPlugin.decodeFrom(pickedFile.path).then((value) {
          //           _data = value;
          //           userModel.qrcodeDetail=_data;
          //           userModel.update();
          //         });
          //
          //       });
          //     } catch (e) {
          //       globalShowInSnackBar(scaffoldMessengerKey,"Invalid File!!");
          //       state.setState(() {
          //         _data = '';
          //       });
          //     }
          //   }
          // }),
          // DrawerActionModel(Icons.settings, "Settings", ()async{
          //   Navigator.pop(masterContext);
          //   Navigator.of(masterContext).push(CupertinoPageRoute(builder: (settingsContext)=>SettingsPage()));
          // }),
        ],
      ),
    );
  }
}
