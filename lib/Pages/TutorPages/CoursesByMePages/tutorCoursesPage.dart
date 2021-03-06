import 'package:chronicle/Models/CourseModels/courseIndexModel.dart';
import 'package:chronicle/Models/CourseModels/courseModel.dart';
import 'package:chronicle/Models/modal_option_model.dart';
import 'package:chronicle/Modules/database.dart';
import 'package:chronicle/Modules/error_page.dart';
import 'package:chronicle/Modules/universal_module.dart';
import 'package:chronicle/Pages/purchasedCoursePage.dart';
import 'package:chronicle/Widgets/loader_widget.dart';
import 'package:chronicle/Widgets/course_list.dart';
import 'package:chronicle/Widgets/option_modal_bottom_sheet.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app_bar_variables.dart';

import '../../notificationsPage.dart';
import 'add_course_page.dart';

class TutorCoursesPage extends StatefulWidget {
  final BuildContext mainScreenContext;
  final bool hideStatus;
  final GlobalKey<ScaffoldState> scaffoldKey;
  const TutorCoursesPage(
      {Key key, this.mainScreenContext, this.hideStatus, this.scaffoldKey})
      : super(key: key);
  @override
  _TutorCoursesPageState createState() => _TutorCoursesPageState();
}

class _TutorCoursesPageState extends State<TutorCoursesPage> {
  GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  List<CourseIndexModel> courses;
  int _counter = 0;
  bool _isLoading;
  final TextEditingController _searchController = new TextEditingController();
  ScrollController scrollController = new ScrollController();
  bool _isSearching = false;

  List<CourseIndexModel> searchResult = [];
  Icon icon = new Icon(
    Icons.search,
  );
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
    if (_isSearching) {
      searchResult = courses
          .where((CourseIndexModel element) => (element.title).contains(
              searchText.toLowerCase().replaceAll(new RegExp(r"\W+"), "")))
          .toList();
      setState(() {});
    }
  }

  Future<Null> refreshData() async {
    try {
      if (_isSearching) _handleSearchEnd();
      Connectivity connectivity = Connectivity();
      await connectivity.checkConnectivity().then((value) async {
        if (value != ConnectivityResult.none) {
          if (!_isLoading) {
            _isLoading = true;
            return getAllCourseIndexes("CoursesByMe", false).then((courses) {
              if (mounted)
                this.setState(() {
                  this.courses = courses;
                  _counter++;
                  _isLoading = false;
                  this.appBarTitle =
                      AppBarVariables.appBarLeading(widget.mainScreenContext);
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

  void newCourse(CourseModel course) {
    CourseIndexModel courseIndex = addCourse(course);
    if (mounted)
      this.setState(() {
        courses.add(courseIndex);
      });
  }

  void getCourseModels() {
    getAllCourseIndexes("CoursesByMe", false).then((courses) => {
          if (mounted)
            this.setState(() {
              this.courses = courses;
              _counter++;
              _isLoading = false;
              this.appBarTitle =
                  AppBarVariables.appBarLeading(widget.mainScreenContext);
            })
        });
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      child: Scaffold(
        appBar: AppBar(
          title: appBarTitle,
          // leading: IconButton(onPressed: () { if(!_isSearching)widget.scaffoldKey.currentState.openDrawer(); }, icon: Icon(_isSearching?Icons.search:Icons.menu),),
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
                            hintText: "Search Courses By Me",
                            hintStyle: TextStyle(fontSize: 15)),
                        onChanged: searchOperation,
                      );
                      _handleSearchStart();
                    } else
                      _handleSearchEnd();
                  });
                }),
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
            PopupMenuButton<ModalOptionModel>(
              itemBuilder: (BuildContext popupContext) {
                return [
                  ModalOptionModel(
                      particulars: "Sort",
                      icon: Icons.sort,
                      onTap: () {
                        Navigator.pop(popupContext);
                        showModalBottomSheet(
                            context: widget.mainScreenContext,
                            builder: (BuildContext alertDialogContext) {
                              return OptionModalBottomSheet(
                                  appBarText: "Sort Options",
                                  appBarIcon: Icons.sort,
                                  list: [
                                    ModalOptionModel(
                                      icon: Icons.sort_by_alpha_outlined,
                                      particulars: "A-Z",
                                      onTap: () {
                                        setState(() {
                                          courses =
                                              sortCoursesModule("A-Z", courses);
                                        });
                                        Navigator.pop(alertDialogContext);
                                      },
                                    ),
                                    ModalOptionModel(
                                      icon: Icons.sort_by_alpha_outlined,
                                      particulars: "Z-A",
                                      onTap: () {
                                        setState(() {
                                          courses =
                                              sortCoursesModule("Z-A", courses);
                                        });
                                        Navigator.pop(alertDialogContext);
                                      },
                                    ),
                                  ]);
                            });
                      }),
                  if (this.courses != null && this.courses.length != 0)
                    ModalOptionModel(
                        particulars: "Move to top",
                        icon: Icons.vertical_align_top_outlined,
                        onTap: () async {
                          Navigator.pop(popupContext);
                          scrollController.animateTo(
                            scrollController.position.minScrollExtent,
                            duration: Duration(seconds: 1),
                            curve: Curves.fastOutSlowIn,
                          );
                        }),
                ].map((ModalOptionModel choice) {
                  return PopupMenuItem<ModalOptionModel>(
                    value: choice,
                    child: ListTile(
                      title: Text(choice.particulars),
                      leading: Icon(choice.icon, color: choice.iconColor),
                      onTap: choice.onTap,
                    ),
                  );
                }).toList();
              },
            ),
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
                                  refreshIndicatorKey: refreshIndicatorKey,
                                  refreshData: () {
                                    return refreshData();
                                  },
                                  scrollController: scrollController,
                                  scaffoldMessengerKey: scaffoldMessengerKey,
                                  onTapList: (index) async {
                                    Navigator.of(widget.mainScreenContext)
                                        .push(CupertinoPageRoute(
                                            builder: (context) =>
                                                PurchaseCoursePage(
                                                    isTutor: true,
                                                    course: this
                                                        .searchResult[index])))
                                        .then((value) {
                                      setState(() {
                                        if (value == null) {
                                        } else {
                                          this
                                              .courses
                                              .remove(this.searchResult[index]);
                                          this
                                              .searchResult
                                              .remove(this.searchResult[index]);
                                        }
                                      });
                                    });
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
                                    Navigator.of(widget.mainScreenContext)
                                        .push(CupertinoPageRoute(
                                            builder: (context) =>
                                                PurchaseCoursePage(
                                                    isTutor: true,
                                                    course:
                                                        this.courses[index])))
                                        .then((value) {
                                      setState(() {
                                        if (value == null) {
                                        } else
                                          this
                                              .courses
                                              .remove(this.courses[index]);
                                      });
                                    });
                                  },
                                ))),
                  ])
            : LoaderWidget(),
        floatingActionButton: FloatingActionButton(
          heroTag: "tutorCoursePageHeroTag",
          onPressed: () {
            Navigator.of(widget.mainScreenContext).push(CupertinoPageRoute(
                builder: (context) => AddCoursesPage(
                      callback: this.newCourse,
                    )));
          },
          child: Icon(Icons.add),
        ),
      ),
      key: scaffoldMessengerKey,
    );
  }
}
