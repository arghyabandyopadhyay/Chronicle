import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class WishlistPage extends StatefulWidget {
  final BuildContext mainScreenContext;
  final bool hideStatus;
  final GlobalKey<ScaffoldState> scaffoldKey;
  const WishlistPage({ Key key,this.mainScreenContext,this.hideStatus,this.scaffoldKey}) : super(key: key);
  @override
  _WishlistPageState createState() => _WishlistPageState();
}
class _WishlistPageState extends State<WishlistPage> {
  GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey=GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Wishlist"),
        leading: IconButton(icon:Icon(Icons.menu),onPressed: (){widget.scaffoldKey.currentState.openDrawer();},),),
      body: Center(
        child: Text("Coming Soon..."),
      ),
    );
  }
}