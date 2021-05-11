import 'package:chronicle/Models/modalOptionModel.dart';
import 'package:chronicle/Modules/apiModule.dart';
import 'package:chronicle/Modules/errorPage.dart';
import 'package:chronicle/Modules/universalModule.dart';
import 'package:chronicle/Widgets/optionModalBottomSheet.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chronicle/Modules/database.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sms/sms.dart';
import '../Models/clientModel.dart';
import '../Widgets/clientList.dart';
import '../customColors.dart';
import 'clientInformationPage.dart';
import 'globalClass.dart';

class NotificationsPage extends StatefulWidget {
  static const String routeName = '/notificationPage';
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  List<ClientModel> clients;
  int _counter=0;
  GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey=GlobalKey();
  bool _isSearching=false;
  List<ClientModel> searchResult = [];
  Icon icon = new Icon(
    Icons.search,
  );
  bool _isLoading;
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
      this.appBarTitle = Text("Notifications",
      );
      _isSearching = false;
      _searchController.clear();
    });
  }
  void searchOperation(String searchText)
  {
    searchResult.clear();
    if(_isSearching){
      searchResult=clients.where((ClientModel element) => (element.masterFilter.toLowerCase()).contains(searchText.toLowerCase().replaceAll(new RegExp(r"\s+"), ""))).toList();
      setState(() {
      });
    }
  }

  void getNotifications() {
    getNotificationClients(context).then((clients) => {
      this.setState(() {
        this.clients = clients;
        _counter++;
        _isLoading=false;
        this.appBarTitle = Text("Notifications",);
      })
    });
  }
  @override
  void initState() {
    super.initState();
    _isLoading = false;
    getNotifications();
    appBarTitle=Text("Notifications");
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
          IconButton(
            onPressed: () async {
              showModalBottomSheet(context: context, builder: (_)=>
                  OptionModalBottomSheet(
                    appBarIcon: Icons.send,
                    appBarText: "How to send the reminder",
                    list: [
                      ModalOptionModel(
                          particulars: "Send Sms using Default Sim",
                          icon: Icons.sim_card_outlined,
                          onTap: (){
                            Navigator.of(_).pop();
                            showDialog(context: context, builder: (_)=>new AlertDialog(
                              title: Text("Confirm Send"),
                              content: Text("Are you sure to send a reminder to all the clients?"),
                              actions: [
                                ActionChip(label: Text("Yes"), onPressed: (){
                                  SmsSender sender = new SmsSender();
                                  clients.forEach((ClientModel element) {
                                    String address = element.mobileNo;
                                    if(address!=null&&address!="")
                                      sender.sendSms(new SmsMessage(address, "${element.name}, ${GlobalClass.userDetail.reminderMessage!=null&&GlobalClass.userDetail.reminderMessage!=""?GlobalClass.userDetail.reminderMessage:"Your subscription has come to an end"
                                          ", please clear your dues for further continuation of services."}"));
                                  });
                                  Navigator.of(_).pop();
                                }),
                                ActionChip(label: Text("No"), onPressed: (){
                                  Navigator.of(_).pop();
                                })
                              ],
                            ));

                          }),
                      ModalOptionModel(
                          particulars: "Send Sms using Sms Gateway",
                          icon: FontAwesomeIcons.server,
                          onTap: (){
                            if(GlobalClass.userDetail.smsAccessToken!=null
                                &&GlobalClass.userDetail.smsApiUrl!=null
                                &&GlobalClass.userDetail.smsUserId!=null
                                &&GlobalClass.userDetail.smsMobileNo!=null
                                &&GlobalClass.userDetail.smsAccessToken!=""
                                &&GlobalClass.userDetail.smsApiUrl!=""
                                &&GlobalClass.userDetail.smsUserId!=""
                                &&GlobalClass.userDetail.smsMobileNo!=""
                            ){
                              Navigator.of(_).pop();
                              showDialog(context: context, builder: (_)=>new AlertDialog(
                                title: Text("Confirm Send"),
                                content: Text("Are you sure to send the message to all the selected clients?"),
                                actions: [
                                  ActionChip(label: Text("Yes"), onPressed: (){
                                    try{
                                      postForBulkMessage(clients,"${GlobalClass.userDetail.reminderMessage!=null&&GlobalClass.userDetail.reminderMessage!=""?GlobalClass.userDetail.reminderMessage:"Your subscription has come to an end"
                                          ", please clear your dues for further continuation of services."}");
                                      globalShowInSnackBar(scaffoldMessengerKey,"Message Sent!!");
                                    }
                                    catch(E){
                                      globalShowInSnackBar(scaffoldMessengerKey,"Something Went Wrong!!");
                                    }
                                    Navigator.of(_).pop();
                                  }),
                                  ActionChip(label: Text("No"), onPressed: (){
                                    Navigator.of(_).pop();
                                  })
                                ],
                              ));
                            }
                            else{
                              globalShowInSnackBar(scaffoldMessengerKey, "Please configure Sms Gateway Data in Settings.");
                              Navigator.of(_).pop();
                            }
                          }),],));
            },
            icon: Icon(Icons.send),
          ),
          IconButton(icon: Icon(Icons.refresh), onPressed: () async {
            try{
              Connectivity connectivity=Connectivity();
              await connectivity.checkConnectivity().then((value)async => {
                if(value!=ConnectivityResult.none)
                  {
                    if(!_isLoading){
                      setState(() {
                        _isLoading=true;
                      }),
                      getNotifications(),
                    }
                    else{
                      globalShowInSnackBar(scaffoldMessengerKey, "Data is being loaded...")
                    }
                  }
                else{
                  setState(() {
                    _isLoading=false;
                  }),
                  globalShowInSnackBar(scaffoldMessengerKey,"No Internet Connection!!")
                }
              });
            }
            catch(E)
            {
              setState(() {
                _isLoading=false;
              });
              globalShowInSnackBar(scaffoldMessengerKey,"Something Went Wrong");
            }
          }),
        ],),
      body: this.clients!=null?this.clients.length==0?NoDataError():Column(children: <Widget>[
        Expanded(child: _isSearching?Provider.value(
            value: _counter,
            updateShouldNotify: (oldValue, newValue) => true,
            child: ClientList(listItems:this.searchResult,
                scaffoldMessengerKey:scaffoldMessengerKey,
                onTapList:(index){
                  Navigator.of(context).push(CupertinoPageRoute(builder: (context)=>ClientInformationPage(client:this.searchResult[index])));
                },
                onLongPressed:(index) {},
                onDoubleTapList:(index){
                  showDialog(context: context, builder: (_)=>new AlertDialog(
                    title: Text("Confirm Delete"),
                    content: Text("Are you sure to delete ${searchResult[index].name}?"),
                    actions: [
                      ActionChip(label: Text("Yes"), onPressed: (){
                        setState(() {
                          deleteDatabaseNode(searchResult[index].id);
                          searchResult.removeAt(index);
                          Navigator.of(_).pop();
                        });
                      }),
                      ActionChip(label: Text("No"), onPressed: (){
                        setState(() {
                          Navigator.of(_).pop();
                        });
                      })
                    ],
                  ));
                }
            )):
        Provider.value(
            value: _counter,
            updateShouldNotify: (oldValue, newValue) => true,
            child: ClientList(listItems:this.clients,scaffoldMessengerKey:scaffoldMessengerKey,
                onTapList:(index){
                  Navigator.of(context).push(CupertinoPageRoute(builder: (context)=>ClientInformationPage(client:this.clients[index])));
                },
                onLongPressed:(index) {},
                onDoubleTapList:(index){
                  showDialog(context: context, builder: (_)=>new AlertDialog(
                    title: Text("Confirm Delete"),
                    content: Text("Are you sure to delete ${clients[index].name}?"),
                    actions: [
                      ActionChip(label: Text("Yes"), onPressed: (){
                        setState(() {
                          deleteDatabaseNode(clients[index].id);
                          clients.removeAt(index);
                          Navigator.of(_).pop();
                        });
                      }),
                      ActionChip(label: Text("No"), onPressed: (){
                        setState(() {
                          Navigator.of(_).pop();
                        });
                      })
                    ],
                  ));
                }
            ))),
        if(_isLoading)Container(color:Colors.black87,child: Row(mainAxisAlignment:MainAxisAlignment.center,children: <Widget>[Container(height:_isLoading?40:0,width:_isLoading?40:0,padding:EdgeInsets.all(10),child: CircularProgressIndicator(strokeWidth: 3,backgroundColor: CustomColors.firebaseBlue,),),Text("Loading...",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),)]),),
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
      // floatingActionButton: FloatingActionButton(child: Icon(Icons.clear_all),onPressed: (){
      //   //clearAllAnimation
      // },),
    ),key: scaffoldMessengerKey,);
  }
}
