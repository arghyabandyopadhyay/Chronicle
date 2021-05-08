import 'package:chronicle/Models/chronicleUserModel.dart';
import 'package:chronicle/Models/userModel.dart';
import 'package:chronicle/Modules/database.dart';
import 'package:chronicle/Modules/errorPage.dart';
import 'package:chronicle/Modules/ownerModule.dart';
import 'package:chronicle/Modules/universalModule.dart';
import 'package:chronicle/Widgets/chronicleUsersList.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ClientAccessEditPage extends StatefulWidget {
  @override
  _ClientAccessEditPageState createState() => _ClientAccessEditPageState();
}

class _ClientAccessEditPageState extends State<ClientAccessEditPage> {
  List<ChronicleUserModel> clients;
  bool _isSearching=false;
  List<ChronicleUserModel> searchResult = [];
  TextEditingController textEditingController=new TextEditingController();
  GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey=GlobalKey<ScaffoldMessengerState>();
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
      searchResult=clients.where((ChronicleUserModel element) => (element.displayName.toLowerCase()).contains(searchText.toLowerCase().replaceAll(new RegExp(r"\s+"), ""))).toList();
      setState(() {
      });
    }
  }
  void registerClientUsingToken(String uid) async{
    //isLoading mechanisms
    UserModel userDetails=await getChronicleUserDetails(uid);
    ChronicleUserModel chronicleUserModel=new ChronicleUserModel(uid: uid,email: userDetails.email,canAccess: 0,displayName: userDetails.displayName);
    chronicleUserModel.setId(chronicleUserRegistration(chronicleUserModel));
    userDetails.isAppRegistered=1;
    updateUserDetails(userDetails, userDetails.id);
    this.setState(() {
      clients.add(chronicleUserModel);
    });
  }
  void getData() {
    getAllChronicleClients().then((clients) => {
      this.setState(() {
        this.clients = clients;
      })
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
    appBarTitle=Text("Users");
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(child: Scaffold(
      appBar: AppBar(
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
      body: this.clients!=null?this.clients.length==0?NoDataError():Column(children: <Widget>[
        Expanded(child: ChronicleUsersList(_isSearching?this.searchResult:this.clients)),
      ]):
      Container(
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
      ),
      floatingActionButton: FloatingActionButton.extended(onPressed: (){
        showDialog(context: context, builder: (_)=>new AlertDialog(
          title: Text("Enter the UID"),
          content: TextField(controller: textEditingController,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: "UID",
              contentPadding:
              EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0),
            ),
          ),
          actions: [ActionChip(label: Text("Add"), onPressed: (){
            if(textEditingController.text!=""){
              registerClientUsingToken(textEditingController.text);
              textEditingController.clear();
              Navigator.pop(_);
            }
            else{
              globalShowInSnackBar(scaffoldMessengerKey, "Please enter a valid name for your register!!");
              Navigator.of(_).pop();
            }
          }),
            ActionChip(label: Text("Cancel"), onPressed: (){
              Navigator.of(_).pop();
            }),],
        ));
      },
        label: Text("Register User"),icon: Icon(Icons.verified_user),),
    ),key: scaffoldMessengerKey,);
  }
}
