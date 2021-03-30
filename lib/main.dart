// import 'package:flutter/material.dart';
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         // This is the theme of your application.
//         //
//         // Try running your application with "flutter run". You'll see the
//         // application has a blue toolbar. Then, without quitting the app, try
//         // changing the primarySwatch below to Colors.green and then invoke
//         // "hot reload" (press "r" in the console where you ran "flutter run",
//         // or simply save your changes to "hot reload" in a Flutter IDE).
//         // Notice that the counter didn't reset back to zero; the application
//         // is not restarted.
//         primarySwatch: Colors.blue,
//         // This makes the visual density adapt to the platform that you run
//         // the app on. For desktop platforms, the controls will be smaller and
//         // closer together (more dense) than on mobile platforms.
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: MyHomePage(title: 'Flutter Demo Home Page'),
//     );
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key key, this.title}) : super(key: key);
//
//   // This widget is the home page of your application. It is stateful, meaning
//   // that it has a State object (defined below) that contains fields that affect
//   // how it looks.
//
//   // This class is the configuration for the state. It holds the values (in this
//   // case the title) provided by the parent (in this case the App widget) and
//   // used by the build method of the State. Fields in a Widget subclass are
//   // always marked "final".
//
//   final String title;
//
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;
//
//   void _incrementCounter() {
//     setState(() {
//       // This call to setState tells the Flutter framework that something has
//       // changed in this State, which causes it to rerun the build method below
//       // so that the display can reflect the updated values. If we changed
//       // _counter without calling setState(), then the build method would not be
//       // called again, and so nothing would appear to happen.
//       _counter++;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // This method is rerun every time setState is called, for instance as done
//     // by the _incrementCounter method above.
//     //
//     // The Flutter framework has been optimized to make rerunning build methods
//     // fast, so that you can just rebuild anything that needs updating rather
//     // than having to individually change instances of widgets.
//     return Scaffold(
//       appBar: AppBar(
//         // Here we take the value from the MyHomePage object that was created by
//         // the App.build method, and use it to set our appbar title.
//         title: Text(widget.title),
//       ),
//       body: Center(
//         // Center is a layout widget. It takes a single child and positions it
//         // in the middle of the parent.
//         child: Column(
//           // Column is also a layout widget. It takes a list of children and
//           // arranges them vertically. By default, it sizes itself to fit its
//           // children horizontally, and tries to be as tall as its parent.
//           //
//           // Invoke "debug painting" (press "p" in the console, choose the
//           // "Toggle Debug Paint" action from the Flutter Inspector in Android
//           // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
//           // to see the wireframe for each widget.
//           //
//           // Column has various properties to control how it sizes itself and
//           // how it positions its children. Here we use mainAxisAlignment to
//           // center the children vertically; the main axis here is the vertical
//           // axis because Columns are vertical (the cross axis would be
//           // horizontal).
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text(
//               'You have pushed the button this many times:',
//             ),
//             Text(
//               '$_counter',
//               style: Theme.of(context).textTheme.headline4,
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: 'Increment',
//         child: Icon(Icons.add),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }
// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// @dart=2.9

// import 'dart:async';
// import 'dart:io' show Platform;
//
// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:firebase_database/ui/firebase_animated_list.dart';
//
// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   final FirebaseApp app = await Firebase.initializeApp(
//     name: 'db2',
//     options: Platform.isIOS || Platform.isMacOS
//         ? FirebaseOptions(
//       appId: '1:297855924061:ios:c6de2b69b03a5be8',
//       apiKey: 'AIzaSyD_shO5mfO9lhy2TVWhfo1VUmARKlG4suk',
//       projectId: 'flutter-firebase-plugins',
//       messagingSenderId: '297855924061',
//       databaseURL: 'https://flutterfire-cd2f7.firebaseio.com',
//     )
//         : FirebaseOptions(
//       appId: '1:297855924061:android:669871c998cc21bd',
//       apiKey: 'AIzaSyD_shO5mfO9lhy2TVWhfo1VUmARKlG4suk',
//       messagingSenderId: '297855924061',
//       projectId: 'flutter-firebase-plugins',
//       databaseURL: 'https://flutterfire-cd2f7.firebaseio.com',
//     ),
//   );
//   runApp(MaterialApp(
//     title: 'Flutter Database Example',
//     home: MyHomePage(app: app),
//   ));
// }
//
// class MyHomePage extends StatefulWidget {
//   MyHomePage({this.app});
//   final FirebaseApp app;
//
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   int _counter;
//   DatabaseReference _counterRef;
//   DatabaseReference _messagesRef;
//   StreamSubscription<Event> _counterSubscription;
//   StreamSubscription<Event> _messagesSubscription;
//   bool _anchorToBottom = false;
//
//   String _kTestKey = 'Hello';
//   String _kTestValue = 'world!';
//   DatabaseError _error;
//
//   @override
//   void initState() {
//     super.initState();
//     // Demonstrates configuring to the database using a file
//     _counterRef = FirebaseDatabase.instance.reference().child('counter');
//     // Demonstrates configuring the database directly
//     final FirebaseDatabase database = FirebaseDatabase(app: widget.app);
//     _messagesRef = database.reference().child('messages');
//     database.reference().child('counter').once().then((DataSnapshot snapshot) {
//       print('Connected to second database and read ${snapshot.value}');
//     });
//     database.setPersistenceEnabled(true);
//     database.setPersistenceCacheSizeBytes(10000000);
//     _counterRef.keepSynced(true);
//     _counterSubscription = _counterRef.onValue.listen((Event event) {
//       setState(() {
//         _error = null;
//         _counter = event.snapshot.value ?? 0;
//       });
//     }, onError: (Object o) {
//       final DatabaseError error = o;
//       setState(() {
//         _error = error;
//       });
//     });
//     _messagesSubscription =
//         _messagesRef.limitToLast(10).onChildAdded.listen((Event event) {
//           print('Child added: ${event.snapshot.value}');
//         }, onError: (Object o) {
//           final DatabaseError error = o;
//           print('Error: ${error.code} ${error.message}');
//         });
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     _messagesSubscription.cancel();
//     _counterSubscription.cancel();
//   }
//
//   Future<void> _increment() async {
//     // Increment counter in transaction.
//     final TransactionResult transactionResult =
//     await _counterRef.runTransaction((MutableData mutableData) async {
//       mutableData.value = (mutableData.value ?? 0) + 1;
//       return mutableData;
//     });
//
//     if (transactionResult.committed) {
//       _messagesRef.push().set(<String, String>{
//         _kTestKey: '$_kTestValue ${transactionResult.dataSnapshot.value}'
//       });
//     } else {
//       print('Transaction not committed.');
//       if (transactionResult.error != null) {
//         print(transactionResult.error.message);
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Flutter Database Example'),
//       ),
//       body: Column(
//         children: <Widget>[
//           Flexible(
//             child: Center(
//               child: _error == null
//                   ? Text(
//                 'Button tapped $_counter time${_counter == 1 ? '' : 's'}.\n\n'
//                     'This includes all devices, ever.',
//               )
//                   : Text(
//                 'Error retrieving button tap count:\n${_error.message}',
//               ),
//             ),
//           ),
//           ListTile(
//             leading: Checkbox(
//               onChanged: (bool value) {
//                 setState(() {
//                   _anchorToBottom = value;
//                 });
//               },
//               value: _anchorToBottom,
//             ),
//             title: const Text('Anchor to bottom'),
//           ),
//           Flexible(
//             child: FirebaseAnimatedList(
//               key: ValueKey<bool>(_anchorToBottom),
//               query: _messagesRef,
//               reverse: _anchorToBottom,
//               sort: _anchorToBottom
//                   ? (DataSnapshot a, DataSnapshot b) => b.key.compareTo(a.key)
//                   : null,
//               itemBuilder: (BuildContext context, DataSnapshot snapshot,
//                   Animation<double> animation, int index) {
//                 return SizeTransition(
//                   sizeFactor: animation,
//                   child: ListTile(
//                     trailing: IconButton(
//                       onPressed: () =>
//                           _messagesRef.child(snapshot.key).remove(),
//                       icon: Icon(Icons.delete),
//                     ),
//                     title: Text(
//                       "$index: ${snapshot.value.toString()}",
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _increment,
//         tooltip: 'Increment',
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
//}

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:Chronicle/login.dart';
import 'package:flutter/services.dart';

import 'Pages/SignInScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    // return FutureBuilder(
    //   // Initialize FlutterFire
    //   future: Firebase.initializeApp(),
    //   builder: (context, snapshot) {
    //     // Check for errors
    //     if (snapshot.hasError) {
    //       return MaterialApp(
    //         title: 'Chronicle',
    //         theme: ThemeData(
    //           primarySwatch: Colors.orange,
    //           visualDensity: VisualDensity.adaptivePlatformDensity,
    //         ),
    //         home: LoginPage(),
    //       );
    //     }
    //
    //     // Once complete, show your application
    //     if (snapshot.connectionState == ConnectionState.done) {
    //       return MaterialApp(
    //         title: 'Chronicle',
    //         theme: ThemeData(
    //           primarySwatch: Colors.orange,
    //           visualDensity: VisualDensity.adaptivePlatformDensity,
    //         ),
    //         home: LoginPage(),
    //       );
    //     }
    //
    //     // Otherwise, show something whilst waiting for initialization to complete
    //     return MaterialApp(
    //       title: 'Chronicle',
    //       theme: ThemeData(
    //         primarySwatch: Colors.orange,
    //         visualDensity: VisualDensity.adaptivePlatformDensity,
    //       ),
    //       home: LoginPage(),
    //     );
    //   },
    // );

    return MaterialApp(
      title: 'FlutterFire Samples',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        brightness: Brightness.dark,
      ),
      home: SignInScreen(),
    );
  }
}
