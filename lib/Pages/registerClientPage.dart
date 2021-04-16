import 'package:chronicle/Models/clientModel.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart' show DragStartBehavior;
import 'package:flutter/widgets.dart';

import '../customColors.dart';

class RegisterClientPage extends StatefulWidget {
  final Function(ClientModel) callback;
  const RegisterClientPage({Key key, this.callback}) : super(key: key);
  @override
  _RegisterClientPageState createState() => _RegisterClientPageState();
}
class _RegisterClientPageState extends State<RegisterClientPage> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey<ScaffoldMessengerState>();
  ClientModel clientData = ClientModel();

  var phoneNumberTextField=TextEditingController();
  var nameTextField=TextEditingController();
  var addressTextField=TextEditingController();
  var fathersNameTextField=TextEditingController();
  var educationTextField=TextEditingController();
  var occupationTextField=TextEditingController();
  var injuriesTextField=TextEditingController();
  var registrationIdTextField=TextEditingController();
  var heightTextField=TextEditingController();
  var weightTextField=TextEditingController();
  String sexDropDown;
  String casteDropDown;

  final focus = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  //Functions
  void showInSnackBar(String value) {
    _scaffoldKey.currentState.hideCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(value,textScaleFactor:1),
    ));
  }
  Future<void> _handleSubmitted() async {
    final form = _formKey.currentState;
    if (!form.validate()) {// Start validating on every change.
    }
    else {
      form.save();
      clientData.due= 0;
      clientData.sex=sexDropDown;
      clientData.caste=casteDropDown;
      widget.callback(clientData);
      Navigator.pop(context);
      FocusScope.of(context).unfocus();
    }
  }
  String _validateName(String value) {
    if(value.isEmpty)nameTextField.text="";
    return null;
  }
  //Overrides
  @override
  Widget build(BuildContext context) {
    const sizedBoxSpace = SizedBox(height: 24);
    return Scaffold(
      appBar: AppBar(

        title: Text("Register Client",),
      ),
      key: _scaffoldKey,
      body: Form(
        key: _formKey,
        child: GestureDetector(
          onTap: (){
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: ListView(
            shrinkWrap: true,
            physics:BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 5),
            children: [
              SizedBox(height: 8,),
              Row(children:[
                CircleAvatar(
                  radius: 25,
                  child: Image.asset(
                    'assets/registrationId.png',
                    height: 30,
                  ),
                  backgroundColor: Colors.transparent,
                ),Expanded(child: TextFormField(
                  textCapitalization: TextCapitalization.words,
                  controller: registrationIdTextField,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: "Registration Id",
                    contentPadding:
                    EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0),
                  ),
                  onSaved: (value) {
                    clientData.registrationId = value;
                  },
                ),),]),
              SizedBox(height: 8,),
              Row(children:[
                CircleAvatar(
                  radius: 25,
                  child: Image.asset(
                    'assets/name.png',
                    height: 30,
                  ),
                  backgroundColor: Colors.transparent,
                ),Expanded(child: TextFormField(
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
                    clientData.name = value;
                  },
                  validator: _validateName,
                ),),]),
              SizedBox(height: 8,),
              Row(children:[
                CircleAvatar(
                  radius: 25,
                  child: Image.asset(
                    'assets/dad.png',
                    height: 30,
                  ),
                  backgroundColor: Colors.transparent,
                ),Expanded(child: TextFormField(
                  textCapitalization: TextCapitalization.words,
                  controller: fathersNameTextField,
                  textInputAction: TextInputAction.next,
                  style: TextStyle(),
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: "Father's Name",
                    contentPadding:
                    EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0),
                  ),
                  onSaved: (value) {
                    clientData.fathersName = value;
                  },
                  validator: _validateName,
                ),),]),
              SizedBox(height: 8,),
              Row(children:[
                CircleAvatar(
                  radius: 25,
                  child: Image.asset(
                    'assets/dob.png',
                    height: 30,
                  ),
                  backgroundColor: Colors.transparent,
                ),Expanded(child: DateTimeFormField(
                  decoration: const InputDecoration(
                    hintStyle: TextStyle(),
                    errorStyle: TextStyle(),
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.event_note),
                    labelText: 'DOB',
                  ),
                  mode: DateTimeFieldPickerMode.date,
                  autovalidateMode: AutovalidateMode.always,
                  onDateSelected: (DateTime value) {
                    clientData.dob=value;
                  },
                ),),]),
              SizedBox(height: 8,),
              Row(children:[
                CircleAvatar(
                  radius: 25,
                  child: Image.asset(
                    'assets/mobile.png',
                    height: 30,
                  ),
                  backgroundColor: Colors.transparent,
                ),Expanded(child: TextFormField(
                  controller: phoneNumberTextField,
                  textInputAction: TextInputAction.next,
                  style: TextStyle(),
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: "Mobile",
                    contentPadding:
                    EdgeInsets.only( left: 10.0, right: 10.0),
                  ),
                  keyboardType: TextInputType.phone,
                  onSaved: (value) {
                    clientData.mobileNo = value;
                  },
                ),),]),
              SizedBox(height: 8,),
              Row(children:[
                CircleAvatar(
                  radius: 25,
                  child: Image.asset(
                    'assets/address.png',
                    height: 30,
                  ),
                  backgroundColor: Colors.transparent,
                ),Expanded(child: TextFormField(
                  textCapitalization: TextCapitalization.words,
                  controller: addressTextField,
                  textInputAction: TextInputAction.next,
                  keyboardType:TextInputType.multiline,
                  style: TextStyle(),
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: "Address",
                    contentPadding:
                    EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0),
                  ),
                  onSaved: (value) {
                    clientData.address = value;
                  },
                ),),]),
              SizedBox(height: 8,),
              Row(children:[
                CircleAvatar(
                  radius: 25,
                  child: Image.asset(
                    'assets/sex.png',
                    height: 30,
                  ),
                  backgroundColor: Colors.transparent,
                ),Expanded(child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      border: Border.all(width: 0.7), borderRadius: BorderRadius.all(Radius.circular(4.0))
                  ),
                  child: DropdownButton<String>(dropdownColor: Theme.of(context).scaffoldBackgroundColor,
                    hint: Container(child: Text("Sex:",style:TextStyle()),width: MediaQuery.of(context).size.width-110),
                    iconSize: 24,
                    value: sexDropDown,
                    elevation: 16,
                    style: TextStyle(),
                    underline: Container(
                      color: Colors.white,
                    ),
                    onChanged: (String newValue) {
                      setState(() {
                        sexDropDown = newValue;
                      });
                    },
                    items: <String>['Male', 'Female', 'Trans', 'Prefer not to say']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value,style: TextStyle(color: Theme.of(context).textTheme.headline1.color),),
                      );
                    }).toList(),
                  ),),),]),
              SizedBox(height: 8,),
              Row(children:[
                CircleAvatar(
                  radius: 25,
                  child: Image.asset(
                    'assets/caste.png',
                    height: 30,
                  ),
                  backgroundColor: Colors.transparent,
                ),Expanded(child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(width: 0.7), borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                  child: DropdownButton<String>(dropdownColor: Theme.of(context).scaffoldBackgroundColor,
                    hint: Container(child: Text("Caste:",style:TextStyle()),width: MediaQuery.of(context).size.width-110),
                    iconSize: 24,
                    value: casteDropDown,
                    elevation: 16,
                    style: TextStyle(),
                    underline: Container(
                      color: Colors.white,
                    ),
                    onChanged: (String newValue) {
                      setState(() {
                        casteDropDown = newValue;
                      });
                    },
                    items: <String>['General', 'OBC', 'SC/ST']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value,style: TextStyle(color: Theme.of(context).textTheme.headline1.color),),
                      );
                    }).toList(),
                  ),),),]),
              SizedBox(height: 8,),
              Row(children:[
                CircleAvatar(
                  radius: 25,
                  child: Image.asset(
                    'assets/weight.png',
                    height: 30,
                  ),
                  backgroundColor: Colors.transparent,
                ),Expanded(child: TextFormField(
                  controller: weightTextField,
                  keyboardType:TextInputType.number,
                  textInputAction: TextInputAction.next,
                  style: TextStyle(),
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: "Weight(kg)",
                    contentPadding:
                    EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0),
                  ),
                  onSaved: (value) {
                    clientData.weight = double.parse(value);
                  },
                ),),]),
              SizedBox(height: 8,),
              Row(children:[
                CircleAvatar(
                  radius: 25,
                  child: Image.asset(
                    'assets/height.png',
                    height: 30,
                  ),
                  backgroundColor: Colors.transparent,
                ),Expanded(child: TextFormField(
                  controller: heightTextField,
                  keyboardType:TextInputType.number,
                  textInputAction: TextInputAction.next,
                  style: TextStyle(),
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: "Height(cm)",
                    contentPadding:
                    EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0),
                  ),
                  onSaved: (value) {
                    clientData.height = double.parse(value);
                  },
                ),),]),
              SizedBox(height: 8,),
              Row(children:[
                CircleAvatar(
                  radius: 25,
                  child: Image.asset(
                    'assets/injuries.png',
                    height: 30,
                  ),
                  backgroundColor: Colors.transparent,
                ),Expanded(child: TextFormField(
                  textCapitalization: TextCapitalization.words,
                  controller: injuriesTextField,
                  textInputAction: TextInputAction.next,
                  style: TextStyle(),
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: "Injuries / Medical Problems",
                    contentPadding:
                    EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0),
                  ),
                  onSaved: (value) {
                    clientData.injuries = value;
                  },
                ),),]),
              SizedBox(height: 8,),
              Row(children:[
                CircleAvatar(
                  radius: 25,
                  child: Image.asset(
                    'assets/education.png',
                    height: 30,
                  ),
                  backgroundColor: Colors.transparent,
                ),Expanded(child: TextFormField(
                  textCapitalization: TextCapitalization.words,
                  controller: educationTextField,
                  textInputAction: TextInputAction.next,
                  style: TextStyle(),
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: "Education",
                    contentPadding:
                    EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0),
                  ),
                  onSaved: (value) {
                    clientData.education = value;
                  },
                ),),]),
              SizedBox(height: 8,),
              Row(children:[
                CircleAvatar(
                  radius: 25,
                  child: Image.asset(
                    'assets/occupation.png',
                    height: 30,
                  ),
                  backgroundColor: Colors.transparent,
                ),Expanded(child: TextFormField(
                  textCapitalization: TextCapitalization.words,
                  controller: occupationTextField,
                  textInputAction: TextInputAction.next,
                  style: TextStyle(),
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: "Occupation",
                    contentPadding:
                    EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0),
                  ),
                  onSaved: (value) {
                    clientData.occupation = value;
                  },
                ),),]),
              SizedBox(height: 8,),
              Row(children:[
                CircleAvatar(
                  radius: 25,
                  child: Image.asset(
                    'assets/date.png',
                    height: 30,
                  ),
                  backgroundColor: Colors.transparent,
                ),Expanded(child: DateTimeFormField(
                  decoration: const InputDecoration(
                    hintStyle: TextStyle(),
                    errorStyle: TextStyle(),
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.event_note),
                    labelText: 'Start Date',
                  ),
                  mode: DateTimeFieldPickerMode.date,
                  autovalidateMode: AutovalidateMode.always,
                  onDateSelected: (DateTime value) {
                    clientData.startDate=value;
                  },
                ),),]),
              SizedBox(height: 8,),
              Row(children:[
                CircleAvatar(
                  radius: 25,
                  child: Image.asset(
                    'assets/date1.png',
                    height: 30,
                  ),
                  backgroundColor: Colors.transparent,
                ),Expanded(child: DateTimeFormField(
                  decoration: const InputDecoration(
                    hintStyle: TextStyle(),
                    errorStyle: TextStyle(),
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.event_note),
                    labelText: 'End Date',
                  ),
                  mode: DateTimeFieldPickerMode.date,
                  autovalidateMode: AutovalidateMode.always,
                  onDateSelected: (DateTime value) {
                    clientData.endDate=value;
                  },
                ),),]),
              sizedBoxSpace,
            ],
          ),
        ),
      ),
      floatingActionButton:FloatingActionButton.extended(
        icon: Icon(Icons.person_add),
        label: Text("Register",),
        onPressed: _handleSubmitted,
      ),
      floatingActionButtonLocation:
      FloatingActionButtonLocation.endFloat,
    );
  }
}