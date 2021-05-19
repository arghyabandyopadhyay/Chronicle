import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:chronicle/Models/registerIndexModel.dart';
import 'package:chronicle/Modules/sharedPreferenceHandler.dart';
import 'package:chronicle/globalClass.dart';
import 'package:chronicle/Widgets/googleSignInButton.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import '../Modules/database.dart';
import '../customColors.dart';
import 'MasterPages/chronicleMasterPage.dart';
import 'errorDisplayPage.dart';
import 'TutorPages/registersPage.dart';

class RoutingPage extends StatefulWidget {
  @override
  _RoutingPageState createState() => _RoutingPageState();
}
class _RoutingPageState extends State<RoutingPage> {
  GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey=GlobalKey<ScaffoldMessengerState>();
  Future<Widget> getWidget()async{
    Widget widget;
    List<RegisterIndexModel> lastRegisterModels;
    // initiateDatabase();
    Connectivity connectivity=Connectivity();
    await connectivity.checkConnectivity().then((value)async => {
      if(value!=ConnectivityResult.none)
        {
          GlobalClass.user = FirebaseAuth.instance.currentUser,
          if(GlobalClass.user!=null){
            await addUserDetail().then((value)async=>{
              if(value!=null){
                if(GlobalClass.userDetail.isOwner==1||GlobalClass.userDetail.isAppRegistered==1) await getLastRegister().then((lastRegister) async => {
                  GlobalClass.lastRegister=lastRegister,
                  if(lastRegister==null||lastRegister=="")
                    {
                      widget=MaterialApp(
                          title: 'Chronicle',
                          debugShowCheckedModeBanner: false,
                          theme: lightThemeData,
                          darkTheme: darkThemeData,
                          themeMode: ThemeMode.system,
                          home: RegistersPage())
                    }
                  else {
                    await getAllRegisterIndex().then((registers) => {
                      GlobalClass.registerList = registers,
                      lastRegisterModels=registers.where((element) => element.id.key==lastRegister).toList(),
                      // sendNotifications(scaffoldMessengerKey,GlobalClass.userDetail.messageString),
                      if(lastRegisterModels!=null&&lastRegisterModels.length>0)widget=MaterialApp(
                          title: 'Chronicle',
                          debugShowCheckedModeBanner: false,
                          theme: lightThemeData,
                          darkTheme: darkThemeData,
                          themeMode: ThemeMode.system,
                          home: ChronicleMasterPage(register:lastRegisterModels.first,isTutor: true))
                      else widget=MaterialApp(
                          title: 'Chronicle',
                          debugShowCheckedModeBanner: false,
                          theme: lightThemeData,
                          darkTheme: darkThemeData,
                          themeMode: ThemeMode.system,
                          home: RegistersPage())
                    })
                  }
                })
                else{
                  widget= MaterialApp(
                      title: 'Chronicle',
                      debugShowCheckedModeBanner: false,
                      theme: lightThemeData,
                      darkTheme: darkThemeData,
                      themeMode: ThemeMode.system,
                      home: ChronicleMasterPage(isTutor: false,))
                }
              }
              else{
                widget= MaterialApp(
                    title: 'Chronicle',
                    debugShowCheckedModeBanner: false,
                    theme: lightThemeData,
                    darkTheme: darkThemeData,
                    themeMode: ThemeMode.system,
                    home: ErrorDisplayPage(appBarText: "Id Blocked",asset: "idBlocked.jpg",message: 'Please contact System Administrator',))
              }
            })
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
                ),),))
          }
        }
      else{
        widget= MaterialApp(
            title: 'Chronicle',
            debugShowCheckedModeBanner: false,
            theme: lightThemeData,
            darkTheme: darkThemeData,
            themeMode: ThemeMode.system,
            home: ErrorDisplayPage(appBarText: "No Internet Connection",asset: "NoInternetError.webp",message: 'Please connect to the Internet!!',))
      }
    });


    // GlobalClass.user = FirebaseAuth.instance.currentUser;
    // if(GlobalClass.user!=null){
    //   await addUserDetail().then((value)async=>{
    //     if(value!=null){
    //       await getLastRegister().then((lastRegister) async => {
    //         GlobalClass.lastRegister=lastRegister,
    //         if(lastRegister==null||lastRegister=="")
    //           {
    //             widget=MaterialApp(
    //                 title: 'Chronicle',
    //                 debugShowCheckedModeBanner: false,
    //                 theme: lightThemeData,
    //                 darkTheme: darkThemeData,
    //                 themeMode: ThemeMode.system,
    //                 home: RegistersPage())
    //           }
    //         else {
    //             await getAllRegisterIndex().then((registers) => {
    //                 GlobalClass.registerList = registers,
    //               lastRegisterModels=registers.where((element) => element.id.key==lastRegister).toList(),
    //                 // sendNotifications(scaffoldMessengerKey,GlobalClass.userDetail.messageString),
    //               if(lastRegisterModels!=null&&lastRegisterModels.length>0)widget=MaterialApp(
    //                   title: 'Chronicle',
    //                   debugShowCheckedModeBanner: false,
    //                   theme: lightThemeData,
    //                   darkTheme: darkThemeData,
    //                   themeMode: ThemeMode.system,
    //                   home: ClientPage(lastRegisterModels.first))
    //               else widget=MaterialApp(
    //                   title: 'Chronicle',
    //                   debugShowCheckedModeBanner: false,
    //                   theme: lightThemeData,
    //                   darkTheme: darkThemeData,
    //                   themeMode: ThemeMode.system,
    //                   home: RegistersPage())
    //             })
    //         }
    //       })
    //       }
    //     else{
    //       widget= MaterialApp(
    //       title: 'Chronicle',
    //       debugShowCheckedModeBanner: false,
    //       theme: lightThemeData,
    //       darkTheme: darkThemeData,
    //       themeMode: ThemeMode.system,
    //       home: ErrorDisplayPage(appBarText: "Id Blocked",asset: "idBlocked.jpg",message: 'Please contact System Administrator',))
    //     }
    //   });
    // }
    // else {
    //   widget= MaterialApp(
    //       title: 'Chronicle',
    //       debugShowCheckedModeBanner: false,
    //       theme: lightThemeData,
    //       darkTheme: darkThemeData,
    //       themeMode: ThemeMode.system,
    //       home: ScaffoldMessenger(key: scaffoldMessengerKey,child: Scaffold(body: SafeArea(
    //         child: Padding(
    //           padding: const EdgeInsets.only(
    //             left: 16.0,
    //             right: 16.0,
    //             bottom: 20.0,
    //           ),
    //           child: Column(
    //             mainAxisSize: MainAxisSize.max,
    //             children: [
    //               Row(),
    //               Expanded(
    //                 child: Column(
    //                   mainAxisSize: MainAxisSize.min,
    //                   mainAxisAlignment: MainAxisAlignment.center,
    //                   children: [
    //                     Flexible(
    //                       child: Image.asset(
    //                         'assets/firebase_logo.png',
    //                         // height: 400,
    //                       ),
    //                     ),
    //                     SizedBox(height: 20),
    //                     // Text(
    //                     //   'Chronicle',
    //                     //   style: TextStyle(
    //                     //     color: CustomColors.firebaseYellow,
    //                     //     fontSize: 40,
    //                     //   ),
    //                     // ),
    //                     // Text(
    //                     //   'Authentication',
    //                     //   style: TextStyle(
    //                     //     color: CustomColors.firebaseBlue,
    //                     //     fontSize: 40,
    //                     //   ),
    //                     // ),
    //                   ],
    //                 ),
    //               ),
    //               GoogleSignInButton(scaffoldMessengerKey: scaffoldMessengerKey,)
    //             ],
    //           ),
    //         ),
    //       ),),));
    // }

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