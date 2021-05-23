import 'package:chronicle/Models/CourseModels/courseIndexModel.dart';
import 'package:chronicle/Models/CourseModels/courseModel.dart';
import 'package:chronicle/Models/CourseModels/videoIndexModel.dart';
import 'package:chronicle/Models/modalOptionModel.dart';
import 'package:chronicle/Modules/database.dart';
import 'package:chronicle/Modules/universalModule.dart';
import 'package:chronicle/Pages/TutorPages/CoursesByMePages/videosPage.dart';
import 'package:chronicle/Widgets/Simmers/loaderWidget.dart';
import 'package:chronicle/Widgets/editCourseVideosList.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../coursePreviewPage.dart';
import 'editVideoPage.dart';


class EditCoursesPage extends StatefulWidget {
  final CourseIndexModel course;
  const EditCoursesPage({ Key key,this.course}) : super(key: key);
  @override
  _EditCoursesPageState createState() => _EditCoursesPageState();
}
class _EditCoursesPageState extends State<EditCoursesPage> {
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  CourseModel courseDetail;
  DateTime now,today;
  var monthsTextField=TextEditingController();
  var titleTextField=TextEditingController();
  var authorPriceTextField=TextEditingController();
  var descriptionTextField=TextEditingController();
  var whatWillTextField=TextEditingController();
  var registrationIdTextField=TextEditingController();
  final focus = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  //Functions
  Future<void> _handleSubmitted() async {
    final form = _formKey.currentState;
    if (!form.validate()) {// Start validating on every change.
    }
    else {
      form.save();
      showDialog(context: context,
          builder: (BuildContext context1){
            return new AlertDialog(
              title: Text("Confirm Save"),
              content: Text("Are you sure to save changes?"),
              actions: [
                ActionChip(label: Text("Yes"), onPressed: () async {
                  Navigator.pop(context1);
                  await updateCourse(courseDetail,widget.course);
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
    now=DateTime.now();
    today=DateTime(now.year,now.month,now.day);
    getCourseDetails();
    super.initState();
  }
  updateVideoDetails(VideoIndexModel videoIndexModel,int index)
  {
    setState(() {
      renameVideo(videoIndexModel,videoIndexModel.id);
      if(index!=-3)this.courseDetail.videos[index]=videoIndexModel;
      else this.courseDetail.previewVideo=videoIndexModel;
    });
    globalShowInSnackBar(scaffoldMessengerKey, "Changes made to ${videoIndexModel.name} has been saved!!");
  }
  void getCourseDetails() {
    getCourse(widget.course).then((courseDetail) => {
      if(mounted)this.setState(() {
        this.courseDetail = courseDetail;
         monthsTextField.text=courseDetail.coursePackageDurationInMonths.toString();
         titleTextField.text=courseDetail.title;
         authorPriceTextField.text=courseDetail.authorPrice.toString();
         descriptionTextField.text=courseDetail.description;
         whatWillTextField.text=courseDetail.whatWillYouLearn;
      })
    });
  }
  @override
  Widget build(BuildContext context) {
    const sizedBoxSpace = SizedBox(height: 100);
    return ScaffoldMessenger(child: Scaffold(
      appBar: AppBar(
        title: Text(widget.course.title,),
      ),
      body: courseDetail!=null?Form(
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
                    enabled: false,
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
                        courseDetail.coursePackageDurationInMonths= months;
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
                      courseDetail.title = value;
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
                          courseDetail.description = value;
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
                          courseDetail.whatWillYouLearn = value;
                        },
                      )
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
                    enabled: false,
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
                    onSaved: (value) {
                      if(value.isNotEmpty)courseDetail.authorPrice = double.parse(value);
                    },
                  ),),]),
                SizedBox(height: 8,),
                Row(children: [Expanded(child:Text("  Add Preview Video:",style: TextStyle(fontWeight: FontWeight.bold),) ),IconButton(icon: Icon((this.courseDetail.previewVideo!=null)?Icons.swap_horizontal_circle_outlined:Icons.add),onPressed: (){
                  showModalBottomSheet(context: context, builder: (addVideosBottomSheet){
                    return VideosPage(true,true);
                  }).then((value) {
                    if(value!=null)setState(() {
                      this.courseDetail.updateCoursePreviewVideoIndex(value.first);
                      // courseDetail.previewVideo=value.first;
                      // courseDetail.previewThumbnailUrl=courseDetail.previewVideo.thumbnailUrl;
                    });
                  });
                },)],),
                SizedBox(height: 8,),
                if(this.courseDetail.previewVideo!=null)EditCourseVideosList(
                  listItems:[this.courseDetail.previewVideo],
                  scaffoldMessengerKey: scaffoldMessengerKey,
                  onTapList: (index){
                    Navigator.of(context).push(CupertinoPageRoute(
                        builder: (editPageContext)=>
                            EditVideoPage(callback:this.updateVideoDetails,videoIndex: this.courseDetail.previewVideo,index:-3)));
                  },
                  onButtonTapped: (index){
                    setState(() {
                      this.courseDetail.deleteCoursePreviewVideoIndex();
                    });
                  },
                ),
                SizedBox(height: 8,),
                Row(children: [Expanded(child:Text("  Add Videos:",style: TextStyle(fontWeight: FontWeight.bold),) ),IconButton(icon: Icon(Icons.add),onPressed: (){
                  showModalBottomSheet(context: context, builder: (addVideosBottomSheet){
                        return VideosPage(false,true);
                      }).then((value) {
                        if(value!=null)setState(() {
                          value.forEach((element){
                            this.courseDetail.addCourseVideoIndex(element);
                          });
                        });
                      });
                },)],),
                SizedBox(height: 8,),
                if(this.courseDetail.videos!=null)EditCourseVideosList(
                  listItems:this.courseDetail.videos,
                  scaffoldMessengerKey: scaffoldMessengerKey,
                  onTapList: (index){
                    Navigator.of(context).push(CupertinoPageRoute(
                        builder: (editPageContext)=>
                            EditVideoPage(callback:this.updateVideoDetails,videoIndex: this.courseDetail.videos[index],index:index)));
                  },
                  onButtonTapped: (index){
                    setState(() {
                      this.courseDetail.deleteCourseVideoIndex(this.courseDetail.videos[index]);
                    });
                  },
                ),

                sizedBoxSpace,
              ],
            ),
          ),
        ),
      ):LoaderWidget(),
      floatingActionButton:FloatingActionButton.extended(
        heroTag: "saveEditCourseHeroTag",
        icon: Icon(Icons.save_outlined),
        label: Text("Save",),
        onPressed: _handleSubmitted,
      ),
      floatingActionButtonLocation:
      FloatingActionButtonLocation.endFloat,
    ),key: scaffoldMessengerKey,);
  }
}