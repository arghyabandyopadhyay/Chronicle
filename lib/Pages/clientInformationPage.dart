import 'package:chronicle/Models/clientModel.dart';
import 'package:chronicle/Modules/universalModule.dart';
import 'package:chronicle/Widgets/addQuantityDialog.dart';
import 'package:chronicle/Modules/database.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../customColors.dart';

class ClientInformationPage extends StatefulWidget {
  final ClientModel client;
  const ClientInformationPage({ Key key,this.client}) : super(key: key);
  @override
  _ClientInformationPageState createState() => _ClientInformationPageState();
}

class _ClientInformationPageState extends State<ClientInformationPage> {
  Future<dynamic> _futureProfile;
  GlobalKey<ScaffoldMessengerState> scaffoldKey=new GlobalKey<ScaffoldMessengerState>();
  dynamic _profile;
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
  String sexDropDown;
  String casteDropDown;
  bool isLoading=false;
  final focus = FocusNode();
  int counter=0;
  String _validateName(String value) {
    if(value.isEmpty)nameTextField.text="";
    return null;
  }
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Future<void> _handleSubmitted() async {
    final form = _formKey.currentState;
    if (!form.validate()) {
    }
    else {
      form.save();
      showDialog(context: context,
          builder: (BuildContext context){
            return new AlertDialog(
                title: Text("Confirm Save"),
                content: Text("Are you sure to save changes?"),
                actions: [
                  ActionChip(label: Text("Yes"), onPressed: (){
                    Navigator.pop(context);
                    setState(() {
                      isLoading=true;
                    });
                    widget.client.sex=sexDropDown;
                    widget.client.caste=casteDropDown;
                    updateClient(widget.client,widget.client.id);
                  }),
                  ActionChip(label: Text("No"), onPressed: (){
                    setState(() {
                      Navigator.of(context).pop();
                    });
                  })
                ],
            );
          }
      );
    }
  }

