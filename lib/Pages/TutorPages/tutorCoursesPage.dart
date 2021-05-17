import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class TutorCoursesPage extends StatefulWidget {
  const TutorCoursesPage({ Key key}) : super(key: key);
  @override
  _TutorCoursesPageState createState() => _TutorCoursesPageState();
}
class _TutorCoursesPageState extends State<TutorCoursesPage> {
  GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey=GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Courses"),),
      body: Center(
        child: Text("Coming soon..."),
      ),
    );
  }
}