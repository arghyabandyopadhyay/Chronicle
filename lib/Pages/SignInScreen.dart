import 'package:chronicle/Models/DrawerActionModel.dart';
import 'package:chronicle/Models/userModel.dart';
import 'package:chronicle/Modules/universalModule.dart';
import 'package:chronicle/Pages/globalClass.dart';
import 'package:chronicle/Pages/qrCodePage.dart';
import 'package:chronicle/Pages/settingsPage.dart';
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
import '../customColors.dart';
import '../Modules/database.dart';
import 'aboutUsPage.dart';
import 'idBlockedPage.dart';
import 'myHomePage.dart';
import 'notificationsPage.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}
class _SignInScreenState extends State<SignInScreen> {

  PickedFile _imageFile;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: DrawerContent(
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
                  debugPrint(e);
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
      appBar:AppBar(
        elevation: 0,title: Text("Chronicle")),
      body:
      FutureBuilder(
          future: Authentication.initializeFirebase(context: context),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Column(
                children: [
                  Expanded(child: IdBlockedPage()),
                ],
              );
            }
            else if (snapshot.connectionState == ConnectionState.done) {
              GlobalClass.user = FirebaseAuth.instance.currentUser;
              if(GlobalClass.user!=null){
                return FutureBuilder(
                future: registerUserDetail(),
                builder: (context, snapshot1) {
                  if(snapshot1.hasData)
                    {
                      return MyHomePage(false);
                    }
                  return Container(
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
                  );
                });
                // registerUserDetail().then((value) => {
                //   // Navigator.popUntil(context, (route) => route.isFirst),
                //   if(value!=null)Navigator.pushReplacement(context, PageRouteBuilder(pageBuilder: (context,animation,secondAnimation) => MyHomePage()))
                //   else{
                //     Navigator.of(context).pushReplacement(PageRouteBuilder(pageBuilder: (context,animation,secondAnimation) =>IdBlockedPage()))
                //   }
                // });
              }
              else {
                return SafeArea(
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
                                flex: 1,
                                child: Image.asset(
                                  'assets/firebase_logo.png',
                                  height: 160,
                                ),
                              ),
                              SizedBox(height: 20),
                              Text(
                                'Chronicle',
                                style: TextStyle(
                                  color: CustomColors.firebaseYellow,
                                  fontSize: 40,
                                ),
                              ),
                              Text(
                                'Authentication',
                                style: TextStyle(
                                  color: CustomColors.firebaseOrange,
                                  fontSize: 40,
                                ),
                              ),
                            ],
                          ),
                        ),
                        GoogleSignInButton()
                      ],
                    ),
                  ),
                );
              }
            }
            // By default, show a loading spinner.
            return Container(
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
            );
          }
      ),
    );
  }
}