import 'package:chronicle/Models/CourseModels/courseIndexModel.dart';
import 'package:chronicle/Modules/database.dart';
import 'package:chronicle/Modules/errorPage.dart';
import 'package:chronicle/Modules/universalModule.dart';
import 'package:chronicle/Pages/checkoutPage.dart';
import 'package:chronicle/Widgets/Simmers/loaderWidget.dart';
import 'package:chronicle/Widgets/courseList.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../globalClass.dart';


class WishlistPage extends StatefulWidget {
  const WishlistPage({ Key key,}) : super(key: key);
  @override
  _WishlistPageState createState() => _WishlistPageState();
}
class _WishlistPageState extends State<WishlistPage> {
  GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey=GlobalKey<ScaffoldMessengerState>();
  int _counter=0;
  bool _isLoading;
  bool _isSearching=false;
  List<CourseIndexModel> wishlist;
  List<CourseIndexModel> searchResult = [];
  Icon icon = new Icon(
    Icons.search,
  );

  //Controller
  final TextEditingController _searchController = new TextEditingController();
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
      this.appBarTitle = Text("Wishlist");
      _isSearching = false;
      _searchController.clear();
    });
  }
  void searchOperation(String searchText)
  {
    searchResult.clear();
    if(_isSearching){
      searchResult=wishlist.where((CourseIndexModel element) => (element.title.toLowerCase()).contains(searchText.toLowerCase().replaceAll(new RegExp(r"\W+"), ""))).toList();
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
            if(GlobalClass.myCourses==null)return getAllCourseIndexes("Wishlist",false).then((courses) {
              if(mounted)this.setState(() {
                GlobalClass.myCourses = courses;
                wishlist=GlobalClass.myCourses.where((element) => element.courseStatus=="Wishlist").toList();
                _counter++;
                _isLoading=false;
                this.appBarTitle = Text("Wishlist");
              });
            });
            else return this.setState(() {
              this.wishlist=GlobalClass.myCourses.where((element) => element.courseStatus=="Wishlist").toList();
              _counter++;
              _isLoading=false;
              this.appBarTitle = Text("Wishlist");
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
  Future<void> getCourseModels() async {
    if(GlobalClass.myCourses==null)getAllCourseIndexes("Wishlist",false).then((courses) => {
      if(mounted)this.setState(() {
        GlobalClass.myCourses = courses;
        wishlist=GlobalClass.myCourses.where((element) => element.courseStatus=="Wishlist").toList();
        _counter++;
        _isLoading=false;
        this.appBarTitle = Text("Wishlist");
      })
    });
    else{
      await Future.delayed(Duration(milliseconds: 500));
      if(mounted)this.setState(() {
        this.wishlist=GlobalClass.myCourses.where((element) => element.courseStatus=="Wishlist").toList();
        _counter++;
        _isLoading=false;
        this.appBarTitle = Text("Wishlist");
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getCourseModels();
    this.appBarTitle = Text("Wishlist");
  }
  @override
  void dispose() {
    super.dispose();
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
          ],),
        body: wishlist!=null?wishlist.length==0?NoDataError():Column(children: <Widget>[
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
                onTapList:(index) {
                  setState(() {
                    deleteDatabaseNode(searchResult[index].id);
                    GlobalClass.myCourses.remove(searchResult[index]);
                    searchResult.remove(searchResult[index]);
                    globalShowInSnackBar(scaffoldMessengerKey, "Removed from your Wishlist!!");
                  });
                },
              )):
          Provider.value(
              value: _counter,
              updateShouldNotify: (oldValue, newValue) => true,
              child: CourseList(listItems:wishlist,scaffoldMessengerKey:scaffoldMessengerKey,
                refreshData: (){
                  return refreshData();
                },
                refreshIndicatorKey: refreshIndicatorKey,
                scrollController: scrollController,
                onTapList:(index) {
                  setState(() {
                    deleteDatabaseNode(wishlist[index].id);
                    GlobalClass.myCourses.remove(wishlist[index]);
                    wishlist.remove(wishlist[index]);
                    globalShowInSnackBar(scaffoldMessengerKey, "Removed from your Wishlist!!");
                  });
                },
              )
          )),
        ]): LoaderWidget(),
        floatingActionButton:
        FloatingActionButton.extended(heroTag: "WishlistHeroTag",onPressed:(){
          Navigator.of(context).push(CupertinoPageRoute(builder: (checkoutPageContext)=>CheckoutPage(courses: this.wishlist,isFromPreviewPage: false,)));
        }, label: Text("Checkout"),icon: Icon(Icons.payment_outlined),)
    ),);
  }
}