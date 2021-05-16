import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class TestsPage extends StatefulWidget {
  final BuildContext menuScreenContext;
  final bool hideStatus;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey;
  const TestsPage({ Key key,this.menuScreenContext,this.hideStatus,this.scaffoldKey,this.scaffoldMessengerKey}) : super(key: key);
  @override
  _TestsPageState createState() => _TestsPageState();
}
class _TestsPageState extends State<TestsPage> {
  GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey=GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tests"),
        leading: IconButton(icon:Icon(Icons.menu),onPressed: (){widget.scaffoldKey.currentState.openDrawer();},),),
      body: Center(
        child: Text("Coming Soon..."),
      ),
    );
  }
}