
import 'package:chronicle/Modules/universalModule.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
class AddVideoPage extends StatefulWidget {
  final Function(String filePath,String thumnailFilePath,String name,String description,String masterFilter) callback;
  const AddVideoPage({Key key, this.callback}) : super(key: key);
  @override
  _AddVideoPageState createState() => _AddVideoPageState();
}
class _AddVideoPageState extends State<AddVideoPage> {
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  DateTime now,today;
  var nameTextField=TextEditingController();
  var descriptionTextField=TextEditingController();
  var keyWordsTextField=TextEditingController();
  var fileTextField=TextEditingController();
  var thumbnailTextField=TextEditingController();
  PickedFile file ;
  PickedFile thumbnailFile ;
  final focus = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  //Functions
  void _handleSubmitted() {
    final form = _formKey.currentState;
    if (!form.validate()) {
      if(fileTextField.text.isEmpty)globalShowInSnackBar(scaffoldMessengerKey, "Please upload a video to proceed!!");
    }
    else {
      form.save();
      widget.callback(fileTextField.text,thumbnailTextField.text,nameTextField.text.replaceAll(new RegExp(r'[^\s\w]+'),""),descriptionTextField.text,keyWordsTextField.text.toLowerCase().replaceAll(new RegExp(r'[^\s\w]+'),"")+nameTextField.text.toLowerCase().replaceAll(new RegExp(r'[^\s\w]+'),""));
      Navigator.pop(context);
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
    now=DateTime.now();
    today=DateTime(now.year,now.month,now.day);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    const sizedBoxSpace = SizedBox(height: 100);
    return ScaffoldMessenger(child: Scaffold(
      appBar: AppBar(
        title: Text("Upload Video",),
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
                  ),Expanded(child: TextFormField(
                    textCapitalization: TextCapitalization.words,
                    controller: nameTextField,
                    textInputAction: TextInputAction.next,
                    style: TextStyle(),
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: "Title",
                      contentPadding:
                      EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0),
                    ),
                    validator: _validateName,
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
                  ),Expanded(child: Container(
                      height: 150,
                      child: TextFormField(
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        maxLengthEnforcement: MaxLengthEnforcement.enforced,
                        maxLength: 200,
                        controller: descriptionTextField,
                        textInputAction: TextInputAction.newline,
                        style: TextStyle(),
                        expands: true,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: "Description",
                          helperText: "Type the description to your video",
                          contentPadding:
                          EdgeInsets.all(10.0),
                        ),
                        validator: _validateName,
                      )
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
                    controller: keyWordsTextField,
                    textInputAction: TextInputAction.next,
                    style: TextStyle(),
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: "Keywords",
                      helperText: "Separate the keywords using \",\"",
                      contentPadding:
                      EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0),
                    ),
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
                    enabled: false,
                    textCapitalization: TextCapitalization.words,
                    controller: fileTextField,
                    textInputAction: TextInputAction.next,
                    style: TextStyle(),
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: "FilePath",
                      contentPadding:
                      EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0),
                    ),
                    validator: _validateName,
                  ),),IconButton(icon:Icon(Icons.video_call_outlined),onPressed: ()async{
                    file=await ImagePicker().getVideo(source: ImageSource.gallery,maxDuration: const Duration(seconds: 300),);
                    setState(() {
                      fileTextField.text=file.path;
                    });
                  },),
                ]),
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
                    enabled: false,
                    textCapitalization: TextCapitalization.words,
                    controller: thumbnailTextField,
                    textInputAction: TextInputAction.next,
                    style: TextStyle(),
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: "Thumbnail",
                      helperText: "If left empty, thumbnail will be automatically generated.",
                      contentPadding:
                      EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0),
                    ),
                  ),),
                  if(thumbnailTextField.text.isEmpty)IconButton(icon:Icon(Icons.insert_photo_outlined),onPressed: ()async{
                    thumbnailFile=await ImagePicker().getImage(source: ImageSource.gallery,);
                    setState(() {
                      thumbnailTextField.text=thumbnailFile.path;
                    });
                  },)
                  else IconButton(icon:Icon(Icons.remove_circle),onPressed: ()async{
                    setState(() {
                      thumbnailTextField.text="";
                      thumbnailFile=null;
                    });
                  },)
                ]),
                SizedBox(height: 8,),
                sizedBoxSpace,
              ],
            ),
          ),
        ),
      ),
      floatingActionButton:FloatingActionButton.extended(
        heroTag: "uploadVideoHeroTag",
        icon: Icon(Icons.add),
        label: Text("Upload",),
        onPressed: _handleSubmitted,
      ),
      floatingActionButtonLocation:
      FloatingActionButtonLocation.endFloat,
    ),key: scaffoldMessengerKey,);
  }
}