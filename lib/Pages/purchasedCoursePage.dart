import 'package:chronicle/Models/CourseModels/courseIndexModel.dart';
import 'package:chronicle/Models/CourseModels/courseModel.dart';
import 'package:chronicle/Models/CourseModels/videoIndexModel.dart';
import 'package:chronicle/Models/modalOptionModel.dart';
import 'package:chronicle/Modules/database.dart';
import 'package:chronicle/Modules/errorPage.dart';
import 'package:chronicle/Modules/universalModule.dart';
import 'package:chronicle/Pages/TutorPages/CoursesByMePages/editCoursesPage.dart';
import 'package:chronicle/VideoPlayerUtility/videoPlayerPage.dart';
import 'package:chronicle/Widgets/Simmers/loaderWidget.dart';
import 'package:chronicle/Widgets/courseHomePageVideoList.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'coursePreviewPage.dart';

class PurchaseCoursePage extends StatefulWidget {
  final CourseIndexModel course;
  final bool isTutor;
  const PurchaseCoursePage({ Key key, this.course,this.isTutor}) : super(key: key);
  @override
  _PurchaseCoursePageState createState() => _PurchaseCoursePageState();
}
class _PurchaseCoursePageState extends State<PurchaseCoursePage> {
  CourseModel courseDetail;
  int _counter=0;
  bool _isLoading;

  GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey=GlobalKey<ScaffoldMessengerState>();

  List<VideoIndexModel> searchResult = [];
  Icon icon = new Icon(
    Icons.search,
  );
  //Controller
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey =new GlobalKey<RefreshIndicatorState>();
  ScrollController scrollController = new ScrollController();
  //Widgets

  Future<Null> refreshData() async{
    try{
      Connectivity connectivity=Connectivity();
      await connectivity.checkConnectivity().then((value)async {
        if(value!=ConnectivityResult.none)
        {
          if(!_isLoading){
            _isLoading=true;
            return getCourse(widget.course).then((courseDetail) {
              if(mounted)this.setState(() {
                this.courseDetail = courseDetail;
                _counter++;
                _isLoading=false;
              });
            });
          }
          else{
            globalShowInSnackBar(scaffoldMessengerKey, "Data is being loaded...");
            return;
          }
        }
        else{
          setState(() {
            _isLoading=false;
          });
          globalShowInSnackBar(scaffoldMessengerKey,"No Internet Connection!!");
          return;
        }
      });
    }
    catch(E)
    {
      setState(() {
        _isLoading=false;
      });
      globalShowInSnackBar(scaffoldMessengerKey,"Something Went Wrong");
      return;
    }
  }

  void getCourseDetails() {
    getCourse(widget.course).then((courseDetail) => {
      if(courseDetail!=null){
        if(mounted)this.setState(() {
          this.courseDetail = courseDetail;
          if(courseDetail.previewThumbnailUrl!=widget.course.previewThumbnailUrl){
            CourseIndexModel temp=courseDetail.toCourseIndexModel();
            temp.setId(widget.course.id);
            temp.update();
          }
          if(courseDetail==null){
            this.courseDetail=CourseModel(videos: null);
          }
          _counter++;
          _isLoading=false;
        })
      }
      else{
        Navigator.pop(context)
      }
    });
  }
  @override
  void initState() {
    super.initState();
    getCourseDetails();
  }
  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(child: Scaffold(
        appBar: AppBar(title: Text(widget.course.title),
          actions: [
            if(widget.isTutor)PopupMenuButton<ModalOptionModel>(
              itemBuilder: (BuildContext popupContext){
                return [
                  ModalOptionModel(particulars: "Edit",icon: Icons.edit,onTap: (){
                    Navigator.pop(popupContext);
                    Navigator.of(context).push(CupertinoPageRoute(builder: (context)=>
                        EditCoursesPage(course:this.widget.course)));
                  }),
                  ModalOptionModel(particulars: "Preview Course",icon: Icons.preview_outlined,onTap: (){
                    Navigator.pop(popupContext);
                    Navigator.of(context).push(CupertinoPageRoute(builder: (context)=>
                        CoursePreviewPage(course:this.widget.course)));
                  }),
                  ModalOptionModel(particulars: "Delete",icon: Icons.delete,onTap: (){
                    Navigator.pop(popupContext);
                    deleteCourseModule(widget.course, context, this);
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
        body:
        RefreshIndicator(
            triggerMode: RefreshIndicatorTriggerMode.anywhere,
            displacement: 10,
            key: refreshIndicatorKey,
            onRefresh: (){
              return refreshData();
            },
            child:this.courseDetail!=null?this.courseDetail.videos!=null&&this.courseDetail.videos.length!=0?ListView(
              padding: EdgeInsets.symmetric(horizontal: 20),
              physics: AlwaysScrollableScrollPhysics(),
              children: [
                Text("Videos",style: TextStyle(fontWeight: FontWeight.bold),),
                SizedBox(height: 8,),
                Provider.value(
                    value: _counter,
                    updateShouldNotify: (oldValue, newValue) => true,
                    child: CourseHomePageVideoList(listItems:this.courseDetail.videos,scaffoldMessengerKey:scaffoldMessengerKey,
                      onTapList:(index) async {
                        Navigator.of(context).push(CupertinoPageRoute(builder: (context)=>
                            VideoPlayerPage(isDoubtEnabled:true,isTutor:widget.isTutor,video:this.courseDetail.videos[index])));
                      },
                    )
                ),
              ],
            ):NoDataError():LoaderWidget()
        )

    ),key: scaffoldMessengerKey,);
  }
}