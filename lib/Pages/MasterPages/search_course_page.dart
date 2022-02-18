import 'package:chronicle/Models/CourseModels/courseIndexModel.dart';
import 'package:chronicle/Modules/database.dart';
import 'package:chronicle/Modules/error_page.dart';
import 'package:chronicle/Modules/universal_module.dart';
import 'package:chronicle/Pages/purchasedCoursePage.dart';
import 'package:chronicle/Widgets/loader_widget.dart';
import 'package:chronicle/Widgets/course_list.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app_bar_variables.dart';
import '../../global_class.dart';
import '../coursePreviewPage.dart';
import '../notificationsPage.dart';

class SearchCoursesPage extends StatefulWidget {
  final BuildContext mainScreenContext;
  final bool hideStatus;
  final GlobalKey<ScaffoldState> scaffoldKey;
  const SearchCoursesPage(
      {Key key, this.mainScreenContext, this.hideStatus, this.scaffoldKey})
      : super(key: key);
  @override
  _SearchCoursesPageState createState() => _SearchCoursesPageState();
}

class _SearchCoursesPageState extends State<SearchCoursesPage> {
  GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  List<CourseIndexModel> courses;
  int _counter = 0;
  bool _isLoading;
  bool _isSearching = false;
  final TextEditingController _searchController = new TextEditingController();
  ScrollController scrollController = new ScrollController();

  List<CourseIndexModel> searchResult = [];
  Icon icon = new Icon(
    Icons.search,
  );
  void getCourseModels() {
    if (GlobalClass.myCourses == null) {
      getAllCourseIndexes("Courses", false)
          .then((value) => GlobalClass.myCourses = value);
    }
    getAllCourseIndexes(null, true).then((courses) => {
          if (mounted)
            this.setState(() {
              this.courses = courses;
              _counter++;
              _isLoading = false;
            })
        });
  }

