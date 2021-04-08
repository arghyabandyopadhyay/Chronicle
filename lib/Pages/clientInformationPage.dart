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
  final ClientModel? user;
  const ClientInformationPage({ Key? key,this.user}) : super(key: key);
  @override
  _ClientInformationPageState createState() => _ClientInformationPageState();
}

class _ClientInformationPageState extends State<ClientInformationPage> {
  late Future<dynamic> _futureProfile;
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
  String? sexDropDown;
  String? casteDropDown;
  bool isLoading=false;
  final focus = FocusNode();
  int counter=0;
  String? _validateName(String? value) {
    if(value!.isEmpty)nameTextField.text="";
    return null;
  }
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Future<void> _handleSubmitted() async {
    final form = _formKey.currentState;
    if (!form!.validate()) {
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
                    widget.user!.sex=sexDropDown;
                    widget.user!.caste=casteDropDown;
                    updateClient(widget.user!,widget.user!.id!);
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
      phoneNumberTextField.text=widget.user!.mobileNo!=null?widget.user!.mobileNo!:"";
      nameTextField.text=widget.user!.name!=null?widget.user!.name!:"";
      dueTextField.text=widget.user!.due!=null?widget.user!.due!.toString():"";
      addressTextField.text=widget.user!.address!=null?widget.user!.address!:"";
      fathersNameTextField.text=widget.user!.fathersName!=null?widget.user!.fathersName!:"";
      educationTextField.text=widget.user!.education!=null?widget.user!.education!:"";
      occupationTextField.text=widget.user!.occupation!=null?widget.user!.occupation!:"";
      injuriesTextField.text=widget.user!.injuries!=null?widget.user!.injuries!:"";
      registrationIdTextField.text=widget.user!.registrationId!=null?widget.user!.registrationId!:widget.user!.id!.key;
      heightTextField.text=widget.user!.height!=null?widget.user!.height!.toStringAsFixed(2):"";
      weightTextField.text=widget.user!.weight!=null?widget.user!.weight!.toStringAsFixed(2):"";
      sexDropDown=widget.user!.sex;
      casteDropDown=widget.user!.caste;

      counter++;
    }
    return ScaffoldMessenger(child: Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(widget.user!.name!=null?widget.user!.name!:"Client Profile",),
        actions: [
          Center(child: Text(widget.user!.due.toString()+"  ",style: TextStyle(color: widget.user!.due!=null&&widget.user!.due==0?Colors.green:Colors.red,fontWeight: FontWeight.bold,fontSize: 30),),)        ],
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
                    if(widget.user!.mobileNo!=null&&widget.user!.mobileNo!="")
                    {
                      var url = 'tel:<${widget.user!.mobileNo}>';
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        throw 'Could not launch $url';
                      }
                    }
                  },),
                  IconButton(icon: Icon(Icons.send,color: Colors.lightBlueAccent), onPressed: () async {
                    if(widget.user!.mobileNo!=null&&widget.user!.mobileNo!="")
                    {
                      var url = "https://wa.me/+91${widget.user!.mobileNo}?text=${widget.user!.name}, Your subscription has come to an end"
                          ", please clear your dues for further continuation of services.";
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        throw 'Could not launch $url';
                      }
                    }
                  },),
                  IconButton(icon: Icon(this.widget.user!.due!>-1?Icons.more_time:Icons.remove_circle,color: Colors.red), onPressed: () async {
                    setState(() {
                      this.widget.user!.due=this.widget.user!.due!+1;
                      if(this.widget.user!.due!<=1){
                        this.widget.user!.startDate=this.widget.user!.startDate!.add(Duration(days: getDuration(this.widget.user!.startDate!.month,this.widget.user!.startDate!.year,1)));
                      }
                      if(this.widget.user!.due!>=1)
                      {
                        this.widget.user!.endDate=this.widget.user!.endDate!.add(Duration(days: getDuration(this.widget.user!.startDate!.month,this.widget.user!.startDate!.year,1)));
                      }
                      updateClient(this.widget.user!, this.widget.user!.id!);
                      // widget.user!.due=widget.user!.due!+1;
                      // this.widget.user!.endDate=this.widget.user!.endDate!.add(Duration(days: getNoOfDays(this.widget.user!.endDate!.month,this.widget.user!.endDate!.year)));
                      // updateClient(widget.user!, widget.user!.id!);
                    });
                  }),
                  IconButton(icon: Icon(Icons.payment,color: Colors.green), onPressed: () {
                    showDialog(context: context, builder: (_) =>new AddQuantityDialog()
                    ).then((value) {
                      int intVal=int.parse(value.toString());
                      setState(() {
                        this.widget.user!.due=this.widget.user!.due!-intVal;
                        if(this.widget.user!.due!>0){
                          this.widget.user!.startDate=this.widget.user!.startDate!.add(Duration(days: getDuration(this.widget.user!.startDate!.month,this.widget.user!.startDate!.year,intVal)));
                        }
                        else if(this.widget.user!.due!<0)
                        {
                          this.widget.user!.endDate=this.widget.user!.endDate!.add(Duration(days: getDuration(this.widget.user!.startDate!.month,this.widget.user!.startDate!.year,intVal)));
                        }
                        updateClient(this.widget.user!, this.widget.user!.id!);
                        // widget.user!.due=widget.user!.due!-intVal>=0?widget.user!.due!-intVal:0;
                        // this.widget.user!.startDate=this.widget.user!.startDate!.add(Duration(days: getDuration(this.widget.user!.startDate!.month,this.widget.user!.startDate!.year,intVal)));
                        // updateClient(widget.user!, widget.user!.id!);
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
                            deleteDatabaseNode(widget.user!.id!);
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
                      widget.user!.registrationId = value;
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
                      widget.user!.name = value;
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
                      widget.user!.fathersName = value;
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
                    initialValue: widget.user!.dob,
                    mode: DateTimeFieldPickerMode.date,
                    autovalidateMode: AutovalidateMode.always,
                    onDateSelected: (DateTime value) {
                      widget.user!.dob=value;
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
                      widget.user!.mobileNo = value;
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
                      widget.user!.address = value;
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
                      onChanged: (String? newValue) {
                        setState(() {
                          sexDropDown = newValue;
                        });
                      },
                      items: <String>['Male', 'Female', 'Trans', 'Prefer not to say']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value,style: TextStyle(color: Theme.of(context).textTheme.headline1!.color),),
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
                      onChanged: (String? newValue) {
                        setState(() {
                          casteDropDown = newValue;
                        });
                      },
                      items: <String>['General', 'OBC', 'SC/ST']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value,style: TextStyle(color: Theme.of(context).textTheme.headline1!.color),),
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
                      widget.user!.weight = double.parse(value!);
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
                      widget.user!.height = double.parse(value!);
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
                      widget.user!.injuries = value;
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
                    widget.user!.education = value;
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
                    widget.user!.occupation = value;
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
                  initialValue: widget.user!.startDate,
                  mode: DateTimeFieldPickerMode.date,
                  autovalidateMode: AutovalidateMode.always,
                  onDateSelected: (DateTime value) {
                    widget.user!.startDate=value;
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
                  initialValue: widget.user!.endDate,
                  mode: DateTimeFieldPickerMode.date,
                  autovalidateMode: AutovalidateMode.always,
                  onDateSelected: (DateTime value) {
                    widget.user!.endDate=value;
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
  messengerState.currentState!.hideCurrentSnackBar();
  messengerState.currentState!.showSnackBar(new SnackBar(content: Text(content)));
}