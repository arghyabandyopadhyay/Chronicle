import 'package:chronicle/Models/CourseModels/videoIndexModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class SearchCoursesPage extends StatefulWidget {
  final BuildContext mainScreenContext;
  final bool hideStatus;
  final GlobalKey<ScaffoldState> scaffoldKey;
  const SearchCoursesPage({ Key key,this.mainScreenContext,this.hideStatus,this.scaffoldKey}) : super(key: key);
  @override
  _SearchCoursesPageState createState() => _SearchCoursesPageState();
}
class _SearchCoursesPageState extends State<SearchCoursesPage> {
  GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey=GlobalKey<ScaffoldMessengerState>();
  final TextEditingController _searchController = new TextEditingController();
  List<VideoIndexModel> searchResult=[];
  List<VideoIndexModel> videos;
  void searchOperation(String searchText) {
    searchResult.clear();
    searchResult=videos.where((VideoIndexModel element) => (element.name).contains(searchText.toLowerCase().replaceAll(new RegExp(r"\W+"), ""))).toList();
    setState(() {
    });
  }
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.search),
        title: TextFormField(autofocus:true,controller: _searchController,style: TextStyle(fontSize: 15),decoration: InputDecoration(border: const OutlineInputBorder(borderSide: BorderSide.none),hintText: "Search...",hintStyle: TextStyle(fontSize: 15)),onChanged: searchOperation,),),
      body: Center(
        child: Text("Coming Soon..."),
      ),
    );
  }
}