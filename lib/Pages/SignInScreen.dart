import 'package:chronicle/Pages/globalClass.dart';
import 'package:chronicle/Widgets/googleSignInButton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../Modules/auth.dart';
import '../customColors.dart';
import '../Modules/database.dart';
import 'idBlockedPage.dart';
import 'myHomePage.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}
class _SignInScreenState extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        elevation: 0,title: Text("Chronicle"),leading: Icon(Icons.menu),),
      body:
      FutureBuilder(
          future: Authentication.initializeFirebase(context: context),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Column(
                children: [
                  Expanded(child: IdBlockedPage()),
                ],
              );
            }
            else if (snapshot.connectionState == ConnectionState.done) {
              User user = FirebaseAuth.instance.currentUser;
              if(user!=null){
                GlobalClass.user=user;
                registerUserDetail().then((value) => {
                  if(value!=null)Navigator.pushReplacement(context, PageRouteBuilder(pageBuilder: (context,animation,secondAnimation) => MyHomePage()))
                  else{
                    Navigator.of(context).pushReplacement(PageRouteBuilder(pageBuilder: (context,animation,secondAnimation) =>IdBlockedPage()))
                  }
                });
                return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Expanded(
                          child: Shimmer.fromColors(
                              baseColor: Colors.white,
                              highlightColor: Colors.grey.withOpacity(0.5),
                              enabled: true,
                              child: ListView.builder(
                                itemBuilder: (_, __) => Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 48.0,
                                        height: 48.0,
                                        color: Colors.white,
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Container(
                                              width: double.infinity,
                                              height: 8.0,
                                              color: Colors.white,
                                            ),
                                            const Padding(
                                              padding: EdgeInsets.symmetric(vertical: 2.0),
                                            ),
                                            Container(
                                              width: double.infinity,
                                              height: 8.0,
                                              color: Colors.white,
                                            ),
                                            const Padding(
                                              padding: EdgeInsets.symmetric(vertical: 2.0),
                                            ),
                                            Container(
                                              width: 40.0,
                                              height: 8.0,
                                              color: Colors.white,
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                itemCount: 4,
                              )
                          ),
                        ),
                      ],
                    )
                );
              }
              else {
                return SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 16.0,
                      right: 16.0,
                      bottom: 20.0,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Row(),
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Flexible(
                                flex: 1,
                                child: Image.asset(
                                  'assets/firebase_logo.png',
                                  height: 160,
                                ),
                              ),
                              SizedBox(height: 20),
                              Text(
                                'Chronicle',
                                style: TextStyle(
                                  color: CustomColors.firebaseYellow,
                                  fontSize: 40,
                                ),
                              ),
                              Text(
                                'Authentication',
                                style: TextStyle(
                                  color: CustomColors.firebaseOrange,
                                  fontSize: 40,
                                ),
                              ),
                            ],
                          ),
                        ),
                        GoogleSignInButton()
                      ],
                    ),
                  ),
                );
              }
            }
            // By default, show a loading spinner.
            return Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Expanded(
                      child: Shimmer.fromColors(
                          baseColor: Colors.white,
                          highlightColor: Colors.grey.withOpacity(0.5),
                          enabled: true,
                          child: ListView.builder(
                            itemBuilder: (_, __) => Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 48.0,
                                    height: 48.0,
                                    color: Colors.white,
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          width: double.infinity,
                                          height: 8.0,
                                          color: Colors.white,
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.symmetric(vertical: 2.0),
                                        ),
                                        Container(
                                          width: double.infinity,
                                          height: 8.0,
                                          color: Colors.white,
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.symmetric(vertical: 2.0),
                                        ),
                                        Container(
                                          width: 40.0,
                                          height: 8.0,
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            itemCount: 4,
                          )
                      ),
                    ),
                  ],
                )
            );
          }
      ),
    );
  }
}