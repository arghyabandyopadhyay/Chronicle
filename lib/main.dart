import 'package:chronicle/Models/userModel.dart';
import 'package:chronicle/Modules/database.dart';
import 'package:chronicle/Pages/notificationsPage.dart';
import 'package:chronicle/temp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shimmer/shimmer.dart';
import 'Models/receivedNotificationModel.dart';
import 'Modules/auth.dart';
import 'Pages/SignInScreen.dart';
import 'Pages/globalClass.dart';
import 'Pages/idBlockedPage.dart';
import 'Pages/myHomePage.dart';
import 'Widgets/googleSignInButton.dart';
import 'customColors.dart';
import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'message.dart';
import 'message_list.dart';
import 'permissions.dart';
import 'token_monitor.dart';

/// Define a top-level named handler which background/terminated messages will
/// call.
///
/// To verify things are working, check out the native platform logs.
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  debugPrint('Handling a background message ${message.messageId}');
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
final BehaviorSubject<ReceivedNotificationModel> didReceiveLocalNotificationSubject =BehaviorSubject<ReceivedNotificationModel>();
final BehaviorSubject<String> selectNotificationSubject =
BehaviorSubject<String>();
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');

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
        if (payload != null) {
        }
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
  runApp(MyApp());
}
class Chronicle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chronicle',
      debugShowCheckedModeBanner: false,
      theme: lightThemeData,
      darkTheme: darkThemeData,
      themeMode: ThemeMode.system,
      initialRoute: '/',
      routes: {
        '/': (context) => MyApp(),
        '/message': (context) => NotificationsPage(),
      },
    );
  }
}
class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);
  @override
  _AppState createState() => _AppState();
}
class _AppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>(debugLabel:"navigator");
  bool _requested = false;
  bool _fetching = false;
  NotificationSettings _settings;

  Stream<String> _tokenStream;

  Future<void> setToken(String token) {
    GlobalClass.applicationToken = token;
    if(GlobalClass.user!=null)getUserDetails().then((value) => {
      value.token=token,
      updateUserDetails(value, value.id)
    });
  }
  Future<void> onActionSelected(String value) async {
    switch (value) {
      case 'subscribe':
        {
          debugPrint(
              'FlutterFire Messaging Example: Subscribing to topic "fcm_test".');
          await FirebaseMessaging.instance.subscribeToTopic('fcm_test');
          debugPrint(
              'FlutterFire Messaging Example: Subscribing to topic "fcm_test" successful.');
        }
        break;
      case 'unsubscribe':
        {
          debugPrint(
              'FlutterFire Messaging Example: Unsubscribing from topic "fcm_test".');
          await FirebaseMessaging.instance.unsubscribeFromTopic('fcm_test');
          debugPrint(
              'FlutterFire Messaging Example: Unsubscribing from topic "fcm_test" successful.');
        }
        break;
      case 'get_apns_token':
        {
          if (defaultTargetPlatform == TargetPlatform.iOS ||
              defaultTargetPlatform == TargetPlatform.macOS) {
            debugPrint('FlutterFire Messaging Example: Getting APNs token...');
            String token = await FirebaseMessaging.instance.getAPNSToken();
            debugPrint('FlutterFire Messaging Example: Got APNs token: $token');
          } else {
            debugPrint(
                'FlutterFire Messaging Example: Getting an APNs token is only supported on iOS and macOS platforms.');
          }
        }
        break;
      default:
        break;
    }
  }

  Future<void> requestPermissions() async {
    NotificationSettings settings =
    await FirebaseMessaging.instance.requestPermission(
      announcement: true,
      carPlay: true,
      criticalAlert: true,
    );
    _settings = settings;
  }
  void _configureDidReceiveLocalNotificationSubject() {
    didReceiveLocalNotificationSubject.stream
        .listen((ReceivedNotificationModel receivedNotification) async {
      debugPrint("didReceiveLocalNotificationSubject");
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
                navigatorKey.currentState.push(CupertinoPageRoute(builder: (context)=>NotificationsPage()));
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
      debugPrint("selectNotificationSubject");
      navigatorKey.currentState.push(CupertinoPageRoute(builder: (context)=>NotificationsPage()));
    });
  }
  @override
  void initState() {
    super.initState();
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage message) {
      if (message != null) {
        navigatorKey.currentState.push(CupertinoPageRoute(builder: (context)=>NotificationsPage()));
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
                icon: '@mipmap/ic_launcher',
              ),
            ));
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('A new onMessageOpenedApp event was published!');
      navigatorKey.currentState.push(CupertinoPageRoute(builder: (context)=>NotificationsPage()));
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
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Chronicle',
      debugShowCheckedModeBanner: false,
      theme: lightThemeData,
      darkTheme: darkThemeData,
      themeMode: ThemeMode.system,
      home: SignInScreen(),
    );
  }
}

