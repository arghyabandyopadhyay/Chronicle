import 'package:chronicle/Models/dataModel.dart';
import 'package:chronicle/Models/registerModel.dart';
import 'package:chronicle/Models/userModel.dart';
import 'package:chronicle/Modules/universalModule.dart';
import 'package:chronicle/Widgets/registerOptionBottomSheet.dart';
import 'package:chronicle/Widgets/usersList.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chronicle/Modules/database.dart';
import '../Models/clientModel.dart';
import '../Widgets/clientList.dart';
import '../customColors.dart';
import '../Widgets/registerNewClientWidget.dart';

class ClientAccessEditPage extends StatefulWidget {
  ClientAccessEditPage();

  @override
  _ClientAccessEditPageState createState() => _ClientAccessEditPageState();
}

class _ClientAccessEditPageState extends State<ClientAccessEditPage> {
  List<UserModel> clients = [];
  bool _isSearching=false;
  List<UserModel> searchResult = [];
  Icon icon = new Icon(
    Icons.search,
  );
  //Controller
  final TextEditingController _searchController = new TextEditingController();
  //Widgets
  Widget appBarTitle = Text("",
    textScaleFactor: 1,
    style: TextStyle(
        fontSize: 24.0,
        height: 2.5),
  );
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
      this.appBarTitle = Text("Users",
        textScaleFactor: 1,
      );
      _isSearching = false;
      _searchController.clear();
    });
  }
  void searchOperation(String searchText)
  {
    searchResult.clear();
    if(_isSearching){
      searchResult=clients.where((UserModel element) => (element.displayName.toLowerCase()).contains(searchText.toLowerCase().replaceAll(new RegExp(r"\s+"), ""))).toList();
      setState(() {
      });
    }
  }
  void updateDataModel() {
    this.setState(() {
    });
  }

  void getData() {
    getAllData().then((clients) => {
      this.setState(() {
        this.clients.clear();
        clients.forEach((element) {if(element.userDetails.first.isOwner==0)this.clients.add(element.userDetails.first);});
      })
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
    appBarTitle=GestureDetector(child: Container(child: Text("Users"),),
      onTap: (){showModalBottomSheet(context: context, builder: (_)=>RegisterOptionBottomSheet(list: [],));},);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: appBarTitle,
        leading: IconButton(onPressed: () { if(!_isSearching)Navigator.of(context).pop(); }, icon: Icon(_isSearching?Icons.search:Icons.arrow_back),),
        actions: [
          new IconButton(icon: icon, onPressed:(){
            setState(() {
              if(this.icon.icon == Icons.search)
              {
                this.icon=new Icon(Icons.close);
                this.appBarTitle=TextFormField(cursorColor:Colors.white,autofocus:true,controller: _searchController,style: TextStyle(fontSize: 15),decoration: InputDecoration(border: const OutlineInputBorder(borderSide: BorderSide.none),hintText: "Search...",hintStyle: TextStyle(fontSize: 15)),onChanged: searchOperation,);
                _handleSearchStart();
              }
              else _handleSearchEnd();
            });
          }),
          IconButton(icon: Icon(Icons.refresh), onPressed: (){
            getData();
          }),
        ],),
      body: Column(children: <Widget>[
        Expanded(child: UsersList(_isSearching?this.searchResult:this.clients)),
      ]),
      floatingActionButton: FloatingActionButton(child: Icon(Icons.clear_all),onPressed: (){
        //clearAllAnimation
      },),
    );
  }
}