import 'package:chronicle/Modules/universalModule.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chronicle/Modules/database.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_code_tools/qr_code_tools.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrCodePage extends StatefulWidget {
  final String qrCode;
  QrCodePage({Key key,this.qrCode}):super(key: key);

  @override
  _QrCodePageState createState() => _QrCodePageState();
}

class _QrCodePageState extends State<QrCodePage> {
  GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey=GlobalKey<ScaffoldMessengerState>();
  String qrCode;
  @override
  void initState() {
    super.initState();
    qrCode=widget.qrCode;
  }
  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(child: Scaffold(
      appBar: AppBar(
        title: Text("QR Code"),
      ),
      body: Center(
        child: QrImage(
          data: qrCode,
          version: QrVersions.auto,
          size: 320,
          gapless: false,
          backgroundColor: Colors.white,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "qrCodePageHeroTag",
        onPressed: () async {
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
                  qrCode=_data;
                });
                value.update();
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
