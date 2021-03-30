import 'package:Chronicle/Models/clientModel.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart' show DragStartBehavior;
import 'package:flutter/widgets.dart';

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
  var fitnessGoalTextField=TextEditingController();
  var heightTextField=TextEditingController();
  var weightTextField=TextEditingController();
  var dueTextField=TextEditingController();
  var bloodGroupTextField=TextEditingController();


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
        child: SingleChildScrollView(
            dragStartBehavior: DragStartBehavior.down,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            physics: BouncingScrollPhysics(),
            child: GestureDetector(
              onTap: (){
                FocusScopeNode currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  sizedBoxSpace,
                  SizedBox(height: 8,),
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
                      clientData.name = value;
                    },
                    validator: _validateName,
                  ),
                  SizedBox(height: 8,),
                  TextFormField(
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
                  ),
                  SizedBox(height: 8,),
                  TextFormField(
                    controller: weightTextField,
                    keyboardType:TextInputType.number,
                    textInputAction: TextInputAction.next,
                    style: TextStyle(),
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: "Weight",
                      contentPadding:
                      EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0),
                    ),
                    onSaved: (value) {
                      clientData.weight = int.parse(value);
                    },
                  ),
                  SizedBox(height: 8,),
                  TextFormField(
                    controller: heightTextField,
                    keyboardType:TextInputType.number,
                    textInputAction: TextInputAction.next,
                    style: TextStyle(),
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: "Height",
                      contentPadding:
                      EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0),
                    ),
                    onSaved: (value) {
                      clientData.height = int.parse(value);
                    },
                  ),
                  SizedBox(height: 8,),
                  DateTimeFormField(
                    decoration: const InputDecoration(
                      hintStyle: TextStyle(),
                      errorStyle: TextStyle(),
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.event_note),
                      labelText: 'DOB',
                    ),
                    mode: DateTimeFieldPickerMode.date,
                    autovalidateMode: AutovalidateMode.always,
                    validator: (e) => (e?.day ?? 0) == 1 ? 'Please not the first day' : null,
                    onDateSelected: (DateTime value) {
                      clientData.dob=value;
                    },
                  ),
                  SizedBox(height: 8,),
                  TextFormField(
                    textCapitalization: TextCapitalization.words,
                    controller: fitnessGoalTextField,
                    textInputAction: TextInputAction.next,
                    style: TextStyle(),
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: "Fitness Goal",
                      contentPadding:
                      EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0),
                    ),
                    onSaved: (value) {
                      clientData.fitnessGoal = value;
                    },
                  ),
                  SizedBox(height: 8,),
                  TextFormField(
                    textCapitalization: TextCapitalization.words,
                    controller: bloodGroupTextField,
                    textInputAction: TextInputAction.next,
                    style: TextStyle(),
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: "Blood Group",
                      contentPadding:
                      EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0),
                    ),
                    onSaved: (value) {
                      clientData.bloodGroup = value;
                    },
                  ),
                  SizedBox(height: 8,),
                  TextFormField(
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
                  ),
                  SizedBox(height: 8,),
                  TextFormField(
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
                  ),
                  SizedBox(height: 8,),
                  TextFormField(
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
                  ),
                  SizedBox(height: 8,),
                  TextFormField(
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
                  ),
                  SizedBox(height: 8,),
                  DateTimeFormField(
                    decoration: const InputDecoration(
                      hintStyle: TextStyle(),
                      errorStyle: TextStyle(),
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.event_note),
                      labelText: 'Start Date',
                    ),
                    mode: DateTimeFieldPickerMode.date,
                    autovalidateMode: AutovalidateMode.always,
                    validator: (e) => (e?.day ?? 0) == 1 ? 'Please not the first day' : null,
                    onDateSelected: (DateTime value) {
                      clientData.startDate=value;
                    },
                  ),
                  SizedBox(height: 8,),
                  DateTimeFormField(
                    decoration: const InputDecoration(
                      hintStyle: TextStyle(),
                      errorStyle: TextStyle(),
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.event_note),
                      labelText: 'End Date',
                    ),
                    mode: DateTimeFieldPickerMode.date,
                    autovalidateMode: AutovalidateMode.always,
                    validator: (e) => (e?.day ?? 0) == 1 ? 'Please not the first day' : null,
                    onDateSelected: (DateTime value) {
                      clientData.endDate=value;
                    },
                  ),
                  SizedBox(height: 8,),
                  TextFormField(
                    textCapitalization: TextCapitalization.words,
                    controller: addressTextField,
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
                  ),
                  sizedBoxSpace,
                ],
              ),
            )
        ),
      ),
      floatingActionButton:FloatingActionButton.extended(
        icon: Icon(Icons.person_add),
        label: Text("Register",textScaleFactor:1,style: TextStyle(fontSize: 17),),
        onPressed: _handleSubmitted,
      ),
      floatingActionButtonLocation:
      FloatingActionButtonLocation.endFloat,
    );
  }
}