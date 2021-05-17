import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class CoursesPage extends StatefulWidget {
  final BuildContext menuScreenContext;
  final bool hideStatus;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey;
  const CoursesPage({ Key key,this.menuScreenContext,this.hideStatus,this.scaffoldKey,this.scaffoldMessengerKey}) : super(key: key);
  @override
  _CoursesPageState createState() => _CoursesPageState();
}
class _CoursesPageState extends State<CoursesPage> {
  GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey=GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Courses"),
        leading: IconButton(icon:Icon(Icons.menu),onPressed: (){widget.scaffoldKey.currentState.openDrawer();},),),
      body: Center(
        child: Text("Coming Soon..."),
      ),
    );
  }
}