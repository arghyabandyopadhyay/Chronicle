import 'package:chronicle/Models/registerModel.dart';
import 'package:chronicle/Pages/SignInScreen.dart';
import 'package:chronicle/Pages/userInfoScreen.dart';
import 'package:chronicle/Widgets/registerOptionBottomSheet.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chronicle/database.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_code_tools/qr_code_tools.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../Models/clientModel.dart';
import '../clientList.dart';
import '../customColors.dart';
import '../registerNewClientWidget.dart';

class IdBlockedPage extends StatefulWidget {
  final User? user;
  IdBlockedPage({Key? key,this.user}):super(key: key);

  @override
  _IdBlockedPageState createState() => _IdBlockedPageState();
}

class _IdBlockedPageState extends State<IdBlockedPage> {


  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.firebaseNavy,
      appBar: AppBar(backgroundColor: CustomColors.firebaseNavy,
        elevation: 0,
        title: Text("Id Blocked"),
        actions: [IconButton(icon: Icon(Icons.account_circle_outlined,), onPressed: (){
          Navigator.of(context).push(CupertinoPageRoute(builder: (context)=>UserInfoScreen(user: widget.user!,)));
        }),],
      ),
      body: Center(
        child: Image.asset(
          'assets/firebase_logo.png',
          height: 160,
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        Navigator.of(context).pushReplacement(CupertinoPageRoute(builder: (context)=>SignInScreen()));
      },
        child: Icon(Icons.refresh),),
    );
  }
}
