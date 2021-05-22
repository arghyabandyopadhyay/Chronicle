import 'package:chronicle/Models/CourseModels/videoIndexModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
class EditVideoPage extends StatefulWidget {
  final VideoIndexModel videoIndex;
  final Function(VideoIndexModel videoIndex,int index) callback;
  final int index;
  EditVideoPage({Key key, this.callback,this.videoIndex, this.index}) : super(key: key);
  @override
  _EditVideoPageState createState() => _EditVideoPageState();
}
class _EditVideoPageState extends State<EditVideoPage> {
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  DateTime now,today;
  var nameTextField=TextEditingController();
  var descriptionTextField=TextEditingController();
  var keyWordsTextField=TextEditingController();
  PickedFile file ;
  final focus = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  //Functions
  void _handleSubmitted() {
    final form = _formKey.currentState;
    if (!form.validate()) {
    }
    else {
      form.save();
      VideoIndexModel video=VideoIndexModel(
          name: nameTextField.text.replaceAll(new RegExp(r'[^\s\w]+'),""),
          description: descriptionTextField.text,
          masterFilter: keyWordsTextField.text.toLowerCase().replaceAll(new RegExp(r'[^\s\w]+'),"")+nameTextField.text.toLowerCase().replaceAll(new RegExp(r'[^\s\w]+'),""),
          downloadUrl: widget.videoIndex.downloadUrl,
          thumbnailUrl: widget.videoIndex.thumbnailUrl,
          thumbnailSize: widget.videoIndex.thumbnailSize,
          cloudStorageSize: widget.videoIndex.cloudStorageSize,
          directory: widget.videoIndex.directory
      );
      video.setId(widget.videoIndex.id);
      widget.callback(video,widget.index);
      Navigator.of(context).pop();
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
    nameTextField.text=widget.videoIndex.name;
    descriptionTextField.text=widget.videoIndex.description;
  }
  @override
  Widget build(BuildContext context) {
    const sizedBoxSpace = SizedBox(height: 100);
    return ScaffoldMessenger(child: Scaffold(
      appBar: AppBar(
        title: Text("Edit Video",),
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
                sizedBoxSpace,
              ],
            ),
          ),
        ),
      ),
      floatingActionButton:FloatingActionButton.extended(
        icon: Icon(Icons.save_outlined),
        label: Text("Save",),
        onPressed: _handleSubmitted,
      ),
      floatingActionButtonLocation:
      FloatingActionButtonLocation.endFloat,
    ),key: scaffoldMessengerKey,);
  }
}