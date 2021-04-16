

import 'package:chronicle/Modules/universalModule.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chronicle/Modules/database.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_code_tools/qr_code_tools.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrCodePage extends StatefulWidget {
  String qrCode;
  final User _user;

  QrCodePage({Key key,this.qrCode,User user}): _user = user,
        super(key: key);

  @override
  _QrCodePageState createState() => _QrCodePageState();
}

class _QrCodePageState extends State<QrCodePage> {

  GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey=GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(child: Scaffold(
      appBar: AppBar(

        title: Text("QR Code"),
      ),
      body: Center(
        child: QrImage(
          data: widget.qrCode,
          version: QrVersions.auto,
          size: 320,
          gapless: false,
          backgroundColor: Colors.white,
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () async {
        String _data = '';
        try {
          final pickedFile = await ImagePicker().getImage(
            source: ImageSource.gallery,
            maxWidth: 300,
            maxHeight: 300,
            imageQuality: 30,
          );
          setState(() {
            QrCodeToolsPlugin.decodeFrom(pickedFile.path).then((value) {
              _data = value;
              getUserDetails().then((value) {
                value.qrcodeDetail=_data;
                setState(() {
                  widget.qrCode=_data;
                });
                updateUserDetails(value, value.id);
              });

            });

          });
        } catch (e) {
          globalShowInSnackBar(scaffoldMessengerKey,e);
          setState(() {
            _data = '';
          });
        }
      },
        child: Icon(Icons.edit),),
    ),key: scaffoldMessengerKey,);
  }
}
