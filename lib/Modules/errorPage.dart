import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ErrorPageNoInternet extends StatelessWidget {
  const ErrorPageNoInternet({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(child:Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset("assets/NoInternetError.webp"),
          SizedBox(height: 10,),
          Text("No Internet Connection!!", textAlign: TextAlign.center,textScaleFactor: 1,style: TextStyle(fontSize: 17),)
        ],
      ) ),
    );
  }
}


class NoDataError extends StatelessWidget {
  const NoDataError({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
          margin: EdgeInsets.all(50),
          padding: EdgeInsets.symmetric(horizontal: 2),
          child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset("assets/noData.jpg"),
              SizedBox(height: 10,),
              Text("No Data Found!!", textAlign: TextAlign.center,textScaleFactor: 1,style: TextStyle(fontSize: 17),)
            ],
          ) ),
    );
  }
}

class ErrorHasOccurred extends StatelessWidget {
  const ErrorHasOccurred({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
          margin: EdgeInsets.all(50),
          padding: EdgeInsets.symmetric(horizontal: 2),
          child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset("assets/errorHasOccured.jpg"),
              SizedBox(height: 10,),
              Text("An Error Has Occurred!!", textAlign: TextAlign.center,textScaleFactor: 1,style: TextStyle(fontSize: 17),)
            ],
          ) ),
    );
  }
}