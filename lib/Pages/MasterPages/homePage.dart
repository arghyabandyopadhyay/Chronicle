import 'package:chronicle/Models/CourseModels/courseIndexModel.dart';
import 'package:chronicle/Models/modalOptionModel.dart';
import 'package:chronicle/Modules/database.dart';
import 'package:chronicle/Modules/errorPage.dart';
import 'package:chronicle/Modules/universalModule.dart';
import 'package:chronicle/Pages/TutorPages/CoursesByMePages/videosPage.dart';
import 'package:chronicle/Widgets/Simmers/loaderWidget.dart';
import 'package:chronicle/Widgets/courseList.dart';
import 'package:chronicle/globalClass.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../appBarVariables.dart';
import '../wishlistPage.dart';
import '../notificationsPage.dart';
import '../purchasedCoursePage.dart';


class HomePage extends StatefulWidget {
  final BuildContext mainScreenContext;
  final bool hideStatus;
  const HomePage({ Key key,this.mainScreenContext,this.hideStatus,}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey=GlobalKey<ScaffoldMessengerState>();
  int _counter=0;
  bool _isLoading;
  bool _isSearching=false;

  List<CourseIndexModel> searchResult = [];
  List<CourseIndexModel> purchasedCourses;
  Icon icon = new Icon(
    Icons.search,
  );

  //Controller
  final TextEditingController _searchController = new TextEditingController();
  final TextEditingController textEditingController=new TextEditingController();
  final TextEditingController renameRegisterTextEditingController=new TextEditingController();
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey =new GlobalKey<RefreshIndicatorState>();
  ScrollController scrollController = new ScrollController();
  //Widgets
  Widget appBarTitle;
  void _handleSearchStart() {
    setState(() {
      _isSearching = true;
    });
  }

  void _handleSearchEnd() {
    setState(() {
      this.icon = new Icon(
        Icons.search,
      );
      this.appBarTitle = AppBarVariables.appBarLeading(widget.mainScreenContext);
      _isSearching = false;
      _searchController.clear();
    });
  }
  void searchOperation(String searchText)
  {
    searchResult.clear();
    if(_isSearching){
      searchResult=purchasedCourses.where((CourseIndexModel element) => (element.title.toLowerCase()).contains(searchText.toLowerCase().replaceAll(new RegExp(r"\W+"), ""))).toList();
      setState(() {
      });
    }
  }

  Future<Null> refreshData() async{
    try{
      if(_isSearching)_handleSearchEnd();
      Connectivity connectivity=Connectivity();
      await connectivity.checkConnectivity().then((value)async {
        if(value!=ConnectivityResult.none)
        {
          if(!_isLoading){
            _isLoading=true;
            return getAllCourseIndexes("Courses",false).then((courses) {
              if(mounted)this.setState(() {
                GlobalClass.myCourses = courses;
                purchasedCourses=GlobalClass.myCourses.where((element) => element.courseStatus=="Courses").toList();
                _counter++;
                _isLoading=false;
                this.appBarTitle = AppBarVariables.appBarLeading(widget.mainScreenContext);
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
  void getCourseModels() {
    getAllCourseIndexes("Courses",false).then((courses) => {
      if(mounted)this.setState(() {
        GlobalClass.myCourses = courses;
        purchasedCourses=GlobalClass.myCourses.where((element) => element.courseStatus=="Courses").toList();
        _counter++;
        _isLoading=false;
        this.appBarTitle = AppBarVariables.appBarLeading(widget.mainScreenContext);
      })
    });
  }
  @override
  void initState() {
    super.initState();
    getCourseModels();
    this.appBarTitle = AppBarVariables.appBarLeading(widget.mainScreenContext);
  }
  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(key: scaffoldMessengerKey,child: Scaffold(
        appBar: AppBar(
          title: appBarTitle,
          actions: [
            new IconButton(icon: icon, onPressed:(){
              setState(() {
                if(this.icon.icon == Icons.search)
                {
                  this.icon=new Icon(Icons.close);
                  this.appBarTitle=TextFormField(autofocus:true,controller: _searchController,style: TextStyle(fontSize: 15),decoration: InputDecoration(border: const OutlineInputBorder(borderSide: BorderSide.none),hintText: "Search Owned Courses",hintStyle: TextStyle(fontSize: 15)),onChanged: searchOperation,);
                  _handleSearchStart();
                }
                else _handleSearchEnd();
              });
            }),
            if(GlobalClass.userDetail.isAppRegistered==1)new IconButton(icon: Icon(Icons.notifications_outlined), onPressed:(){
              setState(() {
                Navigator.of(widget.mainScreenContext).push(CupertinoPageRoute(builder: (notificationPageContext)=>NotificationsPage()));
              });
            }),
            new IconButton(icon: Icon(FontAwesomeIcons.heart), onPressed:() async {
              Navigator.of(widget.mainScreenContext).push(new CupertinoPageRoute(builder: (qrCodePageContext)=>WishlistPage()));
            }),
          ],),
        body: Column(
          children: [
            if(GlobalClass.userDetail.isAppRegistered==1)ListTile(
              onTap: () {
                Navigator.of(widget.mainScreenContext).push(CupertinoPageRoute(builder: (context)=>
                    VideosPage(false,false)));
              },
              leading: Icon(Icons.video_collection_outlined),
              title: Text("My Videos"),
              subtitle: Text("The Videos uploaded by you"),),
            Expanded(child: purchasedCourses!=null?purchasedCourses.length==0?NoDataError():Column(children: <Widget>[
              Expanded(child: _isSearching?
              Provider.value(
                  value: _counter,
                  updateShouldNotify: (oldValue, newValue) => true,
                  child: CourseList(listItems:this.searchResult,
                    refreshIndicatorKey: refreshIndicatorKey,
                    refreshData: (){
                      return refreshData();
                    },
                    scrollController:scrollController,
                    scaffoldMessengerKey:scaffoldMessengerKey,
                    onTapList:(index) async {
                      Navigator.of(widget.mainScreenContext).push(CupertinoPageRoute(builder: (context)=>
                          PurchaseCoursePage(isTutor:(GlobalClass.userDetail.isAppRegistered==1&&GlobalClass.user.uid==this.searchResult[index].authorUid),course:this.searchResult[index])));

                    },
                  )):
              Provider.value(
                  value: _counter,
                  updateShouldNotify: (oldValue, newValue) => true,
                  child: CourseList(listItems:purchasedCourses,scaffoldMessengerKey:scaffoldMessengerKey,
                    refreshData: (){
                      return refreshData();
                    },
                    refreshIndicatorKey: refreshIndicatorKey,
                    scrollController: scrollController,
                    onTapList:(index) async {
                      Navigator.of(widget.mainScreenContext).push(CupertinoPageRoute(builder: (context)=>
                          PurchaseCoursePage(isTutor:(GlobalClass.userDetail.isAppRegistered==1&&GlobalClass.user.uid==this.purchasedCourses[index].authorUid),course:purchasedCourses[index])));

                    },
                  )
              )),
            ]): LoaderWidget())
          ],
        )
    ),);
  }
}