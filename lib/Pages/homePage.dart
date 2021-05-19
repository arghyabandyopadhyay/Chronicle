import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class HomePage extends StatefulWidget {
  final BuildContext mainScreenContext;
  final bool hideStatus;
  final GlobalKey<ScaffoldState> scaffoldKey;
  const HomePage({ Key key,this.mainScreenContext,this.hideStatus,this.scaffoldKey,}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey=GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        leading: IconButton(icon:Icon(Icons.menu),onPressed: (){widget.scaffoldKey.currentState.openDrawer();},),),
      body: Center(
        child: Text("This is the Home"),
      ),
    );
  }
}