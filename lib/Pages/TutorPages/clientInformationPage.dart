import 'package:chronicle/Formatters/indNumberTextInputFormatter.dart';
import 'package:chronicle/Models/clientModel.dart';
import 'package:chronicle/Models/modalOptionModel.dart';
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
  DateTime startDateTemp;
  String sexDropDown;
  String casteDropDown;
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
    startDateTemp=widget.client.startDate!=null?widget.client.startDate:today;

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(child: Scaffold(
      appBar: AppBar(
        title: Text(widget.client.name!=null?widget.client.name:"Client Profile",),
        actions: [
          Center(child: Text(this.widget.client.due==0?"Last Month  ":("${this.widget.client.due<0?"Paid":"Due"}: "+(this.widget.client.due.abs()+(this.widget.client.due<0?1:0)).toString()+"  "),style: TextStyle(color: this.widget.client.due<=0?this.widget.client.due==0?CustomColors.lastMonthTextColor:CustomColors.paidTextColor:CustomColors.dueTextColor,fontWeight: FontWeight.bold),)),
          PopupMenuButton<ModalOptionModel>(
            itemBuilder: (BuildContext popupContext){
              return [
                ModalOptionModel(particulars: "Call",icon: Icons.call,iconColor:CustomColors.callIconColor,onTap: (){
                  Navigator.pop(popupContext);
                  callModule(widget.client,scaffoldMessengerKey);
                }),
                ModalOptionModel(particulars: "Add to Contacts",icon: Icons.contacts_outlined,iconColor:CustomColors.addToContactIconColor,onTap: ()async{
                  Navigator.pop(popupContext);
                  PermissionStatus permissionStatus = await _getContactPermission();
                  if (permissionStatus == PermissionStatus.granted) {
                    if(phoneNumberTextField.text.isNotEmpty&&nameTextField.text.isNotEmpty){
                      try{
                        Contact contact = Contact();
                        PostalAddress address = PostalAddress(label: "Home");
                        contact.givenName = nameTextField.text;
                        contact.middleName = "";
                        contact.familyName = "";
                        contact.prefix = "";
                        contact.suffix = "";
                        contact.phones = [Item(label: "mobile", value: phoneNumberTextField.text)];
                        contact.emails = null;
                        contact.company = "";
                        contact.company = "";
                        contact.jobTitle = occupationTextField.text;
                        address.street = addressTextField.text;
                        address.city = "";
                        address.region = "";
                        address.postcode = "";
                        address.country = "";
                        contact.postalAddresses = [address];
                        ContactsService.addContact(contact);
                        globalShowInSnackBar(scaffoldMessengerKey,"${widget.client.name} added to your contacts!!");
                      }
                      catch(E)
                      {
                        globalShowInSnackBar(scaffoldMessengerKey,"Something went wrong!!");
                      }
                    }
                    else globalShowInSnackBar(scaffoldMessengerKey,"Name and the mobile no cannot be empty");
                  } else {
                    _handleInvalidPermissions(permissionStatus);
                  }
                }),
                ModalOptionModel(particulars: "Sms Reminder",icon: Icons.send,iconColor:CustomColors.sendIconColor,onTap: (){
                  Navigator.pop(popupContext);
                  showModalBottomSheet(context: context, builder: (_)=>
                      OptionModalBottomSheet(
                        appBarIcon: Icons.send,
                        appBarText: "How to send the reminder",
                        list: [
                          ModalOptionModel(
                              particulars: "Send Sms using Default Sim",
                              icon: Icons.sim_card_outlined,iconColor:CustomColors.simCardIconColor,
                              onTap: (){
                                Navigator.of(_).pop();
                                showDialog(context: context, builder: (_)=>new AlertDialog(
                                  title: Text("Confirm Send"),
                                  content: Text("Are you sure to send a reminder to ${widget.client.name}?"),
                                  actions: [
                                    ActionChip(label: Text("Yes"), onPressed: (){
                                      smsModule(this.widget.client,scaffoldMessengerKey);
                                      Navigator.of(_).pop();
                                    }),
                                    ActionChip(label: Text("No"), onPressed: (){
                                      Navigator.of(_).pop();
                                    })
                                  ],
                                ));
                              }),
                          ModalOptionModel(
                              particulars: "Send Sms using Sms Gateway",
                              icon: FontAwesomeIcons.server,iconColor:CustomColors.serverIconColor,
                              onTap: (){
                                if(GlobalClass.userDetail.smsAccessToken!=null
                                    &&GlobalClass.userDetail.smsApiUrl!=null
                                    &&GlobalClass.userDetail.smsUserId!=null
                                    &&GlobalClass.userDetail.smsMobileNo!=null
                                    &&GlobalClass.userDetail.smsAccessToken!=""
                                    &&GlobalClass.userDetail.smsApiUrl!=""
                                    &&GlobalClass.userDetail.smsUserId!=""
                                    &&GlobalClass.userDetail.smsMobileNo!=""
                                ){
                                  Navigator.of(_).pop();
                                  showDialog(context: context, builder: (_)=>new AlertDialog(
                                    title: Text("Confirm Send"),
                                    content: Text("Are you sure to send a reminder to ${widget.client.name}?"),
                                    actions: [
                                      ActionChip(label: Text("Yes"), onPressed: (){
                                        try{
                                          postForBulkMessage([widget.client],"${GlobalClass.userDetail.reminderMessage!=null&&GlobalClass.userDetail.reminderMessage!=""?GlobalClass.userDetail.reminderMessage:"Your subscription has come to an end"
                                              ", please clear your dues for further continuation of services."}");
                                          globalShowInSnackBar(scaffoldMessengerKey,"Message Sent!!");
                                        }
                                        catch(E){
                                          globalShowInSnackBar(scaffoldMessengerKey,"Something Went Wrong!!");
                                        }
                                        Navigator.of(_).pop();
                                      }),
                                      ActionChip(label: Text("No"), onPressed: (){
                                        Navigator.of(_).pop();
                                      })
                                    ],
                                  ));
                                }
                                else{
                                  globalShowInSnackBar(scaffoldMessengerKey, "Please configure Sms Gateway Data in Settings.");
                                  Navigator.of(_).pop();
                                }
                              }),],));
                }),
                ModalOptionModel(particulars: "WhatsApp",icon:FontAwesomeIcons.whatsappSquare,iconColor:CustomColors.whatsAppGreen, onTap: () async {
                  Navigator.pop(popupContext);
                  whatsAppModule(widget.client, scaffoldMessengerKey);
                }),
                if(this.widget.client.due>-1)ModalOptionModel(particulars: "Add Due",iconColor:CustomColors.addDueIconColor,icon: Icons.more_time,onTap: (){
                  Navigator.pop(popupContext);
                  addDueModule(this.widget.client,this);
                }),
                ModalOptionModel(particulars: "Add Payment",icon: Icons.payment,iconColor:CustomColors.addPaymentIconColor,onTap: (){
                  Navigator.pop(popupContext);
                  addPaymentModule(this.widget.client,context,scaffoldMessengerKey,this);
                }),
                ModalOptionModel(particulars: "Delete",icon: Icons.delete,iconColor:CustomColors.deleteIconColor,onTap: (){
                  Navigator.pop(popupContext);
                  deleteModule(widget.client, context, this);
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
                          widget.client.startDate=startDateTemp;
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
                      startDateTemp=value;
                      try{
                        int months=int.parse(paymentNumberTextField.text);
                        widget.client.startDate=startDateTemp;
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