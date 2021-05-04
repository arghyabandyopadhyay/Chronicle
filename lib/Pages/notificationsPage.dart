import 'package:chronicle/Modules/errorPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chronicle/Modules/database.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sms/sms.dart';
import '../Models/clientModel.dart';
import '../Widgets/clientList.dart';
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
      searchResult=clients.where((ClientModel element) => (element.name.toLowerCase()).contains(searchText.toLowerCase().replaceAll(new RegExp(r"\s+"), ""))).toList();
      setState(() {
      });
    }
  }
  void updateClientModel() {
    this.setState(() {
    });
  }

  void getNotifications() {
    getNotificationClients().then((clients) => {
      this.setState(() {
        this.clients = clients;
      })
    });
  }
  @override
  void initState() {
    super.initState();
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
            onPressed: () async {showDialog(context: context, builder: (_)=>new AlertDialog(
              title: Text("Confirm Send"),
              content: Text("Are you sure to send a reminder to all the clients?"),
              actions: [
                ActionChip(label: Text("Yes"), onPressed: (){
                  setState(() {
                    SmsSender sender = new SmsSender();
                    clients.forEach((ClientModel element) {
                      String address = element.mobileNo;
                      if(address!=null&&address!="")
                        sender.sendSms(new SmsMessage(address, "${element.name}, ${GlobalClass.userDetail.reminderMessage!=null&&GlobalClass.userDetail.reminderMessage!=""?GlobalClass.userDetail.reminderMessage:"Your subscription has come to an end"
                            ", please clear your dues for further continuation of services."}"));
                    });
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
            },
            icon: Icon(Icons.send),
          ),
          IconButton(icon: Icon(Icons.refresh), onPressed: (){
            getNotifications();
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
