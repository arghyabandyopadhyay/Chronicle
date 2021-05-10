import 'package:chronicle/Formatters/indNumberTextInputFormatter.dart';
import 'package:chronicle/Models/clientModel.dart';
import 'package:chronicle/Modules/universalModule.dart';
import 'package:chronicle/Modules/database.dart';
import 'package:chronicle/customColors.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ClientInformationPage extends StatefulWidget {
  final ClientModel client;
  const ClientInformationPage({ Key key,this.client}) : super(key: key);
  @override
  _ClientInformationPageState createState() => _ClientInformationPageState();
}

class _ClientInformationPageState extends State<ClientInformationPage> {
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
      if(paymentNumberTextField.text.isNotEmpty)
      showDialog(context: context,
          builder: (BuildContext context1){
            return new AlertDialog(
              title: Text("Confirm New Payment"),
              content: Text("Are you sure to add new payment. Your old payments for ${widget.client.name} will be flushed?"),
              actions: [
                ActionChip(label: Text("Yes"), onPressed: (){
                  Navigator.pop(context1);
                  form.save();
                  showDialog(context: context,
                      builder: (BuildContext context2){
                        return new AlertDialog(
                          title: Text("Confirm Save"),
                          content: Text("Are you sure to save changes?"),
                          actions: [
                            ActionChip(label: Text("Yes"), onPressed: (){
                              Navigator.pop(context2);
                              setState(() {
                                isLoading=true;
                              });
                              widget.client.sex=sexDropDown;
                              widget.client.caste=casteDropDown;
                              updateClient(widget.client,widget.client.id);
                              changesSavedModule(context,scaffoldMessengerKey);
                            }),
                            ActionChip(label: Text("No"), onPressed: (){
                              setState(() {
                                Navigator.of(context2).pop();
                              });
                            })
                          ],
                        );
                      }
                  );
                }),
                ActionChip(label: Text("No"), onPressed: (){
                  setState(() {
                    Navigator.of(context1).pop();
                  });
                })
              ],
            );
          }
      );
      else {
        form.save();
        showDialog(context: context,
            builder: (BuildContext context1){
              return new AlertDialog(
                title: Text("Confirm Save"),
                content: Text("Are you sure to save changes?"),
                actions: [
                  ActionChip(label: Text("Yes"), onPressed: (){
                    Navigator.pop(context1);
                    setState(() {
                      isLoading=true;
                    });
                    widget.client.sex=sexDropDown;
                    widget.client.caste=casteDropDown;
                    updateClient(widget.client,widget.client.id);
                    changesSavedModule(context,scaffoldMessengerKey);
                  }),
                  ActionChip(label: Text("No"), onPressed: (){
                    setState(() {
                      Navigator.of(context1).pop();
                    });
                  })
                ],
              );
            }
        );
      }

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
      phoneNumberTextField.text=widget.client.mobileNo!=null?widget.client.mobileNo:"";
      nameTextField.text=widget.client.name!=null?widget.client.name:"";
      dueTextField.text=widget.client.due!=null?widget.client.due.toString():"";
      addressTextField.text=widget.client.address!=null?widget.client.address:"";
      fathersNameTextField.text=widget.client.fathersName!=null?widget.client.fathersName:"";
      educationTextField.text=widget.client.education!=null?widget.client.education:"";
      occupationTextField.text=widget.client.occupation!=null?widget.client.occupation:"";
      injuriesTextField.text=widget.client.injuries!=null?widget.client.injuries:"";
      registrationIdTextField.text=(this.widget.client.registrationId!=null&&this.widget.client.registrationId!=""?this.widget.client.registrationId:this.widget.client.id.key);
      heightTextField.text=widget.client.height!=null?widget.client.height.toStringAsFixed(2):"";
      weightTextField.text=widget.client.weight!=null?widget.client.weight.toStringAsFixed(2):"";
      sexDropDown=widget.client.sex;
      casteDropDown=widget.client.caste;
      counter++;
    }
    return ScaffoldMessenger(child: Scaffold(
      appBar: AppBar(
        title: Text(widget.client.name!=null?widget.client.name:"Client Profile",),
        actions: [
          Center(child: Text(this.widget.client.due==0?"Last Month  ":("${this.widget.client.due<0?"Paid":"Due"}: "+(this.widget.client.due.abs()+(this.widget.client.due<0?1:0)).toString()+"  "),style: TextStyle(color: this.widget.client.due<=0?this.widget.client.due==0?Colors.orangeAccent:Colors.green:Colors.red,fontWeight: FontWeight.bold),))],
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
                Row(mainAxisAlignment:MainAxisAlignment.spaceAround, children: [
                  Column(children: [IconButton(icon: Icon(Icons.call,color: Colors.orangeAccent), onPressed: () async {
                    callModule(widget.client,scaffoldMessengerKey);
                  },),Text("Call")],),
                  Column(children: [IconButton(icon: Icon(FontAwesomeIcons.whatsappSquare,color:CustomColors.whatsAppGreen), onPressed: () async {
                    whatsAppModule(widget.client, scaffoldMessengerKey);
                  },),Text("WhatsApp")],),
                  if(this.widget.client.due>-1)Column(children: [IconButton(icon: Icon(Icons.more_time,color: Colors.red), onPressed: () async {
                    addDueModule(this.widget.client,this);
                  }),Text("Add Due")],),
                  Column(children: [IconButton(icon: Icon(Icons.payment,color: Colors.green), onPressed: () {
                    addPaymentModule(this.widget.client,context,scaffoldMessengerKey,this);
                  },),Text("Add Payment")],),
                  Column(children: [IconButton(icon: Icon(Icons.delete,color: Colors.deepOrange), onPressed: (){
                    deleteModule(widget.client, context, this);
                  }),Text("Delete")],),
                ],),
                SizedBox(height: 20,),
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
                    style: TextStyle(),
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: "Registration Id(Auto generated if left empty)",
                      contentPadding:
                      EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0),
                    ),
                    onSaved: (value) {
                      widget.client.registrationId = value;
                    },
                  ),),]),
                SizedBox(height: 15,),
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
                      widget.client.name = value;
                    },
                    validator: _validateName,
                  ),),]),
                SizedBox(height: 15,),
                Row(children:[
                  CircleAvatar(
                    radius: 25,
                    child: Image.asset(
                      'assets/dad.png',
                      height: 30,
                    ),
                    backgroundColor: Colors.transparent,
                  ),Expanded(child:
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
                      widget.client.fathersName = value;
                    },
                  ),),]),
                SizedBox(height: 15,),
                Row(children:[
                  CircleAvatar(
                    radius: 25,
                    child: Image.asset(
                      'assets/dob.png',
                      height: 30,
                    ),
                    backgroundColor: Colors.transparent,
                  ),Expanded(child:
                  DateTimeFormField(
                    decoration: const InputDecoration(
                      hintStyle: TextStyle(),
                      errorStyle: TextStyle(),
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.event_note),
                      labelText: 'DOB',
                    ),
                    initialValue: widget.client.dob,
                    mode: DateTimeFieldPickerMode.date,
                    autovalidateMode: AutovalidateMode.always,
                    onDateSelected: (DateTime value) {
                      widget.client.dob=value;
                    },
                  ),),]),
                SizedBox(height: 15,),
                Row(children:[
                  CircleAvatar(
                    radius: 25,
                    child: Image.asset(
                      'assets/mobile.png',
                      height: 30,
                    ),
                    backgroundColor: Colors.transparent,
                  ),Expanded(child:
                  TextFormField(
                    controller: phoneNumberTextField,
                    textInputAction: TextInputAction.next,
                    style: TextStyle(),
                    decoration: InputDecoration(
                      suffix:Text("Copy to dialer:"),
                      suffixIcon: IconButton(
                        icon:Icon(Icons.call),
                        onPressed: ()async {
                          if(phoneNumberTextField.text!=null&&phoneNumberTextField.text!="")
                          {
                            var url = 'tel:<${phoneNumberTextField.text}>';
                            if (await canLaunch(url)) {
                              await launch(url);
                            } else {
                              globalShowInSnackBar(scaffoldMessengerKey, 'Oops!! Something went wrong.');
                            }
                          }
                          else globalShowInSnackBar(scaffoldMessengerKey, "Please enter the mobile no");
                        },
                      ),
                      border: const OutlineInputBorder(),
                      labelText: "Mobile",
                      contentPadding:
                      EdgeInsets.only( left: 10.0, right: 10.0),
                    ),
                    keyboardType: TextInputType.phone,
                    onSaved: (value) {
                      widget.client.mobileNo = value;
                    },
                    validator: _validatePhoneNumber,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                      // Fit the validating format.
                      _phoneNumberFormatter,
                    ],
                  ),),]),
                SizedBox(height: 15,),
                Row(children:[
                  CircleAvatar(
                    radius: 25,
                    child: Image.asset(
                      'assets/address.png',
                      height: 30,
                    ),
                    backgroundColor: Colors.transparent,
                  ),Expanded(child:
                  TextFormField(
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
                      widget.client.address = value;
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
                  ),),]),
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
                  ),),]),
                SizedBox(height: 8,),
                Row(children:[
                  CircleAvatar(
                    radius: 25,
                    child: Image.asset(
                      'assets/weight.png',
                      height: 30,
                    ),
                    backgroundColor: Colors.transparent,
                  ),Expanded(child:
                  TextFormField(
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
                      if(value.isNotEmpty)widget.client.weight = double.parse(value);
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
                  ),Expanded(child:
                  TextFormField(
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
                      if(value.isNotEmpty)widget.client.height = double.parse(value);
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
                  ),Expanded(child:
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
                      widget.client.injuries = value;
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
                  ),Expanded(child:TextFormField(
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
                      widget.client.education = value;
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
                  ),Expanded(child:TextFormField(
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
                      widget.client.occupation = value;
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
                      helperText: "Old payments data will be flushed if this field is filled",
                      contentPadding:
                      EdgeInsets.only( left: 10.0, right: 10.0),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value){
                      if(value.isEmpty)return null;
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
                        if(value.isNotEmpty)
                        {
                          int months=int.parse(value);
                          months=months.abs();
                          widget.client.due= (months-1)*-1;
                          if(widget.client.startDate==null)widget.client.startDate=today;
                          widget.client.endDate = DateTime(widget.client.startDate.year,widget.client.startDate.month+months,widget.client.startDate.day);
                        }
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
                      'assets/date.png',
                      height: 30,
                    ),
                    backgroundColor: Colors.transparent,
                  ),Expanded(child:DateTimeFormField(
                    decoration: const InputDecoration(
                      hintStyle: TextStyle(),
                      errorStyle: TextStyle(),
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.event_note),
                      labelText: 'Start Date',
                    ),
                    initialValue: widget.client.startDate,
                    mode: DateTimeFieldPickerMode.date,
                    autovalidateMode: AutovalidateMode.always,
                    onDateSelected: (DateTime value) {
                      try{
                        int months=int.parse(paymentNumberTextField.text);
                        widget.client.startDate=value;
                        if(widget.client.startDate==null)widget.client.startDate=today;
                        months=months.abs();
                        widget.client.endDate = DateTime(widget.client.startDate.year,widget.client.startDate.month+months,widget.client.startDate.day);
                      }
                      catch(E){
                        globalShowInSnackBar(scaffoldMessengerKey, "Please Enter No of Payments!!");
                      }
                    },
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

  @override
  void dispose() {
    super.dispose();
  }
}