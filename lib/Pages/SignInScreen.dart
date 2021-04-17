import 'package:chronicle/Models/DrawerActionModel.dart';
import 'package:chronicle/Models/userModel.dart';
import 'package:chronicle/Modules/sharedPreferenceHandler.dart';
import 'package:chronicle/Modules/universalModule.dart';
import 'package:chronicle/Pages/clientPage.dart';
import 'package:chronicle/Pages/globalClass.dart';
import 'package:chronicle/Pages/qrCodePage.dart';
import 'package:chronicle/Pages/userInfoScreen.dart';
import 'package:chronicle/Widgets/DrawerContent.dart';
import 'package:chronicle/Widgets/googleSignInButton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_code_tools/qr_code_tools.dart';
import 'package:shimmer/shimmer.dart';
import '../Modules/auth.dart';
import '../Modules/database.dart';
import 'idBlockedPage.dart';
import 'myHomePage.dart';
import 'notificationsPage.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}
class _SignInScreenState extends State<SignInScreen> {
  GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey=GlobalKey<ScaffoldMessengerState>();
  PickedFile _imageFile;
  Future<Widget> _widget;
  Future<Widget> getWidget()async{
    Widget widget;
    // await registerUserDetail().then((value)async{
    //   if(value!=null)
    //     {
    //       widget=MyHomePage();
    //       getAllRegisters().then((value) {
    //         GlobalClass.registerList=value;
    //
    //       });
    //       String lastRegister=await ;
    //       sendNotifications(scaffoldMessengerKey);
    //       if(lastRegister!=null){
    //         RegisterModel temp=GlobalClass.registerList.where((element) => element.id.key==lastRegister).first;
    //         print(temp.name);
    //         if(temp!=null)widget=ClientPage(temp);
    //       }
    //     }
    //   else{
    //     widget=IdBlockedPage();
    //   }
    // });

    GlobalClass.user = FirebaseAuth.instance.currentUser;
    if(GlobalClass.user!=null){
      await registerUserDetail().then((value)async=>{
        if(value!=null){
          await getLastRegister().then((lastRegister) async => {
            if(lastRegister==null||lastRegister=="")
              {
                widget=MyHomePage()
              }
            else {
                await getAllRegisters().then((registers) => {
                    GlobalClass.registerList = registers,
                    // sendNotifications(scaffoldMessengerKey,GlobalClass.userDetail.messageString),
                  widget=ClientPage(registers.where((element) => element.id.key==lastRegister).first)
                })
            }
          })
          }
        else{
          widget= IdBlockedPage()
        }
      });
    }
    else {
      widget= SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            bottom: 20.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Image.asset(
                        'assets/firebase_logo.png',
                        // height: 400,
                      ),
                    ),
                    SizedBox(height: 20),
                    // Text(
                    //   'Chronicle',
                    //   style: TextStyle(
                    //     color: CustomColors.firebaseYellow,
                    //     fontSize: 40,
                    //   ),
                    // ),
                    // Text(
                    //   'Authentication',
                    //   style: TextStyle(
                    //     color: CustomColors.firebaseBlue,
                    //     fontSize: 40,
                    //   ),
                    // ),
                  ],
                ),
              ),
              GoogleSignInButton(scaffoldMessengerKey: scaffoldMessengerKey,)
            ],
          ),
        ),
      );
    }
    return widget;
  }
  @override
  void initState() {
    super.initState();
    _widget=getWidget();
  }
  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(child:
    Scaffold(
      body:FutureBuilder<Widget>(
          future: _widget,
          builder: (context, snapshot) {
            // if (snapshot.hasError) {
            //   return Column(
            //     children: [
            //       Expanded(child: IdBlockedPage()),
            //     ],
            //   );
            // }
            // else if (snapshot.connectionState == ConnectionState.done) {
            //   GlobalClass.user = FirebaseAuth.instance.currentUser;
            //   if(GlobalClass.user!=null){
            //     registerclientdata
            //     return MyHomePage();
            //   }
            //   else {
            //     return SafeArea(
            //       child: Padding(
            //         padding: const EdgeInsets.only(
            //           left: 16.0,
            //           right: 16.0,
            //           bottom: 20.0,
            //         ),
            //         child: Column(
            //           mainAxisSize: MainAxisSize.max,
            //           children: [
            //             Row(),
            //             Expanded(
            //               child: Column(
            //                 mainAxisSize: MainAxisSize.min,
            //                 mainAxisAlignment: MainAxisAlignment.center,
            //                 children: [
            //                   Flexible(
            //                     flex: 1,
            //                     child: Image.asset(
            //                       'assets/firebase_logo.png',
            //                       // height: 400,
            //                     ),
            //                   ),
            //                   SizedBox(height: 20),
            //                   // Text(
            //                   //   'Chronicle',
            //                   //   style: TextStyle(
            //                   //     color: CustomColors.firebaseYellow,
            //                   //     fontSize: 40,
            //                   //   ),
            //                   // ),
            //                   // Text(
            //                   //   'Authentication',
            //                   //   style: TextStyle(
            //                   //     color: CustomColors.firebaseBlue,
            //                   //     fontSize: 40,
            //                   //   ),
            //                   // ),
            //                 ],
            //               ),
            //             ),
            //             GoogleSignInButton(scaffoldMessengerKey: scaffoldMessengerKey,)
            //           ],
            //         ),
            //       ),
            //     );
            //   }
            // }
            // // By default, show a loading spinner.

            if(snapshot.hasData)
              {
                return snapshot.data;
              }
            else if(snapshot.hasError){
              return IdBlockedPage();
            }
            return Scaffold(
                appBar: AppBar(title: Text("Chronicle"),elevation: 0),
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
                body: Container(
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
                ));
          }
      ),
    ),
    key: scaffoldMessengerKey,);
  }
}