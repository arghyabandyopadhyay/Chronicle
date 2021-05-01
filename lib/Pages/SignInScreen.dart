import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:chronicle/Modules/sharedPreferenceHandler.dart';
import 'package:chronicle/Pages/clientPage.dart';
import 'package:chronicle/Pages/globalClass.dart';
import 'package:chronicle/Widgets/googleSignInButton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import '../Modules/database.dart';
import '../customColors.dart';
import 'idBlockedPage.dart';
import 'myHomePage.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}
class _SignInScreenState extends State<SignInScreen> {
  GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey=GlobalKey<ScaffoldMessengerState>();
  PickedFile _imageFile;
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
            GlobalClass.lastRegister=lastRegister,
            if(lastRegister==null||lastRegister=="")
              {
                widget=MaterialApp(
                    title: 'Chronicle',
                    debugShowCheckedModeBanner: false,
                    theme: lightThemeData,
                    darkTheme: darkThemeData,
                    themeMode: ThemeMode.system,
                    home: MyHomePage())
              }
            else {
                await getAllRegisters().then((registers) => {
                    GlobalClass.registerList = registers,
                    // sendNotifications(scaffoldMessengerKey,GlobalClass.userDetail.messageString),
                  widget=MaterialApp(
                    title: 'Chronicle',
                    debugShowCheckedModeBanner: false,
                    theme: lightThemeData,
                    darkTheme: darkThemeData,
                    themeMode: ThemeMode.system,
                    home: ClientPage(registers.where((element) => element.id.key==lastRegister).first))
                })
            }
          })
          }
        else{
          widget= MaterialApp(
          title: 'Chronicle',
          debugShowCheckedModeBanner: false,
          theme: lightThemeData,
          darkTheme: darkThemeData,
          themeMode: ThemeMode.system,
          home: IdBlockedPage())
        }
      });
    }
    else {
      widget= MaterialApp(
          title: 'Chronicle',
          debugShowCheckedModeBanner: false,
          theme: lightThemeData,
          darkTheme: darkThemeData,
          themeMode: ThemeMode.system,
          home: ScaffoldMessenger(key: scaffoldMessengerKey,child: Scaffold(body: SafeArea(
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
          ),),));
    }
    return widget;
  }

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Chronicle',
        debugShowCheckedModeBanner: false,
        theme: lightThemeData,
        darkTheme: darkThemeData,
        themeMode: ThemeMode.system,
        home: AnimatedSplashScreen.withScreenFunction(
      splash: 'assets/firebase_logo.png',
      screenFunction: getWidget,
      splashTransition: SplashTransition.fadeTransition,
      pageTransitionType: PageTransitionType.rightToLeft,
      backgroundColor: CustomColors.primaryColor,
      animationDuration: Duration(milliseconds: 1500),
      splashIconSize: double.maxFinite,
    ));
  }
}