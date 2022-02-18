import 'package:chronicle/Models/CourseModels/courseIndexModel.dart';
import 'package:chronicle/Models/CourseModels/courseModel.dart';
import 'package:chronicle/Modules/database.dart';
import 'package:chronicle/Modules/universal_module.dart';
import 'package:chronicle/VideoPlayerUtility/video_player_page.dart';
import 'package:chronicle/Widgets/loader_widget.dart';
import 'package:chronicle/Widgets/preview_video_card_widget.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../custom_colors.dart';
import '../global_class.dart';
import 'checkoutPage.dart';

class CoursePreviewPage extends StatefulWidget {
  final CourseIndexModel course;
  const CoursePreviewPage({Key key, this.course}) : super(key: key);
  @override
  _CoursePreviewPageState createState() => _CoursePreviewPageState();
}

class _CoursePreviewPageState extends State<CoursePreviewPage> {
  CourseModel courseDetail;
  bool _isLoading;
  String courseStatus;
  CourseIndexModel myCourseInstance;

  GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  Icon icon = new Icon(
    Icons.search,
  );
  Future<Null> refreshData() async {
    try {
      Connectivity connectivity = Connectivity();
      await connectivity.checkConnectivity().then((value) async {
        if (value != ConnectivityResult.none) {
          if (!_isLoading) {
            _isLoading = true;
            return getCourse(widget.course).then((courseDetail) {
              if (mounted)
                this.setState(() {
                  this.courseDetail = courseDetail;
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

  void getCourseDetails() {
    if (GlobalClass.myCourses == null)
      getAllCourseIndexes("Courses", false).then((courses) => {
            if (courses != null)
              {
                if (mounted)
                  this.setState(() {
                    GlobalClass.myCourses = courses;
                    List<CourseIndexModel> temp = GlobalClass.myCourses
                        .where((element) => element.uid == widget.course.uid)
                        .toList();
                    if (temp.length != 0) {
                      myCourseInstance = temp.first;
                      courseStatus = myCourseInstance.courseStatus;
                    }
                  })
              }
          });
    else {
      if (mounted)
        this.setState(() {
          List<CourseIndexModel> temp = GlobalClass.myCourses
              .where((element) => element.uid == widget.course.uid)
              .toList();
          if (temp.length != 0) {
            myCourseInstance = temp.first;
            courseStatus = myCourseInstance.courseStatus;
          }
        });
    }
    getCourse(widget.course).then((courseDetail) => {
          if (courseDetail != null)
            {
              if (mounted)
                this.setState(() {
                  this.courseDetail = courseDetail;
                  if (courseDetail.previewThumbnailUrl !=
                      widget.course.previewThumbnailUrl) {
                    CourseIndexModel temp = courseDetail.toCourseIndexModel();
                    temp.setId(widget.course.id);
                    temp.update();
                  }
                  if (courseDetail == null) {
                    this.courseDetail = CourseModel(videos: null);
                  }
                  _isLoading = false;
                })
            }
          else
            {Navigator.pop(context)}
        });
  }

  @override
  void initState() {
    super.initState();
    getCourseDetails();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      child: Scaffold(
        appBar: AppBar(
          title: Text(""),
          actions: [
            if (courseStatus == null)
              new IconButton(
                  icon: Icon(FontAwesomeIcons.heart),
                  onPressed: () {
                    setState(() {
                      addCoursesToOwnLists("Wishlist", widget.course);
                      courseStatus = "Wishlist";
                      globalShowInSnackBar(
                          scaffoldMessengerKey, "Added to wishlist!!");
                    });
                  })
            else if (courseStatus == "Wishlist")
              new IconButton(
                  icon: Icon(
                    FontAwesomeIcons.solidHeart,
                  ),
                  onPressed: () {
                    scaffoldMessengerKey.currentState.hideCurrentSnackBar();
                    scaffoldMessengerKey.currentState.showSnackBar(new SnackBar(
                      content: Text("Already in wishlist."),
                      action: SnackBarAction(
                        textColor: CustomColors.snackBarActionTextColor,
                        label: "Remove",
                        onPressed: () {
                          setState(() {
                            deleteDatabaseNode(myCourseInstance.id);
                            courseStatus = null;
                            GlobalClass.myCourses.remove(myCourseInstance);
                            globalShowInSnackBar(scaffoldMessengerKey,
                                "Removed from wishlist!!");
                          });
                        },
                      ),
                    ));
                  })

            // if(courseStatus==null)new IconButton(icon: Icon(FontAwesomeIcons.heart), onPressed:(){
            //   setState(() {
            //     if(courseStatus==null)addCoursesToOwnLists("Wishlist",widget.course);
            //     else {
            //       if(myCourseInstance==null){
            //         List<CourseIndexModel> temp=GlobalClass.myCourses.where((element) => element.uid==widget.course.uid).toList();
            //         if(temp.length!=0){
            //           myCourseInstance=temp.first;
            //           myCourseInstance.courseStatus="Wishlist";
            //           myCourseInstance.update();
            //         }
            //       }
            //     }
            //     courseStatus="Wishlist";
            //   });
            // })
            // else new IconButton(icon: Icon(FontAwesomeIcons.solidHeart), onPressed:(){
            //   Navigator.of(context).push(CupertinoPageRoute(builder: (wishlistPageContext)=>WishlistPage()));
            // })
          ],
        ),
        body: this.courseDetail != null
            ? RefreshIndicator(
                triggerMode: RefreshIndicatorTriggerMode.anywhere,
                displacement: 10,
                key: refreshIndicatorKey,
                onRefresh: () {
                  return refreshData();
                },
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  physics: AlwaysScrollableScrollPhysics(),
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    if (this.courseDetail.previewVideo != null)
                      PreviewVideoCardWidget(
                        key: ObjectKey(this.courseDetail.previewVideo.id.key),
                        item: this.courseDetail.previewVideo,
                        index: 0,
                        onTapList: (index) {
                          Navigator.of(context).push(CupertinoPageRoute(
                              builder: (context) => VideoPlayerPage(
                                  isDoubtEnabled: false,
                                  isTutor: false,
                                  video: this.courseDetail.previewVideo)));
                        },
                      ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(widget.course.title,
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold)),
                    SizedBox(
                      height: 8,
                    ),
                    Text(widget.course.description,
                        style: TextStyle(
                          fontSize: 20,
                        )),
                    SizedBox(
                      height: 8,
                    ),
                    Row(children: [
                      Text("A course by "),
                      Text(
                        widget.course.authorName,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )
                    ]),
                    SizedBox(
                      height: 8,
                    ),
                    Row(children: [
                      Icon(Icons.video_collection),
                      Text(
                        " ${courseDetail.videos != null ? courseDetail.videos.length.toString() : "0"} Lessons",
                      )
                    ]),
                    SizedBox(
                      height: 8,
                    ),
                    Row(children: [
                      Icon(Icons.supervisor_account_outlined),
                      Text(
                          " ${this.courseDetail.totalUsers.toString()} Students")
                    ]),
                    SizedBox(
                      height: 8,
                    ),
                    // Text("₹"+widget.course.sellingPrice.toStringAsFixed(2)+" excl taxes.",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold)),
                    //               SizedBox(height: 8,),
                    Text(
                      "Last Updates at: " +
                          getMonth(this.courseDetail.lastUpdated.month) +
                          this.courseDetail.lastUpdated.day.toString() +
                          "," +
                          this.courseDetail.lastUpdated.year.toString(),
                      style: TextStyle(fontWeight: FontWeight.w900),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text("Validity:" +
                        this
                            .courseDetail
                            .coursePackageDurationInMonths
                            .toString() +
                        " Month(s)"),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      "What you'll learn",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(this.courseDetail.whatWillYouLearn),
                    SizedBox(
                      height: 15,
                    ),
                    if (this.courseDetail.videos != null &&
                        this.courseDetail.videos.length != 0)
                      Text(
                        "Lectures",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    SizedBox(
                      height: 8,
                    ),
                    this.courseDetail.videos != null &&
                            this.courseDetail.videos.length == 0
                        ? Container(
                            height: 0,
                            width: 0,
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.only(bottom: 100),
                            itemCount: this.courseDetail.videos.length,
                            itemBuilder: (context, index) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(
                                        top: 5, bottom: 5, right: 5),
                                    width: 40,
                                    alignment: Alignment.center,
                                    child: Text(
                                      (index + 1).toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Expanded(
                                      child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(this.courseDetail.videos[index].name,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          )),
                                      Text(this
                                          .courseDetail
                                          .videos[index]
                                          .description),
                                    ],
                                  ))
                                ],
                              );
                            },
                          )
                  ],
                ))
            : LoaderWidget(),
        floatingActionButton: FloatingActionButton.extended(
          heroTag: "checkoutCoursePreviewPageHeroTag",
          onPressed: () {
            Navigator.of(context).push(CupertinoPageRoute(
                builder: (checkoutPageContext) => CheckoutPage(
                      courses: [widget.course],
                      isFromPreviewPage: true,
                    )));
          },
          label: Text(
              "Checkout @ ₹${widget.course.sellingPrice.toStringAsFixed(2)} excl taxes."),
          icon: Icon(Icons.payment_outlined),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
      key: scaffoldMessengerKey,
    );
  }
}