  @override
  void initState() {
    super.initState();
    getCourseModels();
    appBarTitle = AppBarVariables.appBarLeading(widget.mainScreenContext);
  }

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
      this.appBarTitle =
          AppBarVariables.appBarLeading(widget.mainScreenContext);
      _isSearching = false;
      _searchController.clear();
    });
  }

  void searchOperation(String searchText) {
    searchResult.clear();
    searchResult = courses
        .where((CourseIndexModel element) => (element.title.toLowerCase())
            .contains(
                searchText.toLowerCase().replaceAll(new RegExp(r"\W+"), "")))
        .toList();
    setState(() {});
  }

  Future<Null> refreshData() async {
    try {
      Connectivity connectivity = Connectivity();
      await connectivity.checkConnectivity().then((value) async {
        if (value != ConnectivityResult.none) {
          if (!_isLoading) {
            _isLoading = true;
            return getAllCourseIndexes(null, true).then((courses) {
              if (mounted)
                this.setState(() {
                  this.courses = courses;
                  _counter++;
                  _isLoading = false;
                });
            });
          } else {
            globalShowInSnackBar(
                scaffoldMessengerKey, "Data is being loaded...");
            return;
          }
        } else {
          setState(() {
            _isLoading = false;
          });
          globalShowInSnackBar(
              scaffoldMessengerKey, "No Internet Connection!!");
          return;
        }
      });
    } catch (E) {
      setState(() {
        _isLoading = false;
      });
      globalShowInSnackBar(scaffoldMessengerKey, "Something Went Wrong");
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      child: Scaffold(
        appBar: AppBar(
          title: appBarTitle,
          actions: [
            new IconButton(
                icon: icon,
                onPressed: () {
                  setState(() {
                    if (this.icon.icon == Icons.search) {
                      this.icon = new Icon(Icons.close);
                      this.appBarTitle = TextFormField(
                        autofocus: true,
                        controller: _searchController,
                        style: TextStyle(fontSize: 15),
                        decoration: InputDecoration(
                            border: const OutlineInputBorder(
                                borderSide: BorderSide.none),
                            hintText: "Search Courses..",
                            hintStyle: TextStyle(fontSize: 15)),
                        onChanged: searchOperation,
                      );
                      _handleSearchStart();
                    } else
                      _handleSearchEnd();
                  });
                }),
            if (GlobalClass.userDetail.isAppRegistered == 1)
              new IconButton(
                  icon: Icon(Icons.notifications_outlined),
                  onPressed: () {
                    setState(() {
                      Navigator.of(widget.mainScreenContext).push(
                          CupertinoPageRoute(
                              builder: (notificationPageContext) =>
                                  NotificationsPage()));
                    });
                  }),
          ],
        ),
        body: this.courses != null
            ? this.courses.length == 0
                ? NoDataError()
                : Column(children: <Widget>[
                    Expanded(
                        child: _isSearching
                            ? Provider.value(
                                value: _counter,
                                updateShouldNotify: (oldValue, newValue) =>
                                    true,
                                child: CourseList(
                                  listItems: this.searchResult,
                                  scaffoldMessengerKey: scaffoldMessengerKey,
                                  refreshData: () {
                                    return refreshData();
                                  },
                                  refreshIndicatorKey: refreshIndicatorKey,
                                  scrollController: scrollController,
                                  onTapList: (index) async {
                                    if (GlobalClass.myCourses
                                            .where((element) => (element.uid ==
                                                    this
                                                        .searchResult[index]
                                                        .uid &&
                                                element.courseStatus ==
                                                    "Courses"))
                                            .length ==
                                        0)
                                      Navigator.of(widget.mainScreenContext)
                                          .push(CupertinoPageRoute(
                                              builder: (context) =>
                                                  CoursePreviewPage(
                                                      course: this.searchResult[
                                                          index])));
                                    else
                                      Navigator.of(widget.mainScreenContext)
                                          .push(CupertinoPageRoute(
                                              builder: (context) =>
                                                  PurchaseCoursePage(
                                                    course: this
                                                        .searchResult[index],
                                                    isTutor: (GlobalClass
                                                                .userDetail
                                                                .isAppRegistered ==
                                                            1 &&
                                                        GlobalClass.user.uid ==
                                                            this
                                                                .searchResult[
                                                                    index]
                                                                .authorUid),
                                                  )));
                                  },
                                ))
                            : Provider.value(
                                value: _counter,
                                updateShouldNotify: (oldValue, newValue) =>
                                    true,
                                child: CourseList(
                                  listItems: this.courses,
                                  scaffoldMessengerKey: scaffoldMessengerKey,
                                  refreshData: () {
                                    return refreshData();
                                  },
                                  refreshIndicatorKey: refreshIndicatorKey,
                                  scrollController: scrollController,
                                  onTapList: (index) async {
                                    if (GlobalClass.myCourses
                                            .where((element) => ((element.uid ==
                                                    this.courses[index].uid) &&
                                                element.courseStatus ==
                                                    "Courses"))
                                            .length ==
                                        0)
                                      Navigator.of(widget.mainScreenContext)
                                          .push(CupertinoPageRoute(
                                              builder: (context) =>
                                                  CoursePreviewPage(
                                                      course: this
                                                          .courses[index])));
                                    else
                                      Navigator.of(widget.mainScreenContext)
                                          .push(CupertinoPageRoute(
                                              builder: (context) =>
                                                  PurchaseCoursePage(
                                                    course: this.courses[index],
                                                    isTutor: (GlobalClass
                                                                .userDetail
                                                                .isAppRegistered ==
                                                            1 &&
                                                        GlobalClass.user.uid ==
                                                            this
                                                                .courses[index]
                                                                .authorUid),
                                                  )));
                                  },
                                ))),
                  ])
            : LoaderWidget(),
      ),
      key: scaffoldMessengerKey,
    );
  }
}
