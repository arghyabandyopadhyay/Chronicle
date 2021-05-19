import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class WishlistPage extends StatefulWidget {
  const WishlistPage({ Key key,}) : super(key: key);
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
        title: Text("Wishlist"),),
      body: Center(
        child: Text("Coming Soon..."),
      ),
    );
  }
}