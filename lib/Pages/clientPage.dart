import 'package:chronicle/Models/DrawerActionModel.dart';
import 'package:chronicle/Models/registerModel.dart';
import 'package:chronicle/Models/userModel.dart';
import 'package:chronicle/Modules/auth.dart';
import 'package:chronicle/Modules/sharedPreferenceHandler.dart';
import 'package:chronicle/Modules/universalModule.dart';
import 'package:chronicle/Pages/myHomePage.dart';
import 'package:chronicle/Pages/qrCodePage.dart';
import 'package:chronicle/Pages/userInfoScreen.dart';
import 'package:chronicle/Widgets/DrawerContent.dart';
import 'package:chronicle/Widgets/registerOptionBottomSheet.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chronicle/Modules/database.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_code_tools/qr_code_tools.dart';
import 'package:shimmer/shimmer.dart';
import '../Models/clientModel.dart';
import '../Widgets/clientList.dart';
import '../customColors.dart';
import '../Widgets/registerNewClientWidget.dart';
import 'SignInScreen.dart';
import 'notificationsPage.dart';

class ClientPage extends StatefulWidget {
  final RegisterModel register;

  ClientPage(this.register);

  @override
  _ClientPageState createState() => _ClientPageState();
}

class _ClientPageState extends State<ClientPage> {
  List<ClientModel> clients;
  PickedFile _imageFile;
  GlobalKey<ScaffoldState> scaffoldKey=GlobalKey<ScaffoldState>();
  GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey=GlobalKey<ScaffoldMessengerState>();
  bool _isSearching=false;
  int sortVal=1;
  List<ClientModel> searchResult = [];
  Icon icon = new Icon(
    Icons.search,
  );
  //Controller
  final TextEditingController _searchController = new TextEditingController();
  //Widgets
  Widget appBarTitle;
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
      this.appBarTitle = GestureDetector(child: Container(
        child: RichText(
          text: TextSpan(
            children: [
              WidgetSpan(child: Text(widget.register.name)),
              WidgetSpan(
                child: Padding(child: Icon(Icons.swap_horizontal_circle_rounded),padding: EdgeInsets.only(left: 3),)
              ),
            ],
          ),
        ),),
        onTap: (){showModalBottomSheet(context: context, builder: (_)=>RegisterOptionBottomSheet());},);
      _isSearching = false;
      _searchController.clear();
    });
  }
  void searchOperation(String searchText)
  {
    searchResult.clear();
    if(_isSearching){
      searchResult=clients.where((ClientModel element) => (element.name.toLowerCase()).contains(searchText.toLowerCase().replaceAll(new RegExp(r"\s+"), ""))).toList();
      setState(() {
      });
    }
  }
  void newClientModel(ClientModel client) {
    client.setId(registerUser(client,widget.register.id.key.replaceAll("registers", "")));
    this.setState(() {
      clients.add(client);
    });
  }
  void updateClientModel() {
    this.setState(() {
    });
  }

  void getClientModels() {
    getAllClients(widget.register.id.key.replaceAll("registers", "")).then((clients) => {
      this.setState(() {
        this.clients = clients;
      })
    });
  }

  @override
  void initState() {
    super.initState();
    getClientModels();
    appBarTitle=GestureDetector(child: Container(
      child: RichText(
        text: TextSpan(
          children: [
            WidgetSpan(child: Text(widget.register.name)),
            WidgetSpan(
                child: Padding(child: Icon(Icons.swap_horizontal_circle_rounded),padding: EdgeInsets.only(left: 3),)
            ),
          ],
        ),
      ),),
      onTap: (){showModalBottomSheet(context: context, builder: (_)=>RegisterOptionBottomSheet());},);
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(child: Scaffold(
      key:scaffoldKey,
      drawer: Drawer(
        child: DrawerContent(
          scaffoldMessengerKey: scaffoldMessengerKey,
          drawerItems: [
            DrawerActionModel(Icons.notifications, "Notifications", ()async{
              Navigator.pop(context);
              Navigator.of(context).push(CupertinoPageRoute(builder: (context)=>NotificationsPage()));
            }),
            DrawerActionModel(Icons.book, "Registers", ()async{
              setLastRegister(null);
              Navigator.pop(context);
              Navigator.of(context).pushReplacement(CupertinoPageRoute(builder: (context)=>MyHomePage()));
            }),
            DrawerActionModel(Icons.qr_code, "QR code", ()async{
              Navigator.pop(context);
              UserModel userModel=await getUserDetails();
              if(userModel.qrcodeDetail!=null){
                Navigator.of(context).push(new CupertinoPageRoute(builder: (context)=>QrCodePage(qrCode: userModel.qrcodeDetail)));
              }
              else {
                String _data = '';
                try {
                  final pickedFile = await ImagePicker().getImage(
                    source: ImageSource.gallery,
                    maxWidth: 300,
                    maxHeight: 300,
                    imageQuality: 30,
                  );
                  setState(() {
                    _imageFile = pickedFile;
                    QrCodeToolsPlugin.decodeFrom(pickedFile.path).then((value) {
                      _data = value;
                      userModel.qrcodeDetail=_data;
                      updateUserDetails(userModel, userModel.id);
                    });

                  });
                } catch (e) {
                  globalShowInSnackBar(scaffoldMessengerKey,e);
                  setState(() {
                    _data = '';
                  });
                }
              }
            }),
            DrawerActionModel(Icons.account_circle, "Profile", ()async{
              Navigator.pop(context);
              Navigator.of(context).push(CupertinoPageRoute(builder: (context)=>UserInfoScreen()));
            }),
            DrawerActionModel(Icons.logout, "Log out", ()async{
              await Authentication.signOut(context: context);
              Navigator.popUntil(context, (route) => route.isFirst);
              Navigator.of(context).pushReplacement(PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => SignInScreen(),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  var begin = Offset(-1.0, 0.0);
                  var end = Offset.zero;
                  var curve = Curves.ease;
                  var tween =
                  Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
              ));
            }),
          ],
        ),
      ),
      appBar: AppBar(
        elevation: 0,
        title: appBarTitle,
        leading: IconButton(onPressed: () { if(!_isSearching)scaffoldKey.currentState.openDrawer(); }, icon: Icon(_isSearching?Icons.search:Icons.menu),),
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
          IconButton(icon: Icon(Icons.sort), onPressed: (){
            setState(() {
              if(sortVal==1)
              {
                List<ClientModel> temp=clients.where((element) => element.due>0).toList();
                clients.removeWhere((element) => element.due>0);
                clients.addAll(temp);
                temp=clients.where((element) => element.due<=0).toList();
                clients.removeWhere((element) => element.due<=0);
                clients.addAll(temp);
                sortVal=0;
              }
              else
              {
                List<ClientModel> temp=clients.where((element) => element.due<=0).toList();
                clients.removeWhere((element) => element.due<=0);
                clients.addAll(temp);
                temp=clients.where((element) => element.due>0).toList();
                clients.removeWhere((element) => element.due>0);
                clients.addAll(temp);
                sortVal=1;
              }
            });
          }),
          IconButton(icon: Icon(Icons.refresh), onPressed: (){
            getClientModels();
          }),
        ],),
      body: this.clients!=null?Column(children: <Widget>[
        Expanded(child: ClientList(_isSearching?this.searchResult:this.clients)),
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
      floatingActionButton: RegisterNewClientWidget(this.newClientModel),
    ),key:scaffoldMessengerKey);
  }
}