  @override
  void initState() {
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
        elevation: 0,
        title: Text(widget.client.name!=null?widget.client.name:"Client Profile",),
        actions: [
          Center(child: Text(widget.client.due.abs().toString()+"  ",style: TextStyle(color: this.widget.client.due!=null&&this.widget.client.due==0?null:this.widget.client.due>0?Colors.red:Colors.green,fontWeight: FontWeight.bold,fontSize: 30),),)        ],
      ),
      body: Column(
        children: [
          Expanded(child: Form(
            key:_formKey,
            child: ListView(
              shrinkWrap: true,
              physics:BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 5),
              children: [
                Row(mainAxisAlignment:MainAxisAlignment.spaceAround, children: [
                  IconButton(icon: Icon(Icons.call,color: Colors.yellowAccent), onPressed: () async {
                    if(widget.client.mobileNo!=null&&widget.client.mobileNo!="")
                    {
                      var url = 'tel:<${widget.client.mobileNo}>';
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        throw 'Could not launch $url';
                      }
                    }
                  },),
                  IconButton(icon: Icon(Icons.send,color: Colors.lightBlueAccent), onPressed: () async {
                    if(widget.client.mobileNo!=null&&widget.client.mobileNo!="")
                    {
                      var url = "https://wa.me/+91${widget.client.mobileNo}?text=${widget.client.name}, Your subscription has come to an end"
                          ", please clear your dues for further continuation of services.";
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        throw 'Could not launch $url';
                      }
                    }
                  },),
                  IconButton(icon: Icon(this.widget.client.due>-1?Icons.more_time:Icons.remove_circle,color: Colors.red), onPressed: () async {
                    setState(() {
                      this.widget.client.due=this.widget.client.due+1;
                      if(this.widget.client.due<=1){
                        this.widget.client.startDate=this.widget.client.startDate.add(Duration(days: getDuration(this.widget.client.startDate.month,this.widget.client.startDate.year,1)));
                      }
                      if(this.widget.client.due>=1)
                      {
                        this.widget.client.endDate=this.widget.client.endDate.add(Duration(days: getDuration(this.widget.client.startDate.month,this.widget.client.startDate.year,1)));
                      }
                      this.widget.client.notificationCount=0;
                      updateClient(this.widget.client, this.widget.client.id);
                      // widget.client!.due=widget.client!.due!+1;
                      // this.widget.client!.endDate=this.widget.client!.endDate!.add(Duration(days: getNoOfDays(this.widget.client!.endDate!.month,this.widget.client!.endDate!.year)));
                      // updateClient(widget.client!, widget.client!.id!);
                    });
                  }),
                  IconButton(icon: Icon(Icons.payment,color: Colors.green), onPressed: () {
                    showDialog(context: context, builder: (_) =>new AddQuantityDialog()
                    ).then((value) {
                      int intVal=int.parse(value.toString());
                      setState(() {
                        this.widget.client.due=this.widget.client.due-intVal;
                        if(this.widget.client.due>0){
                          this.widget.client.startDate=this.widget.client.startDate.add(Duration(days: getDuration(this.widget.client.startDate.month,this.widget.client.startDate.year,intVal)));
                        }
                        else if(this.widget.client.due<0)
                        {
                          this.widget.client.endDate=this.widget.client.endDate.add(Duration(days: getDuration(this.widget.client.startDate.month,this.widget.client.startDate.year,intVal)));
                        }
                        this.widget.client.notificationCount=0;
                        updateClient(this.widget.client, this.widget.client.id);
                        // widget.client!.due=widget.client!.due!-intVal>=0?widget.client!.due!-intVal:0;
                        // this.widget.client!.startDate=this.widget.client!.startDate!.add(Duration(days: getDuration(this.widget.client!.startDate!.month,this.widget.client!.startDate!.year,intVal)));
                        // updateClient(widget.client!, widget.client!.id!);
                      });
                    });

                  },),
                  IconButton(icon: Icon(Icons.delete,color: Colors.deepOrange), onPressed: (){
                    showDialog(context: context, builder: (_)=>new AlertDialog(
                      title: Text("Confirm Delete"),
                      content: Text("Are you sure?"),
                      actions: [
                        ActionChip(label: Text("Yes"), onPressed: (){
                          setState(() {
                            deleteDatabaseNode(widget.client.id);
                            Navigator.of(context).pop();
                          });
                        }),
                        ActionChip(label: Text("No"), onPressed: (){
                          setState(() {
                            Navigator.of(context).pop();
                          });
                        })
                      ],
                    ));
                  }),
                ],),
                SizedBox(height: 20,),
                Row(children:[
                  CircleAvatar(
                    radius: 25,
                    child: Image.asset(
                      'assets/firebase_logo.png',
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
                      labelText: "Registration Id",
                      contentPadding:
                      EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0),
                    ),
                    enabled: false,
                    onSaved: (value) {
                      widget.client.registrationId = value;
                    },
                  ),),]),
                SizedBox(height: 15,),
                Row(children:[
                  CircleAvatar(
                    radius: 25,
                    child: Image.asset(
                      'assets/firebase_logo.png',
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
                      'assets/firebase_logo.png',
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
                    validator: _validateName,
                  ),),]),
                SizedBox(height: 15,),
                Row(children:[
                  CircleAvatar(
                    radius: 25,
                    child: Image.asset(
                      'assets/firebase_logo.png',
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
                      'assets/firebase_logo.png',
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
                              throw 'Could not launch $url';
                            }
                          }
                          else globalShowInSnackBar(scaffoldKey, "Please enter the mobile no");
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
                  ),),]),
                SizedBox(height: 15,),
                Row(children:[
                  CircleAvatar(
                    radius: 25,
                    child: Image.asset(
                      'assets/firebase_logo.png',
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
                SizedBox(height: 15,),
                Row(children:[
                  CircleAvatar(
                    radius: 25,
                    child: Image.asset(
                      'assets/firebase_logo.png',
                      height: 30,
                    ),
                    backgroundColor: Colors.transparent,
                  ),Expanded(child:
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        border: Border.all(width: 0.7), borderRadius: BorderRadius.all(Radius.circular(4.0))
                    ),
                    child: DropdownButton<String>(dropdownColor: Theme.of(context).scaffoldBackgroundColor,
                      hint: Container(child: Text("Sex:"),width: MediaQuery.of(context).size.width-110),
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
                SizedBox(height: 15,),
                Row(children:[
                  CircleAvatar(
                    radius: 25,
                    child: Image.asset(
                      'assets/firebase_logo.png',
                      height: 30,
                    ),
                    backgroundColor: Colors.transparent,
                  ),Expanded(child:
                  Container(
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
                SizedBox(height: 15,),
                Row(children:[
                  CircleAvatar(
                    radius: 25,
                    child: Image.asset(
                      'assets/firebase_logo.png',
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
                      widget.client.weight = double.parse(value);
                    },
                  ),),]),
                SizedBox(height: 15,),
                Row(children:[
                  CircleAvatar(
                    radius: 25,
                    child: Image.asset(
                      'assets/firebase_logo.png',
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
                      widget.client.height = double.parse(value);
                    },
                  ),),]),
                SizedBox(height: 15,),
                Row(children:[
                  CircleAvatar(
                    radius: 25,
                    child: Image.asset(
                      'assets/firebase_logo.png',
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
                      'assets/firebase_logo.png',
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
                      'assets/firebase_logo.png',
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
                'assets/firebase_logo.png',
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
                    widget.client.startDate=value;
                  },
                ),),]),
                SizedBox(height: 8,),
                Row(children:[
                  CircleAvatar(
                    radius: 25,
                    child: Image.asset(
                      'assets/firebase_logo.png',
                      height: 30,
                    ),
                    backgroundColor: Colors.transparent,
                  ),Expanded(child:DateTimeFormField(
                  decoration: const InputDecoration(
                    hintStyle: TextStyle(),
                    errorStyle: TextStyle(),
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.event_note),
                    labelText: 'End Date',
                  ),
                  initialValue: widget.client.endDate,
                  mode: DateTimeFieldPickerMode.date,
                  autovalidateMode: AutovalidateMode.always,
                  onDateSelected: (DateTime value) {
                    widget.client.endDate=value;
                  },
                ),),]),
                SizedBox(height: 15,),
              ],
            ),))
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: (){
            _handleSubmitted();
          }, label: Text("Save"),icon: Icon(Icons.save,),),

      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    ),key: scaffoldKey,);
  }

  @override
  void dispose() {
    super.dispose();
  }
}

void globalShowInSnackBar(GlobalKey<ScaffoldMessengerState> messengerState,String content)
{
  messengerState.currentState.hideCurrentSnackBar();
  messengerState.currentState.showSnackBar(new SnackBar(content: Text(content)));
}