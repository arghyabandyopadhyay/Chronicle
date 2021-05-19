import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class SearchCoursesPage extends StatefulWidget {
  final BuildContext mainScreenContext;
  final bool hideStatus;
  final GlobalKey<ScaffoldState> scaffoldKey;
  const SearchCoursesPage({ Key key,this.mainScreenContext,this.hideStatus,this.scaffoldKey}) : super(key: key);
  @override
  _SearchCoursesPageState createState() => _SearchCoursesPageState();
}
class _SearchCoursesPageState extends State<SearchCoursesPage> {
  GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey=GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search"),
        leading: IconButton(icon:Icon(Icons.menu),onPressed: (){widget.scaffoldKey.currentState.openDrawer();},),),
      body: Center(
        child: Text("Coming Soon..."),
      ),
    );
  }
}