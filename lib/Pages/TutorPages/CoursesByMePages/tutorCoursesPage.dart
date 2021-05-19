import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'addCoursesPage.dart';


class TutorCoursesPage extends StatefulWidget {
  final BuildContext mainScreenContext;
  final bool hideStatus;
  final GlobalKey<ScaffoldState> scaffoldKey;
  const TutorCoursesPage({ Key key,this.mainScreenContext,this.hideStatus,this.scaffoldKey}) : super(key: key);
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
        title: Text("Courses By Me"),
        leading: IconButton(icon:Icon(Icons.menu),onPressed: (){widget.scaffoldKey.currentState.openDrawer();},),),
      body: Center(
        child: Text("Coming Soon..."),
      ),
      floatingActionButton: FloatingActionButton.extended(onPressed: (){
        Navigator.of(context).push(CupertinoPageRoute(builder: (context)=>AddCoursesPage()));
      },
        label: Text("Add Course"),icon: Icon(Icons.add),),
    );
  }
}