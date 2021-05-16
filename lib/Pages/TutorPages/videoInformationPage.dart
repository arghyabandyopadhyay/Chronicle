import 'package:chronicle/Formatters/indNumberTextInputFormatter.dart';
import 'package:chronicle/Models/clientModel.dart';
import 'package:chronicle/Models/modalOptionModel.dart';
import 'package:chronicle/Models/videoIndexModel.dart';
import 'package:chronicle/Modules/apiModule.dart';
import 'package:chronicle/Modules/universalModule.dart';
import 'package:chronicle/Modules/database.dart';
import 'package:chronicle/Widgets/optionModalBottomSheet.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../customColors.dart';
import '../../globalClass.dart';

class VideoInformationPage extends StatefulWidget {
  final VideoIndexModel video;
  const VideoInformationPage({ Key key,this.video}) : super(key: key);
  @override
  _VideoInformationPageState createState() => _VideoInformationPageState();
}

class _VideoInformationPageState extends State<VideoInformationPage> {
  GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey=new GlobalKey<ScaffoldMessengerState>();
  DateTime now,today;
  var phoneNumberTextField=TextEditingController();
  var nameTextField=TextEditingController();
  var dueTextField=TextEditingController();
  var addressTextField=TextEditingController();
  var fathersNameTextField=TextEditingController();
  var educationTextField=TextEditingController();
  var occupationTextField=TextEditingController();
  var injuriesTextField=TextEditingController();
  var registrationIdTextField=TextEditingController();
  var heightTextField=TextEditingController();
  var weightTextField=TextEditingController();
  var paymentNumberTextField=TextEditingController();
  DateTime startDateTemp;
  String sexDropDown;
  String casteDropDown;
  bool isLoading=false;
  final focus = FocusNode();
  int counter=0;
  String _validateName(String value) {
    if(value.isEmpty)nameTextField.text="";
    return null;
  }
  final IndNumberTextInputFormatter _phoneNumberFormatter =IndNumberTextInputFormatter();
  String _validatePhoneNumber(String value) {
    final phoneExp = RegExp(r'^\d\d\d\d\d\ \d\d\d\d\d$');
    if (value.isNotEmpty&&!phoneExp.hasMatch(value)) {
      return "Wrong Mobile No.!";
    }
    else if(value.isEmpty)phoneNumberTextField.text="";
    return null;
  }
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Future<void> _handleSubmitted() async {
    final form = _formKey.currentState;
    if (!form.validate()) {
    }
    else {
    }
  }

  @override
  void initState() {
    now=DateTime.now();
    today=DateTime(now.year,now.month,now.day);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    if(counter==0)
    {
      counter++;
    }
    return ScaffoldMessenger(child: Scaffold(
      appBar: AppBar(
        title: Text(widget.video.name!=null?widget.video.name:"Client Profile",),
        actions: [
          PopupMenuButton<ModalOptionModel>(
            itemBuilder: (BuildContext popupContext){
              return [
                ModalOptionModel(particulars: "Share",icon: Icons.share,iconColor:CustomColors.callIconColor,onTap: (){
                  Navigator.pop(popupContext);
                  shareModule(widget.video,scaffoldMessengerKey);
                }),
              ].map((ModalOptionModel choice){
                return PopupMenuItem<ModalOptionModel>(
                  value: choice,
                  child: ListTile(title: Text(choice.particulars),leading: Icon(choice.icon,color: choice.iconColor,),onTap: choice.onTap,),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          physics:BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: GestureDetector(
            onTap: (){
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
            },
            child: Column(
              children: [
                SizedBox(height: 8,),
                Row(children:[
                  CircleAvatar(
                    radius: 25,
                    child: Image.asset(
                      'assets/name.png',
                      height: 30,
                    ),
                    backgroundColor: Colors.transparent,
                  ),Expanded(child:
                  TextFormField(
                    textCapitalization: TextCapitalization.words,
                    controller: nameTextField,
                    textInputAction: TextInputAction.next,
                    style: TextStyle(),
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: "Name",
                      contentPadding:
                      EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0),
                    ),
                    onSaved: (value) {
                      widget.video.name = value;
                    },
                    validator: _validateName,
                  ),),]),
                SizedBox(height: 100,),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: (){
          _handleSubmitted();
        }, label: Text("Save"),icon: Icon(Icons.save,),),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    ),key: scaffoldMessengerKey,);
  }
  Future<PermissionStatus> _getContactPermission() async {
    return await Permission.contacts.request();
  }
  void _handleInvalidPermissions(PermissionStatus permissionStatus) {
    if (permissionStatus == PermissionStatus.denied) {
      globalShowInSnackBar(scaffoldMessengerKey, "Access Denied by the user!!");
    } else if (permissionStatus == PermissionStatus.restricted) {
      globalShowInSnackBar(scaffoldMessengerKey, "Location data is not available on device");
    }
  }
  @override
  void dispose() {
    super.dispose();
  }
}