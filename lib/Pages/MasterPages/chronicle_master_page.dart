import 'package:chronicle/Models/register_index_model.dart';
import 'package:chronicle/Pages/TutorPages/clientPage.dart';
import 'package:chronicle/Pages/TutorPages/CoursesByMePages/tutorCoursesPage.dart';
import 'package:chronicle/Pages/MasterPages/user_info_screen.dart';
import 'package:chronicle/Pages/TutorPages/registersPage.dart';
import 'package:chronicle/custom_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

import '../../global_class.dart';
import 'search_course_page.dart';
import 'home_page.dart';

class ChronicleMasterPage extends StatefulWidget {
  final RegisterIndexModel register;
  ChronicleMasterPage({Key key, this.register}) : super(key: key);
  @override
  _ChronicleMasterPageState createState() => _ChronicleMasterPageState();
}

class _ChronicleMasterPageState extends State<ChronicleMasterPage> {
  PersistentTabController _controller;
  GlobalKey<ScaffoldState> masterPageScaffoldKey =
      new GlobalKey<ScaffoldState>();
  GlobalKey<ScaffoldMessengerState> masterScaffoldMessengerKey =
      new GlobalKey<ScaffoldMessengerState>();
  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: 0);
  }

  List<Widget> _buildScreens() {
    return [
      if (GlobalClass.userDetail.isAppRegistered == 1)
        widget.register != null
            ? ClientPage(
                register: widget.register,
                scaffoldKey: masterPageScaffoldKey,
                mainScreenContext: context,
              )
            : RegistersPage(context),
      if (GlobalClass.userDetail.isAppRegistered == 1)
        TutorCoursesPage(
          scaffoldKey: masterPageScaffoldKey,
          mainScreenContext: context,
        ),
      HomePage(
        mainScreenContext: context,
      ),
      SearchCoursesPage(
        scaffoldKey: masterPageScaffoldKey,
        mainScreenContext: context,
      ),
      UserInfoScreen(
        scaffoldKey: masterPageScaffoldKey,
        mainScreenContext: context,
      )
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      if (GlobalClass.userDetail.isAppRegistered == 1)
        PersistentBottomNavBarItem(
          icon: Icon(Icons.supervised_user_circle_outlined),
          title: "Clients",
          inactiveColorPrimary: Colors.grey,
          activeColorPrimary: CustomColors.primaryColor,
        ),
      if (GlobalClass.userDetail.isAppRegistered == 1)
        PersistentBottomNavBarItem(
          icon: Icon(Icons.subscriptions_outlined),
          title: "Courses By Me",
          inactiveColorPrimary: Colors.grey,
          activeColorPrimary: CustomColors.primaryColor,
        ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.home_outlined),
        title: "Home",
        inactiveColorPrimary: Colors.grey,
        activeColorPrimary: CustomColors.primaryColor,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.explore_outlined),
        title: "Explore",
        inactiveColorPrimary: Colors.grey,
        activeColorPrimary: CustomColors.primaryColor,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.account_circle_sharp),
        title: "Account",
        inactiveColorPrimary: Colors.grey,
        activeColorPrimary: CustomColors.primaryColor,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      child: Scaffold(
        key: masterPageScaffoldKey,
        resizeToAvoidBottomInset: false,
        // drawer: (GlobalClass.userDetail.isAppRegistered==1)?UniversalDrawerWidget(scaffoldMessengerKey: masterScaffoldMessengerKey,state: this,isNotRegisterPage: true,masterContext: context,):Drawer(
        //     child: DrawerContent(
        //       scaffoldMessengerKey: masterScaffoldMessengerKey,
        //       drawerItems:
        //       [
        //         DrawerActionModel(
        //           Icons.home,"Home",(){
        //           Navigator.pop(context);
        //           _controller.jumpToTab(0);
        //         },
        //         ),
        //         DrawerActionModel(
        //           Icons.search,"Search",(){
        //           Navigator.pop(context);
        //           _controller.jumpToTab(1);
        //         },
        //         ),
        //       ],
        //     )
        // ),
        body: PersistentTabView(
          context,
          controller: _controller,
          screens: _buildScreens(),
          items: _navBarsItems(),
          confineInSafeArea: true,
          handleAndroidBackButtonPress: true,
          resizeToAvoidBottomInset: false,
          stateManagement: true,
          hideNavigationBarWhenKeyboardShows: true,
          hideNavigationBar: false,
          margin: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          popActionScreens: PopActionScreensType.once,
          bottomScreenMargin:
              MediaQuery.of(context).viewInsets.bottom == 0 ? 56 : 0,
          decoration: NavBarDecoration(
              //   borderRadius: BorderRadius.circular(20.0),
              // border: Border.all(width: 0.1)
              boxShadow: [
                BoxShadow(
                  color: CustomColors.primaryText.withOpacity(0.1),
                  blurRadius: 15.0, // soften the shadow
                  spreadRadius: 0.0,
                  offset: Offset(
                    0, // Move to right 10  horizontally
                    -10.0, // Move to bottom 10 Vertically
                  ), //extend the shadow
                )
              ]),
          popAllScreensOnTapOfSelectedTab: true,
          itemAnimationProperties: ItemAnimationProperties(
            duration: Duration(milliseconds: 400),
            curve: Curves.ease,
          ),
          screenTransitionAnimation: ScreenTransitionAnimation(
            animateTabTransition: false,
            curve: Curves.ease,
            duration: Duration(milliseconds: 200),
          ),
          navBarStyle:
              NavBarStyle.style3, // Choose the nav bar style with this property
        ),
      ),
      key: masterScaffoldMessengerKey,
    );
  }
}
