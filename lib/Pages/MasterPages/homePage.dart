
import 'package:chronicle/Models/CourseModels/courseModel.dart';
import 'package:chronicle/Models/modalOptionModel.dart';
import 'package:chronicle/Modules/database.dart';
import 'package:chronicle/Modules/errorPage.dart';
import 'package:chronicle/Modules/universalModule.dart';
import 'package:chronicle/Pages/wishlistPage.dart';
import 'package:chronicle/Widgets/Simmers/loaderWidget.dart';
import 'package:chronicle/Widgets/courseList.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../appBarVariables.dart';
import '../../customColors.dart';
import '../courseHomePage.dart';
import '../notificationsPage.dart';


class HomePage extends StatefulWidget {
  final BuildContext mainScreenContext;
  final bool hideStatus;
  final GlobalKey<ScaffoldState> scaffoldKey;
  const HomePage({ Key key,this.mainScreenContext,this.hideStatus,this.scaffoldKey,}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey=GlobalKey<ScaffoldMessengerState>();
  List<CourseModel> courses;
  int _counter=0;
  bool _isLoading;
  bool _isSearching=false;
  int sortVal=1;
  List<CourseModel> searchResult = [];
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
      searchResult=courses.where((CourseModel element) => (element.title.toLowerCase()).contains(searchText.toLowerCase().replaceAll(new RegExp(r"\W+"), ""))).toList();
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
            return getAllCoursesModels("Course").then((courses) {
              if(mounted)this.setState(() {
                this.courses = courses;
                CourseModel courseModel=CourseModel(title: "My Videos",description: "Videos uploaded by you.");
                courses.add(courseModel);
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
    getAllCoursesModels("Course").then((courses) => {
      if(mounted)this.setState(() {
        this.courses = courses;
        courses.add(CourseModel(title: "My Videos",description: "Videos uploaded by you."));
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
                  this.appBarTitle=TextFormField(autofocus:true,controller: _searchController,style: TextStyle(fontSize: 15),decoration: InputDecoration(border: const OutlineInputBorder(borderSide: BorderSide.none),hintText: "Search...",hintStyle: TextStyle(fontSize: 15)),onChanged: searchOperation,);
                  _handleSearchStart();
                }
                else _handleSearchEnd();
              });
            }),
            new IconButton(icon: Icon(Icons.notifications_outlined), onPressed:(){
              setState(() {
                Navigator.of(widget.mainScreenContext).push(CupertinoPageRoute(builder: (notificationPageContext)=>NotificationsPage()));
              });
            }),
            PopupMenuButton<ModalOptionModel>(
              itemBuilder: (BuildContext popupContext){
                return [
                  ModalOptionModel(particulars: "Wishlist",icon: FontAwesomeIcons.heart,iconColor:CustomColors.wishlistIconColor,onTap: () async {
                    Navigator.pop(popupContext);
                    Navigator.of(context).push(new MaterialPageRoute(builder: (qrCodePageContext)=>WishlistPage()));
                  }),
                ].map((ModalOptionModel choice){
                  return PopupMenuItem<ModalOptionModel>(
                    value: choice,
                    child: ListTile(title: Text(choice.particulars),leading: Icon(choice.icon,color: choice.iconColor),onTap: choice.onTap,),
                  );
                }).toList();
              },
            ),
          ],),
        body: this.courses!=null?this.courses.length==0?NoDataError():Column(children: <Widget>[
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
                  Navigator.of(widget.mainScreenContext).push(MaterialPageRoute(builder: (context)=>
                      CourseHomePage(course:this.searchResult[index])));

                },
              )):
          Provider.value(
              value: _counter,
              updateShouldNotify: (oldValue, newValue) => true,
              child: CourseList(listItems:this.courses,scaffoldMessengerKey:scaffoldMessengerKey,
                refreshData: (){
                  return refreshData();
                },
                refreshIndicatorKey: refreshIndicatorKey,
                scrollController: scrollController,
                onTapList:(index) async {
                  Navigator.of(widget.mainScreenContext).push(MaterialPageRoute(builder: (context)=>
                      CourseHomePage(course:this.courses[index])));

                },
              )
          )),
        ]): LoaderWidget()
    ),);
  }
}