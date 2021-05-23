import 'package:chronicle/Formatters/indNumberTextInputFormatter.dart';
import 'package:chronicle/Models/clientModel.dart';
import 'package:chronicle/Modules/universalModule.dart';
import 'package:chronicle/Pages/TutorPages/contactListPage.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
class RegisterClientPage extends StatefulWidget {
  final Function(ClientModel) callback;
  const RegisterClientPage({Key key, this.callback}) : super(key: key);
  @override
  _RegisterClientPageState createState() => _RegisterClientPageState();
}
class _RegisterClientPageState extends State<RegisterClientPage> {
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  ClientModel clientData = ClientModel();
  DateTime now,today;
  var phoneNumberTextField=TextEditingController();
  var paymentNumberTextField=TextEditingController();
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
  final IndNumberTextInputFormatter _phoneNumberFormatter =IndNumberTextInputFormatter();
  String _validatePhoneNumber(String value) {
    final phoneExp = RegExp(r'^\d\d\d\d\d\ \d\d\d\d\d$');
    if (value.isNotEmpty&&!phoneExp.hasMatch(value)) {
      return "Wrong Mobile No.!";
    }
    else if(value.isEmpty)phoneNumberTextField.text="";
    return null;
  }
  final focus = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  //Functions
  void _handleSubmitted() {
    final form = _formKey.currentState;
    if (!form.validate()) {// Start validating on every change.
    }
    else {
      form.save();
      clientData.sex=sexDropDown;
      clientData.caste=casteDropDown;
      // try{
        // if(clientData.startDate==null)clientData.startDate=today;
        // int months=int.parse(paymentNumberTextField.text);
        // months=months.abs();
        // clientData.endDate = DateTime(clientData.startDate.year,clientData.startDate.month+months,clientData.startDate.day);
        // globalShowInSnackBar(scaffoldMessengerKey,clientData.toJson());
      widget.callback(clientData);
      Navigator.pop(context);
      // }
      // catch(E){
      //   globalShowInSnackBar(scaffoldMessengerKey,E);
      //   globalShowInSnackBar(scaffoldMessengerKey,"Please Enter No of Payments!!");
      // }
      FocusScope.of(context).unfocus();
    }
  }
  String _validateName(String value) {
    if(value.isEmpty)return "required fields can't be left empty";
    return null;
  }
  //Overrides
  @override
  void initState() {
    paymentNumberTextField.text="1";
    now=DateTime.now();
    today=DateTime(now.year,now.month,now.day);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    const sizedBoxSpace = SizedBox(height: 100);
    return ScaffoldMessenger(child: Scaffold(
      appBar: AppBar(
        title: Text("Register Client",),
        actions: [
          IconButton(icon:Icon(Icons.perm_contact_cal_outlined),onPressed: (){
            Contact contact;
            showModalBottomSheet(context: context, builder: (_)=>ContactListPage()).then((value) =>
            {
              if(value!=null){
                contact=value,
                phoneNumberTextField.text=contact.phones!=null?getFormattedMobileNo(contact.phones.first.value):"",
                nameTextField.text=contact.displayName!=null?contact.displayName:"",
                addressTextField.text="",
                fathersNameTextField.text="",
                educationTextField.text="",
                occupationTextField.text=contact.jobTitle!=null?contact.jobTitle:"",
                injuriesTextField.text="",
                registrationIdTextField.text="",
                heightTextField.text="",
                weightTextField.text="",
                sexDropDown=null,
                casteDropDown=null,
              }
            });
          },),
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
                      labelText: "Registration Id(Auto generated if left empty)",
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
                      'assets/payment.png',
                      height: 30,
                    ),
                    backgroundColor: Colors.transparent,
                  ),Expanded(child: TextFormField(
                    controller: paymentNumberTextField,
                    textInputAction: TextInputAction.next,
                    autovalidateMode: AutovalidateMode.always,
                    style: TextStyle(),
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: "No of Payments(in months)",
                      contentPadding:
                      EdgeInsets.only( left: 10.0, right: 10.0),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value){
                      if(value.isEmpty)return "required fields can't be left empty";
                      else if(value=="0") return "No of Payments cant be 0!!";
                      else {
                        try{
                          int months=int.parse(value);
                          if(months<0){
                            return "No of Payments cant be Negative!!";
                          }
                          else{
                            return null;
                          }
                        }
                        catch(E){
                          return "Non numeric input not allowed.";
                        }
                      }
                    },
                    onSaved: (value) {
                      try{
                        int months=int.parse(value);
                        months=months.abs();
                        clientData.due= (months-1)*-1;
                        if(clientData.startDate==null)clientData.startDate=today;
                        clientData.endDate = DateTime(clientData.startDate.year,clientData.startDate.month+months,clientData.startDate.day);
                      }
                      catch(E){
                        globalShowInSnackBar(scaffoldMessengerKey, "Non numeric input not allowed.");
                      }
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
                    validator: _validateName,
                    onSaved: (value) {
                      clientData.name = value;
                    },
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
                    validator: _validatePhoneNumber,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                      // Fit the validating format.
                      _phoneNumberFormatter,
                    ],
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
                  ),Expanded(child: DropdownButtonFormField(
                      value: sexDropDown,
                      icon: Icon(Icons.arrow_downward),
                      decoration: InputDecoration(
                        labelText: "Sex:",
                        contentPadding:
                        EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0),
                        border: const OutlineInputBorder(),
                      ),
                      items: <String>['Male', 'Female', 'Trans', 'Prefer not to say'].map((String value) {
                        return new DropdownMenuItem<String>(
                          value: value,
                          child: new Text(value),
                        );
                      }).toList(),
                      onChanged: (String newValue) {
                        setState(() {
                          sexDropDown = newValue;
                        });
                      },
                    )
                    ,),]),
                SizedBox(height: 8,),
                Row(children:[
                  CircleAvatar(
                    radius: 25,
                    child: Image.asset(
                      'assets/caste.png',
                      height: 30,
                    ),
                    backgroundColor: Colors.transparent,
                  ),Expanded(child: DropdownButtonFormField(
                      value: casteDropDown,
                      icon: Icon(Icons.arrow_downward),
                      decoration: InputDecoration(
                        labelText: "Caste:",
                        contentPadding:
                        EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0),
                        border: const OutlineInputBorder(),
                      ),
                      items: <String>['General', 'OBC', 'SC/ST'].map((String value) {
                        return new DropdownMenuItem<String>(
                          value: value,
                          child: new Text(value),
                        );
                      }).toList(),
                      onChanged: (String newValue) {
                        setState(() {
                          casteDropDown = newValue;
                        });
                      },
                    )
                ,),]),
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
                      if(value.isNotEmpty)clientData.weight = double.parse(value);
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
                      if(value.isNotEmpty)clientData.height = double.parse(value);
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
                    initialValue: today,
                    mode: DateTimeFieldPickerMode.date,
                    onDateSelected: (DateTime value) {
                      try{
                        int months=int.parse(paymentNumberTextField.text);
                        clientData.startDate=value;
                        if(clientData.startDate==null)clientData.startDate=today;
                        months=months.abs();
                        clientData.endDate = DateTime(clientData.startDate.year,clientData.startDate.month+months,clientData.startDate.day);
                      }
                      catch(E){
                        globalShowInSnackBar(scaffoldMessengerKey, "Please Enter No of Payments!!");
                      }
                    },
                  ),),]),
                sizedBoxSpace,
              ],
            ),
          ),
        ),
      ),
      floatingActionButton:FloatingActionButton.extended(
        heroTag: "registerClientsRegisterClientPageHeroTag",
        icon: Icon(Icons.person_add),
        label: Text("Register",),
        onPressed: _handleSubmitted,
      ),
      floatingActionButtonLocation:
      FloatingActionButtonLocation.endFloat,
    ),key: scaffoldMessengerKey,);
  }
}