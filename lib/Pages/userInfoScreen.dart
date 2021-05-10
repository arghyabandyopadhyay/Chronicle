import 'package:chronicle/Models/userModel.dart';
import 'package:chronicle/Modules/universalModule.dart';
import 'package:chronicle/Pages/qrCodePage.dart';
import 'package:chronicle/Modules/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_code_tools/qr_code_tools.dart';

import '../Modules/auth.dart';
import '../customColors.dart';
import 'SignInScreen.dart';
import 'globalClass.dart';

class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({Key key}):super(key: key);

  @override
  _UserInfoScreenState createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  bool _isSigningOut = false;

  GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey=GlobalKey<ScaffoldMessengerState>();
  Route _routeToSignInScreen() {
    return PageRouteBuilder(
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
    );
  }

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(child:Scaffold(
      appBar: AppBar(

        title: Text("My Profile"),
        actions: [
          IconButton(icon: Icon(Icons.payment), onPressed: ()async{
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
          })
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            bottom: 20.0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 50.0),
              GlobalClass.user.photoURL != null
                  ? ClipOval(
                child: Material(
                  color: CustomColors.firebaseGrey.withOpacity(0.3),
                  child: Image.network(
                    GlobalClass.user.photoURL,
                    fit: BoxFit.fitHeight,
                  ),
                ),
              )
                  : ClipOval(
                child: Material(
                  color: CustomColors.firebaseGrey.withOpacity(0.3),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Icon(
                      Icons.person,
                      size: 60,
                      color: CustomColors.firebaseGrey,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Text(
                GlobalClass.user.displayName,
                style: TextStyle(
                  color: CustomColors.firebaseYellow,
                  fontSize: 26,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                '( ${GlobalClass.user.email} )',
                style: TextStyle(
                  color: CustomColors.firebaseOrange,
                  fontSize: 20,
                  letterSpacing: 0.5,
                ),
              ),
              SizedBox(height: 24.0),
              Text(
                'You are now signed in using your Google account. To sign out of your account, click the "Sign Out" button below.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 14,
                    letterSpacing: 0.2),
              ),
              SizedBox(height: 16.0),
              // _isSigningOut
              //     ? CircularProgressIndicator(
              //   valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              // )
              //     : ElevatedButton(
              //   style: ButtonStyle(
              //     backgroundColor: MaterialStateProperty.all(
              //       Colors.redAccent,
              //     ),
              //     shape: MaterialStateProperty.all(
              //       RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(10),
              //       ),
              //     ),
              //   ),
              //   onPressed: () async {
              //     setState(() {
              //       _isSigningOut = true;
              //     });
              //     await Authentication.signOut(context: context);
              //     setState(() {
              //       _isSigningOut = false;
              //     });
              //     Navigator.of(context).popUntil((route) => route.isFirst);
              //     Navigator.of(context).pushReplacement(_routeToSignInScreen());
              //   },
              //   child: Padding(
              //     padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
              //     child: Text(
              //       'Sign Out',
              //       style: TextStyle(
              //         fontSize: 20,
              //         fontWeight: FontWeight.bold,
              //         color: Colors.white,
              //         letterSpacing: 2,
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
      floatingActionButton: _isSigningOut
          ? CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      )
          : ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
            Colors.redAccent,
          ),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        onPressed: () async {
          setState(() {
            _isSigningOut = true;
          });
          await Authentication.signOut(context: context);
          setState(() {
            _isSigningOut = false;
          });
          Navigator.of(context).popUntil((route) => route.isFirst);
          Navigator.of(context).pushReplacement(_routeToSignInScreen());
        },
        child: Padding(
          padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
          child: Text(
            'Sign Out',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 2,
            ),
          ),
        ),
      ),
    ),key:scaffoldMessengerKey);
  }
}