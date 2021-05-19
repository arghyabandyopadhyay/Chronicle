import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class AddCoursesPage extends StatefulWidget {
  const AddCoursesPage({ Key key}) : super(key: key);
  @override
  _AddCoursesPageState createState() => _AddCoursesPageState();
}
class _AddCoursesPageState extends State<AddCoursesPage> {
  GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey=GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Course"),),
      body: Center(
        child: Text("Coming Soon..."),
      ),
      floatingActionButton: FloatingActionButton.extended(onPressed: (){
      },
        label: Text("Upload"),icon: Icon(Icons.drive_folder_upload),),
    );
  }
}