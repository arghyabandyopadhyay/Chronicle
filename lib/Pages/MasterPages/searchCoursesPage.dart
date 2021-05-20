import 'package:chronicle/Models/CourseModels/courseIndexModel.dart';
import 'package:chronicle/Models/CourseModels/videoIndexModel.dart';
import 'package:chronicle/Modules/database.dart';
import 'package:chronicle/Modules/errorPage.dart';
import 'package:chronicle/Modules/universalModule.dart';
import 'package:chronicle/Widgets/Simmers/loaderWidget.dart';
import 'package:chronicle/Widgets/courseList.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../appBarVariables.dart';
import '../coursePreviewPage.dart';


class SearchCoursesPage extends StatefulWidget {
  final BuildContext mainScreenContext;
  final bool hideStatus;
  final GlobalKey<ScaffoldState> scaffoldKey;
  const SearchCoursesPage({ Key key,this.mainScreenContext,this.hideStatus,this.scaffoldKey}) : super(key: key);
  @override
  _SearchCoursesPageState createState() => _SearchCoursesPageState();
}
class _SearchCoursesPageState extends State<SearchCoursesPage> {
  GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey=GlobalKey<ScaffoldMessengerState>();
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey =new GlobalKey<RefreshIndicatorState>();
  List<CourseIndexModel> courses;
  int _counter=0;
  bool _isLoading;
  final TextEditingController _searchController = new TextEditingController();
  ScrollController scrollController = new ScrollController();

  List<CourseIndexModel> searchResult = [];
  Icon icon = new Icon(
    Icons.search,
  );
  void getCourseModels() {
    getAllCourseIndexes(null,true).then((courses) => {
      if(mounted)this.setState(() {
        this.courses = courses;
        _counter++;
        _isLoading=false;
      })
    });
  }

  @override
  void initState() {
    super.initState();
    getCourseModels();
  }
  void searchOperation(String searchText) {
    searchResult.clear();
    searchResult=courses.where((CourseIndexModel element) => (element.title.toLowerCase()).contains(searchText.toLowerCase().replaceAll(new RegExp(r"\W+"), ""))).toList();
    setState(() {
    });
  }

  Future<Null> refreshData() async{
    try{
      Connectivity connectivity=Connectivity();
      await connectivity.checkConnectivity().then((value)async {
        if(value!=ConnectivityResult.none)
        {
          if(!_isLoading){
            _isLoading=true;
            return getAllCourseIndexes(null,true).then((courses) {
              if(mounted)this.setState(() {
                this.courses = courses;
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
  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(child: Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.search),
        title: TextFormField(autofocus:true,controller: _searchController,style: TextStyle(fontSize: 15),decoration: InputDecoration(border: const OutlineInputBorder(borderSide: BorderSide.none),hintText: "Search Courses",hintStyle: TextStyle(fontSize: 15)),onChanged: searchOperation,),),
      body: this.searchResult!=null?this.searchResult.length==0?NoDataError():Column(children: <Widget>[
        Expanded(child: Provider.value(
            value: _counter,
            updateShouldNotify: (oldValue, newValue) => true,
            child: CourseList(listItems:this.searchResult,scaffoldMessengerKey:scaffoldMessengerKey,
              refreshData: (){
                return refreshData();
              },
              refreshIndicatorKey: refreshIndicatorKey,
              scrollController: scrollController,
              onTapList:(index) async {
                Navigator.of(widget.mainScreenContext).push(CupertinoPageRoute(builder: (context)=>
                    CoursePreviewPage(course:this.searchResult[index])));

              },
            )
        )),
      ]): LoaderWidget(),
    ),key: scaffoldMessengerKey,);
  }
}