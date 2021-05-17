import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class TutorTestsPage extends StatefulWidget {
  const TutorTestsPage({ Key key}) : super(key: key);
  @override
  _TutorTestsPageState createState() => _TutorTestsPageState();
}
class _TutorTestsPageState extends State<TutorTestsPage> {
  GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey=GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tests"),),
      body: Center(
        child: Text("Coming soon..."),
      ),
    );
  }
}