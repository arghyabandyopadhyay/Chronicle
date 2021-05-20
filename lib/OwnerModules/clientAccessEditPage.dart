import 'package:chronicle/Models/modalOptionModel.dart';
import 'package:chronicle/OwnerModules/chronicleUserModel.dart';
import 'package:chronicle/Models/userModel.dart';
import 'package:chronicle/Modules/errorPage.dart';
import 'package:chronicle/OwnerModules/ownerModule.dart';
import 'package:chronicle/Modules/universalModule.dart';
import 'package:chronicle/OwnerModules/chronicleUsersList.dart';
import 'package:chronicle/Widgets/Simmers/loaderWidget.dart';
import 'package:chronicle/Widgets/optionModalBottomSheet.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../customColors.dart';
import 'ownerDatabaseModule.dart';

class ClientAccessEditPage extends StatefulWidget {
  @override
  _ClientAccessEditPageState createState() => _ClientAccessEditPageState();
}

class _ClientAccessEditPageState extends State<ClientAccessEditPage> {
  List<ChronicleUserModel> clients;
  bool _isSearching=false;
  bool _isLoading;
  List<ChronicleUserModel> searchResult = [];
  TextEditingController textEditingController=new TextEditingController();
  ScrollController scrollController = new ScrollController();
  GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey=GlobalKey<ScaffoldMessengerState>();
  Icon icon = new Icon(
    Icons.search,
  );
  //Controller
  final TextEditingController _searchController = new TextEditingController();
  //Widgets
  Widget appBarTitle = Text("");
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
    if(userDetails!=null){
      ChronicleUserModel chronicleUserModel=new ChronicleUserModel(uid: uid,email: userDetails.email,canAccess: 0,displayName: userDetails.displayName);
      chronicleUserModel.setId(chronicleUserRegistration(chronicleUserModel));
      userDetails.isAppRegistered=1;
      userDetails.canAccess=0;
      userDetails.update();
      if(mounted)this.setState(() {
        clients.add(chronicleUserModel);
      });
    }
    else globalShowInSnackBar(scaffoldMessengerKey,"No Such user found!!");
  }
  Future<Null> refreshData(bool isNotSwipeDownRefresh) async{
      try{
        if(_isSearching)_handleSearchEnd();
        Connectivity connectivity=Connectivity();
        await connectivity.checkConnectivity().then((value)async {
          if(value!=ConnectivityResult.none)
          {
            if(!_isLoading){
              if(isNotSwipeDownRefresh)setState(() {
                _isLoading=true;
              });
              return getAllChronicleClients().then((clients) => {
                if(mounted)this.setState(() {
                  this.clients = clients;
                  _isLoading=false;
                })
              });
            }
            else{
              globalShowInSnackBar(scaffoldMessengerKey, "Data is being loaded...");
              return null;
            }
          }
          else{
            setState(() {
              _isLoading=false;
            });
            globalShowInSnackBar(scaffoldMessengerKey,"No Internet Connection!!");
            return null;
          }
        });
      }
      catch(E)
      {
        setState(() {
          _isLoading=false;
        });
        globalShowInSnackBar(scaffoldMessengerKey,"Something Went Wrong");
        return;
      }
  }
  void getData() {
    getAllChronicleClients().then((clients) => {
      if(mounted)this.setState(() {
        this.clients = clients;
        _isLoading=false;
      })
    });
  }
  synchronizeCloudStorageSizes() async {
    await Future.forEach(clients,(element) async {
      UserModel user=await getChronicleUserDetails(element.uid);
      element.cloudStorageSize=user.cloudStorageSize;
      element.update(false);
    });
    setState(() {
      globalShowInSnackBar(scaffoldMessengerKey, "Cloud Occupied data synchronized");
    });
  }
  @override
  void initState() {
    super.initState();
    _isLoading=false;
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
                this.appBarTitle=TextFormField(autofocus:true,controller: _searchController,style: TextStyle(fontSize: 15),decoration: InputDecoration(border: const OutlineInputBorder(borderSide: BorderSide.none),hintText: "Search Clients",hintStyle: TextStyle(fontSize: 15)),onChanged: searchOperation,);
                _handleSearchStart();
              }
              else _handleSearchEnd();
            });
          }),
          PopupMenuButton<ModalOptionModel>(
            itemBuilder: (BuildContext popupContext){
              return [
                ModalOptionModel(particulars: "Sort",icon: Icons.sort,iconColor:CustomColors.sortIconColor,onTap: (){
                  Navigator.pop(popupContext);
                  showModalBottomSheet(
                      context: context,
                      builder: (BuildContext alertDialogContext) {
                        return OptionModalBottomSheet(
                            appBarText: "Sort Options",
                            appBarIcon: Icons.sort,
                            list: [
                              ModalOptionModel(
                                icon:Icons.sort_by_alpha_outlined,iconColor: CustomColors.atozIconColor,
                                particulars:"A-Z",
                                onTap: (){setState(() {
                                  clients=sortChronicleUsersModule("A-Z", clients);
                                });
                                Navigator.pop(alertDialogContext);
                                },
                              ),
                              ModalOptionModel(
                                icon:Icons.sort_by_alpha_outlined,iconColor: CustomColors.ztoaIconColor,
                                particulars:"Z-A",
                                onTap: (){setState(() {
                                  clients=sortChronicleUsersModule("Z-A", clients);
                                });
                                Navigator.pop(alertDialogContext);
                                },
                              ),
                            ]
                        );
                      }
                  );
                }),
                if(this.clients!=null&&this.clients.length!=0)ModalOptionModel(particulars: "Move to top",icon:Icons.vertical_align_top_outlined,iconColor:CustomColors.moveToTopIconColor, onTap: () async {
                  Navigator.pop(popupContext);
                  scrollController.animateTo(
                    scrollController.position.minScrollExtent,
                    duration: Duration(seconds: 1),
                    curve: Curves.fastOutSlowIn,
                  );
                }),
                ModalOptionModel(particulars: "Sync Cloud Occupied Data",icon:Icons.sync,iconColor:CustomColors.moveToTopIconColor, onTap: () async {
                  Navigator.pop(popupContext);
                  synchronizeCloudStorageSizes();
                }),
              ].map((ModalOptionModel choice){
                return PopupMenuItem<ModalOptionModel>(
                  value: choice,
                  child: ListTile(title: Text(choice.particulars),leading: Icon(choice.icon,color: choice.iconColor),onTap: choice.onTap,),
                );
              }).toList();
            },
          ),
        ],),
      body: this.clients!=null?this.clients.length==0?NoDataError():Column(children: <Widget>[
        Expanded(child: ChronicleUsersList(_isSearching?this.searchResult:this.clients,(){
          return refreshData(false);
        },scrollController)),
      ]):
      LoaderWidget(),
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
              if(clients.where((element) => element.uid==textEditingController.text).toList().length==0)registerClientUsingToken(textEditingController.text);
              else globalShowInSnackBar(scaffoldMessengerKey, "User already present!!");

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
