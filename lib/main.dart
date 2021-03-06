import 'dart:io';

import 'package:chronicle/Models/token_model.dart';
import 'package:chronicle/Modules/database.dart';
import 'package:chronicle/Pages/notificationsPage.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';
import 'Models/received_notification_model.dart';
import 'Modules/auth.dart';
import 'Pages/routingPage.dart';
import 'global_class.dart';
import 'Pages/errorDisplayPage.dart';
import 'custom_colors.dart';
import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Define a top-level named handler which background/terminated messages will
/// call.
///
/// To verify things are working, check out the native platform logs.
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
}

/// Create a [AndroidNotificationChannel] for heads up notifications
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  'This channel is used for important notifications.', // description
  importance: Importance.high,
);
String selectedNotificationPayload;

/// Initialize the [FlutterLocalNotificationsPlugin] package.
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
final BehaviorSubject<ReceivedNotificationModel>
    didReceiveLocalNotificationSubject =
    BehaviorSubject<ReceivedNotificationModel>();
final BehaviorSubject<String> selectNotificationSubject =
    BehaviorSubject<String>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@drawable/notificationicon');

  /// Note: permissions aren't requested here just to demonstrate that can be
  /// done later
  final IOSInitializationSettings initializationSettingsIOS =
      IOSInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
          onDidReceiveLocalNotification:
              (int id, String title, String body, String payload) async {
            didReceiveLocalNotificationSubject.add(ReceivedNotificationModel(
                id: id, title: title, body: body, payload: payload));
          });
  const MacOSInitializationSettings initializationSettingsMacOS =
      MacOSInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false);
  final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
      macOS: initializationSettingsMacOS);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String payload) async {
    if (payload != null) {}
    selectedNotificationPayload = payload;
    selectNotificationSubject.add(payload);
  });
  // Set the background messaging handler early on, as a named top-level function
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  /// Create an Android Notification Channel.
  ///
  /// We use this channel in the `AndroidManifest.xml` file to override the
  /// default FCM channel to enable heads up notifications.
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  runApp(Chronicle());
}

class Chronicle extends StatefulWidget {
  const Chronicle({Key key}) : super(key: key);
  @override
  _ChronicleState createState() => _ChronicleState();
}

class _ChronicleState extends State<Chronicle> {
  final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>(debugLabel: "navigator");
  Stream<String> _tokenStream;
  void setToken(String token) async {
    bool foundDeviceHistory = false;
    GlobalClass.user = FirebaseAuth.instance.currentUser;
    if (Platform.isAndroid) {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      GlobalClass.applicationToken = token;
      if (GlobalClass.user != null)
        getUserDetails().then((value) => {
              if (value.tokens == null)
                {
                  addToken(
                      value,
                      TokenModel(
                          token: token,
                          deviceId: androidInfo.androidId,
                          deviceModel: androidInfo.model))
                }
              else
                {
                  value.tokens.forEach((element) {
                    if (element.deviceId == androidInfo.androidId) {
                      if (element.token != token) {
                        element.token = token;
                        updateToken(element);
                      }
                      foundDeviceHistory = true;
                    }
                  }),
                  if (!foundDeviceHistory)
                    addToken(
                        value,
                        TokenModel(
                            token: token,
                            deviceId: androidInfo.androidId,
                            deviceModel: androidInfo.model))
                },
            });
    } else if (Platform.isIOS) {
      // request permissions if we're on android
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      GlobalClass.applicationToken = token;
      if (GlobalClass.user != null)
        getUserDetails().then((value) => {
              if (value.tokens == null)
                {
                  addToken(
                      value,
                      TokenModel(
                          token: token,
                          deviceId: iosInfo.identifierForVendor,
                          deviceModel: iosInfo.model))
                }
              else
                {
                  value.tokens.forEach((element) {
                    if (element.deviceId == iosInfo.identifierForVendor) {
                      if (element.token != token) {
                        element.token = token;
                        updateToken(element);
                      }
                      foundDeviceHistory = true;
                    }
                  }),
                  if (!foundDeviceHistory)
                    addToken(
                        value,
                        TokenModel(
                            token: token,
                            deviceId: iosInfo.identifierForVendor,
                            deviceModel: iosInfo.model))
                },
            });
    }
  }

