import 'package:chronicle/Models/DrawerActionModel.dart';
import 'package:chronicle/Modules/universalModule.dart';
import 'package:chronicle/Pages/StudentPages/coursesPage.dart';
import 'package:chronicle/globalClass.dart';
import 'package:chronicle/Widgets/drawerContent.dart';
import 'package:chronicle/customColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'homePage.dart';

class MasterPage extends StatefulWidget {
  MasterPage({Key key,}) : super(key: key);
  @override
  _MasterPageState createState() => _MasterPageState();
}
class _MasterPageState extends State<MasterPage> {
  PersistentTabController _controller;
  GlobalKey<ScaffoldState> masterPageScaffoldKey=new GlobalKey<ScaffoldState>();
  GlobalKey<ScaffoldMessengerState> masterScaffoldMessengerKey=new GlobalKey<ScaffoldMessengerState>();
  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: 0);
  }
  List<Widget> _buildScreens() {
    return [
      HomePage(
        scaffoldKey: masterPageScaffoldKey,
        scaffoldMessengerKey: masterScaffoldMessengerKey,
      ),
      CoursesPage(
        scaffoldKey: masterPageScaffoldKey,
        scaffoldMessengerKey: masterScaffoldMessengerKey,
      ),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(Icons.home_outlined),
        title: "Home",
        inactiveColorPrimary: Colors.grey,
        activeColorPrimary: CustomColors.primaryColor,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(FontAwesomeIcons.bookOpen),
        title: "Courses",
        inactiveColorPrimary: Colors.grey,
        activeColorPrimary: CustomColors.primaryColor,
      ),
    ];
  }
  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(child: Scaffold(
      key: masterPageScaffoldKey,
      endDrawerEnableOpenDragGesture: false,
      resizeToAvoidBottomInset: false,
      drawer: Drawer(
          child: DrawerContent(
            scaffoldMessengerKey: masterScaffoldMessengerKey,
            drawerItems:
            [
              DrawerActionModel(
                Icons.home,"Home",(){
                  Navigator.pop(context);
                  _controller.jumpToTab(0);
                },
              ),
              DrawerActionModel(
                FontAwesomeIcons.bookOpen,"Courses",(){
                Navigator.pop(context);
                _controller.jumpToTab(1);
              },
              ),
              if(GlobalClass.userDetail.isAppRegistered==0)DrawerActionModel(
                Icons.app_registration,"Register as an Owner",(){
                Navigator.pop(context);
                registerAppModule(masterScaffoldMessengerKey);
              },
              ),
            ],
          )
      ),
      body: PersistentTabView(
        context,
        controller: _controller,
        screens: _buildScreens(),
        items: _navBarsItems(),
        confineInSafeArea: true,
        handleAndroidBackButtonPress: true,
        resizeToAvoidBottomInset: true,
        stateManagement: true,
        hideNavigationBarWhenKeyboardShows: true,
        hideNavigationBar: false,
        margin: EdgeInsets.symmetric(horizontal:2,vertical: 0),
        popActionScreens: PopActionScreensType.once,
        bottomScreenMargin: 0.0,
        decoration: NavBarDecoration(
            colorBehindNavBar: Colors.white,
            //   borderRadius: BorderRadius.circular(20.0),
            // border: Border.all(width: 0.1)
            boxShadow: [BoxShadow(
              color: CustomColors.primaryText.withOpacity(0.1),
              blurRadius: 15.0, // soften the shadow
              spreadRadius: 0.0,
              offset: Offset(
                0, // Move to right 10  horizontally
                -10.0, // Move to bottom 10 Vertically
              ),//extend the shadow
            )]
        ),
        popAllScreensOnTapOfSelectedTab: true,
        itemAnimationProperties: ItemAnimationProperties(
          duration: Duration(milliseconds: 400),
          curve: Curves.ease,
        ),
        screenTransitionAnimation: ScreenTransitionAnimation(
          animateTabTransition: true,
          curve: Curves.ease,
          duration: Duration(milliseconds: 200),
        ),
        navBarStyle:NavBarStyle.style1, // Choose the nav bar style with this property
      ),
    ),key: masterScaffoldMessengerKey,);
  }
}