import 'package:chronicle/Models/registerModel.dart';
import 'package:chronicle/Widgets/registerOptionBottomSheet.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chronicle/database.dart';
import '../Models/clientModel.dart';
import '../clientList.dart';
import '../customColors.dart';
import '../registerNewClientWidget.dart';

class ClientPage extends StatefulWidget {
  final User user;
  final RegisterModel register;

  ClientPage(this.user,this.register);

  @override
  _ClientPageState createState() => _ClientPageState();
}

class _ClientPageState extends State<ClientPage> {
  List<ClientModel> clients = [];
  bool _isSearching=false;

  List<ClientModel> searchResult = [];
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
      this.appBarTitle = Text(widget.register.name!,
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
      searchResult=clients.where((ClientModel element) => (element.name!.toLowerCase()).contains(searchText.toLowerCase().replaceAll(new RegExp(r"\s+"), ""))).toList();
      setState(() {
      });
    }
  }
  void newClientModel(ClientModel client) {
    client.setId(registerUser(client,widget.user,widget.register.id!.key.replaceAll("registers", "")));
    this.setState(() {
      clients.add(client);
    });
  }
  void updateClientModel() {
    this.setState(() {
    });
  }

  void getClientModels() {
    getAllClients(widget.user,widget.register.id!.key.replaceAll("registers", "")).then((clients) => {
      this.setState(() {
        this.clients = clients;
      })
    });
  }

  @override
  void initState() {
    super.initState();
    getClientModels();
    appBarTitle=GestureDetector(child: Container(child: Text(widget.register.name!),),
      onTap: (){showModalBottomSheet(context: context, builder: (_)=>RegisterOptionBottomSheet(list: [],));},);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.firebaseNavy,
      appBar: AppBar(backgroundColor: CustomColors.firebaseNavy,
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
          IconButton(icon: Icon(Icons.notifications_active,color: Colors.white), onPressed: null),
        ],),
      body: Column(children: <Widget>[
        Expanded(child: ClientList(_isSearching?this.searchResult:this.clients, widget.user)),
      ]),
      floatingActionButton: RegisterNewClientWidget(this.newClientModel),
    );
  }
}