  Future<void> requestPermissions() async {
    // NotificationSettings settings =
    await FirebaseMessaging.instance.requestPermission(
      announcement: true,
      carPlay: true,
      criticalAlert: true,
    );
  }

  void _configureDidReceiveLocalNotificationSubject() {
    didReceiveLocalNotificationSubject.stream
        .listen((ReceivedNotificationModel receivedNotification) async {
      await showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: receivedNotification.title != null
              ? Text(receivedNotification.title)
              : null,
          content: receivedNotification.body != null
              ? Text(receivedNotification.body)
              : null,
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () async {
                Navigator.of(context, rootNavigator: true).pop();
                navigatorKey.currentState.push(CupertinoPageRoute(
                    builder: (context) => NotificationsPage()));
              },
              child: const Text('Ok'),
            )
          ],
        ),
      );
    });
  }

  void _configureSelectNotificationSubject() {
    selectNotificationSubject.stream.listen((String payload) async {
      navigatorKey.currentState
          .push(CupertinoPageRoute(builder: (context) => NotificationsPage()));
    });
  }

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage message) {
      if (message != null) {
        navigatorKey.currentState.push(
            CupertinoPageRoute(builder: (context) => NotificationsPage()));
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channel.description,
                icon: '@drawable/notificationicon',
              ),
            ));
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      navigatorKey.currentState
          .push(CupertinoPageRoute(builder: (context) => NotificationsPage()));
    });
    FirebaseMessaging.instance.getToken().then(setToken);
    _tokenStream = FirebaseMessaging.instance.onTokenRefresh;
    _tokenStream.listen(setToken);
    requestPermissions();
    _configureDidReceiveLocalNotificationSubject();
    _configureSelectNotificationSubject();
  }

  @override
  void dispose() {
    didReceiveLocalNotificationSubject.close();
    selectNotificationSubject.close();
    super.dispose();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return MaterialApp(
        navigatorKey: navigatorKey,
        title: 'Chronicle',
        debugShowCheckedModeBanner: false,
        theme: lightThemeData,
        darkTheme: darkThemeData,
        themeMode: ThemeMode.system,
        home: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: CustomColors.primaryColor,
          body: FutureBuilder(
              future: Authentication.initializeFirebase(context: context),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return ErrorDisplayPage(
                    appBarText: "Error 404",
                    asset: "errorHasOccured.jpg",
                    message: 'Please contact System Administrator',
                  );
                } else if (snapshot.connectionState == ConnectionState.done) {
                  return RoutingPage();
                }
                // return Scaffold(
                //     appBar: AppBar(title: Text("Chronicle"),elevation: 0,leading: Icon(Icons.menu),),
                //     body: Container(
                //         width: double.infinity,
                //         padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                //         child: Column(
                //           mainAxisSize: MainAxisSize.max,
                //           children: <Widget>[
                //             Expanded(
                //               child: Shimmer.fromColors(
                //                   baseColor: Colors.white,
                //                   highlightColor: Colors.grey.withOpacity(0.5),
                //                   enabled: true,
                //                   child: ListView.builder(
                //                     itemBuilder: (_, __) => Padding(
                //                       padding: const EdgeInsets.only(bottom: 8.0),
                //                       child: Row(
                //                         crossAxisAlignment: CrossAxisAlignment.start,
                //                         children: [
                //                           Container(
                //                             width: 48.0,
                //                             height: 48.0,
                //                             color: Colors.white,
                //                           ),
                //                           const Padding(
                //                             padding: EdgeInsets.symmetric(horizontal: 8.0),
                //                           ),
                //                           Expanded(
                //                             child: Column(
                //                               crossAxisAlignment: CrossAxisAlignment.start,
                //                               children: <Widget>[
                //                                 Container(
                //                                   width: double.infinity,
                //                                   height: 8.0,
                //                                   color: Colors.white,
                //                                 ),
                //                                 const Padding(
                //                                   padding: EdgeInsets.symmetric(vertical: 2.0),
                //                                 ),
                //                                 Container(
                //                                   width: double.infinity,
                //                                   height: 8.0,
                //                                   color: Colors.white,
                //                                 ),
                //                                 const Padding(
                //                                   padding: EdgeInsets.symmetric(vertical: 2.0),
                //                                 ),
                //                                 Container(
                //                                   width: 40.0,
                //                                   height: 8.0,
                //                                   color: Colors.white,
                //                                 ),
                //                               ],
                //                             ),
                //                           )
                //                         ],
                //                       ),
                //                     ),
                //                     itemCount: 4,
                //                   )
                //               ),
                //             ),
                //           ],
                //         )
                //     ));
                return Container(height: 0, width: 0);
              }),
        ));
  }
}

