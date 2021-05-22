import 'package:chronicle/Models/CourseModels/courseModel.dart';
import 'package:chronicle/Models/CourseModels/videoIndexModel.dart';
import 'package:chronicle/Modules/database.dart';
import 'package:chronicle/Modules/universalModule.dart';
import 'package:chronicle/Pages/TutorPages/CoursesByMePages/editVideoPage.dart';
import 'package:chronicle/Pages/TutorPages/CoursesByMePages/videosPage.dart';
import 'package:chronicle/Widgets/editCourseVideosList.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class AddCoursesPage extends StatefulWidget {
  final Function(CourseModel) callback;
  const AddCoursesPage({ Key key,this.callback}) : super(key: key);
  @override
  _AddCoursesPageState createState() => _AddCoursesPageState();
}
class _AddCoursesPageState extends State<AddCoursesPage> {
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  CourseModel courseData = CourseModel();
  DateTime now,today;
  var monthsTextField=TextEditingController();
  var titleTextField=TextEditingController();
  var authorPriceTextField=TextEditingController();
  var descriptionTextField=TextEditingController();
  var whatWillTextField=TextEditingController();
  final focus = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  //Functions
  void _handleSubmitted() {
    final form = _formKey.currentState;
    if (!form.validate()) {// Start validating on every change.
    }
    else {
      form.save();
      widget.callback(courseData);
      Navigator.pop(context);
      FocusScope.of(context).unfocus();
    }
  }
  String _validateTitle(String value) {
    if(value.isEmpty)return "required fields can't be left empty";
    return null;
  }
  String _validateDescription(String value) {
    if(value.isEmpty)return "required fields can't be left empty";
    return null;
  }
  //Overrides
  @override
  void initState() {
    monthsTextField.text="1";
    now=DateTime.now();
    today=DateTime(now.year,now.month,now.day);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    const sizedBoxSpace = SizedBox(height: 100);
    return ScaffoldMessenger(child: Scaffold(
      appBar: AppBar(
        title: Text("Add Courses",),
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
                      'assets/payment.png',
                      height: 30,
                    ),
                    backgroundColor: Colors.transparent,
                  ),Expanded(child: TextFormField(
                    controller: monthsTextField,
                    textInputAction: TextInputAction.next,
                    autovalidateMode: AutovalidateMode.always,
                    style: TextStyle(),
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: "Duration of the course(in months)",
                      contentPadding:
                      EdgeInsets.only( left: 10.0, right: 10.0),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value){
                      if(value.isEmpty)return "required fields can't be left empty";
                      else if(value=="0") return "Duration of the course in months  cant be 0!!";
                      else {
                        try{
                          int months=int.parse(value);
                          if(months<0){
                            return "Duration of the course in months can't be Negative!!";
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
                        courseData.coursePackageDurationInMonths= months;
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
                    controller: titleTextField,
                    textInputAction: TextInputAction.next,
                    style: TextStyle(),
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: "Title",
                      contentPadding:
                      EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0),
                    ),
                    validator: _validateTitle,
                    onSaved: (value) {
                      courseData.title = value;
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
                          helperText: "Type the description to your course",
                          contentPadding:
                          EdgeInsets.all(10.0),
                        ),
                        validator: _validateDescription,
                        onSaved: (value) {
                          courseData.description = value;
                        },
                      )
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
                  ),Expanded(child: Container(
                      height: 150,
                      child: TextFormField(
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        maxLengthEnforcement: MaxLengthEnforcement.enforced,
                        maxLength: 200,
                        controller: whatWillTextField,
                        textInputAction: TextInputAction.newline,
                        style: TextStyle(),
                        expands: true,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: "What will the users learn",
                          contentPadding:
                          EdgeInsets.all(10.0),
                        ),
                        validator: _validateDescription,
                        onSaved: (value) {
                          courseData.whatWillYouLearn = value;
                        },
                      )
                  )),]),
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
                    controller: authorPriceTextField,
                    keyboardType:TextInputType.number,
                    textInputAction: TextInputAction.next,
                    style: TextStyle(),
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: "Author's Price",
                      helperText: "This is the price that you charge for this course per enrollment. "
                          "The end price may vary according to the server maintenance cost."
                          "The amount credited to your account will be 90% of the price that you specify here.",
                      contentPadding:
                      EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0),
                    ),
                    validator: _validateDescription,
                    onSaved: (value) {
                      if(value.isNotEmpty)courseData.authorPrice = double.parse(value);
                    },
                  ),),]),
                SizedBox(height: 8,),
                Row(children: [Expanded(child:Text("  Add Preview Video:",style: TextStyle(fontWeight: FontWeight.bold),) ),IconButton(icon: Icon((this.courseData.previewVideo!=null)?Icons.swap_horizontal_circle_outlined:Icons.add),onPressed: (){
                  showModalBottomSheet(context: context, builder: (addVideosBottomSheet){
                    return VideosPage(true,true);
                  }).then((value) {
                    if(value!=null)setState(() {
                      courseData.previewVideo=value.first;
                      courseData.previewThumbnailUrl=courseData.previewVideo.thumbnailUrl;
                    });
                  });
                },)],),
                SizedBox(height: 8,),
                if(this.courseData.previewVideo!=null)EditCourseVideosList(
                  listItems:[this.courseData.previewVideo],
                  scaffoldMessengerKey: scaffoldMessengerKey,
                  onTapList: (index){
                  },
                  onButtonTapped: (index){
                    setState(() {
                      this.courseData.previewVideo=null;
                    });
                  },
                ),
                SizedBox(height: 8,),
                Row(children: [Expanded(child:Text("  Add Videos:",style: TextStyle(fontWeight: FontWeight.bold),) ),IconButton(icon: Icon(Icons.add),onPressed: (){
                  showModalBottomSheet(context: context, builder: (addVideosBottomSheet){
                    return VideosPage(false,true);
                  }).then((value) {
                    if(value!=null)setState(() {
                      if(this.courseData.videos!=null)this.courseData.videos.addAll(value.toList());
                      else this.courseData.videos=value;
                    });
                  });
                },)],),
                SizedBox(height: 8,),
                if(this.courseData.videos!=null)EditCourseVideosList(
                  listItems:this.courseData.videos,
                  scaffoldMessengerKey: scaffoldMessengerKey,
                  onTapList: (index){
                  },
                  onButtonTapped: (index){
                    setState(() {
                      this.courseData.videos.removeAt(index);
                    });
                  },
                ),

                sizedBoxSpace,
              ],
            ),
          ),
        ),
      ),
      floatingActionButton:FloatingActionButton.extended(
        icon: Icon(Icons.drive_folder_upload),
        label: Text("Upload",),
        onPressed: _handleSubmitted,
      ),
      floatingActionButtonLocation:
      FloatingActionButtonLocation.endFloat,
    ),key: scaffoldMessengerKey,);
  }
}