//AnimatedSplashScreen(
//           splash: Image.asset("assets/firebase_logo.png"),
//           nextScreen: Scaffold(
//             body:FutureBuilder(
//                 future: Authentication.initializeFirebase(context: context),
//                 builder: (context, snapshot) {
//                   if (snapshot.hasError) {
//                     return IdBlockedPage();
//                   }
//                   else if (snapshot.connectionState == ConnectionState.done) {
//                     return RoutingPage();
//                   }
//                   return Scaffold(
//                       appBar: AppBar(title: Text("Chronicle"),elevation: 0,leading: Icon(Icons.menu),),
//                       body: Container(
//                           width: double.infinity,
//                           padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
//                           child: Column(
//                             mainAxisSize: MainAxisSize.max,
//                             children: <Widget>[
//                               Expanded(
//                                 child: Shimmer.fromColors(
//                                     baseColor: Colors.white,
//                                     highlightColor: Colors.grey.withOpacity(0.5),
//                                     enabled: true,
//                                     child: ListView.builder(
//                                       itemBuilder: (_, __) => Padding(
//                                         padding: const EdgeInsets.only(bottom: 8.0),
//                                         child: Row(
//                                           crossAxisAlignment: CrossAxisAlignment.start,
//                                           children: [
//                                             Container(
//                                               width: 48.0,
//                                               height: 48.0,
//                                               color: Colors.white,
//                                             ),
//                                             const Padding(
//                                               padding: EdgeInsets.symmetric(horizontal: 8.0),
//                                             ),
//                                             Expanded(
//                                               child: Column(
//                                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                                 children: <Widget>[
//                                                   Container(
//                                                     width: double.infinity,
//                                                     height: 8.0,
//                                                     color: Colors.white,
//                                                   ),
//                                                   const Padding(
//                                                     padding: EdgeInsets.symmetric(vertical: 2.0),
//                                                   ),
//                                                   Container(
//                                                     width: double.infinity,
//                                                     height: 8.0,
//                                                     color: Colors.white,
//                                                   ),
//                                                   const Padding(
//                                                     padding: EdgeInsets.symmetric(vertical: 2.0),
//                                                   ),
//                                                   Container(
//                                                     width: 40.0,
//                                                     height: 8.0,
//                                                     color: Colors.white,
//                                                   ),
//                                                 ],
//                                               ),
//                                             )
//                                           ],
//                                         ),
//                                       ),
//                                       itemCount: 4,
//                                     )
//                                 ),
//                               ),
//                             ],
//                           )
//                       ));
//                 }
//             ),
//           ),
//           splashTransition: SplashTransition.fadeTransition,
//           pageTransitionType: PageTransitionType.rightToLeft,
//           backgroundColor: CustomColors.primaryColor,
//           animationDuration: Duration(milliseconds: 1000),
//           splashIconSize: 300,
//       )
