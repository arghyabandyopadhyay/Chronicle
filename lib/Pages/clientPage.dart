import 'package:chronicle/Models/DrawerActionModel.dart';
import 'package:chronicle/Models/registerIndexModel.dart';
import 'package:chronicle/Models/userModel.dart';
import 'package:chronicle/Modules/auth.dart';
import 'package:chronicle/Modules/errorPage.dart';
import 'package:chronicle/Modules/sharedPreferenceHandler.dart';
import 'package:chronicle/Modules/universalModule.dart';
import 'package:chronicle/Pages/globalClass.dart';
import 'package:chronicle/Pages/myHomePage.dart';
import 'package:chronicle/Pages/qrCodePage.dart';
import 'package:chronicle/Pages/settingsPage.dart';
import 'package:chronicle/Pages/userInfoScreen.dart';
import 'package:chronicle/Widgets/DrawerContent.dart';
import 'package:chronicle/Widgets/registerOptionBottomSheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chronicle/Modules/database.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_tools/qr_code_tools.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sms/sms.dart';
import '../Models/clientModel.dart';
import '../Widgets/clientList.dart';
import '../Widgets/registerNewClientWidget.dart';
import 'SignInScreen.dart';
import 'clientInformationPage.dart';
import 'notificationsPage.dart';


class ClientPage extends StatefulWidget {
  final RegisterIndexModel register;

  ClientPage(this.register);

  @override
  _ClientPageState createState() => _ClientPageState();
}

class _ClientPageState extends State<ClientPage> {
  List<ClientModel> clients;
  List<ClientModel> selectedList=[];
  int _counter=0;
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
  final TextEditingController textEditingController=new TextEditingController();
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
                child: Padding(child: Icon(Icons.swap_horizontal_circle_rounded,size: 20,),padding: EdgeInsets.only(left: 3),)
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
      searchResult=clients.where((ClientModel element) => (element.masterFilter).contains(searchText.toLowerCase().replaceAll(new RegExp(r"\W+"), ""))).toList();
      setState(() {
      });
    }
  }
  void newClientModel(ClientModel client) {
    client.masterFilter=(client.name+((client.mobileNo!=null)?client.mobileNo:"")+((client.startDate!=null)?client.startDate.toIso8601String():"")+((client.endDate!=null)?client.endDate.toIso8601String():"")).replaceAll(new RegExp(r'\W+'),"").toLowerCase();
    client.setId(registerUser(client,widget.register.uid));
    this.setState(() {
      clients.add(client);
    });
  }
  void getClientModels() {
    getAllClients(widget.register.uid).then((clients) => {
      this.setState(() {
        this.clients = clients;
        _counter++;
      })
    });
  }
  getAppBar(){
    if(selectedList.length < 1)
      return AppBar(
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
          IconButton(icon: Icon(Icons.info), onPressed: (){
            int totalDues=0;
            int totalPaid=0;
            int totalLastMonths=0;
            int totalPaidClients=0;
            int totalDuedClients=0;
            clients.forEach((element) {
              if(element.due>0){
                totalDues=totalDues+element.due;
                totalDuedClients=totalDuedClients+1;
              }
              else if(element.due<0) {
                totalPaid=totalPaid+element.due.abs()+1;
                totalPaidClients=totalPaidClients+1;
              }
              else totalLastMonths++;
            });
            showDialog(context: context, builder: (_)=>AlertDialog(
              title: Text("${widget.register.name}"),
              content: Container(child: Column(
                mainAxisAlignment:MainAxisAlignment.spaceEvenly,
                children: [
                Container(
                  height: 50,
                  padding: EdgeInsets.all(10),
                  child:Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Total Dues:",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 17.0,),
                      ),
                      Expanded(child: Text(totalDues.toString(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 17.0,),
                        textAlign: TextAlign.end,
                      ))
                    ],
                  ),
                ),
                Container(
                  height: 50,
                  padding: EdgeInsets.all(10),
                  child:Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Total Paid:",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 17.0,),
                      ),
                      Expanded(child: Text(totalPaid.toString(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 17.0,),
                        textAlign: TextAlign.end,
                      ))
                    ],
                  ),
                ),
                  SizedBox(height: 10,),
                  Center(child: Text("*The data is in Months."),),
                  Container(
                    height: 50,
                    padding: EdgeInsets.all(10),
                    child:Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Due Clients:",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 17.0,),
                        ),
                        Expanded(child: Text(totalDuedClients.toString(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 17.0,),
                          textAlign: TextAlign.end,
                        ))
                      ],
                    ),
                  ),
                  Container(
                    height: 50,
                    padding: EdgeInsets.all(10),
                    child:Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Paid Clients:",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 17.0,),
                        ),
                        Expanded(child: Text(totalPaidClients.toString(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 17.0,),
                          textAlign: TextAlign.end,
                        ))
                      ],
                    ),
                  ),
                  Container(
                    height: 50,
                    padding: EdgeInsets.all(10),
                    child:Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Last Months:",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 17.0,),
                        ),
                        Expanded(child: Text(totalLastMonths.toString(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 17.0,),
                          textAlign: TextAlign.end,
                        ))
                      ],
                    ),
                  ),
                  Container(
                    height: 50,
                    padding: EdgeInsets.all(10),
                    child:Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Total Clients:",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 17.0,),
                        ),
                        Expanded(child: Text((totalLastMonths+totalDuedClients+totalPaidClients).toString(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 17.0,),
                          textAlign: TextAlign.end,
                        ))
                      ],
                    ),
                  ),
                  SizedBox(height: 10,),
                  Center(child: Text("*The data is in no of clients."),),
                ],),height: 500,),
              actions: [
                ActionChip(label: Text("Close"), onPressed: (){
                  Navigator.of(_).pop();
                }),
              ],
            ));
          }),
        ],);
    else
      return AppBar(
        elevation: 0,
        title: Text("${selectedList.length} item selected"),
        leading:IconButton(
          icon: Icon(Icons.clear,),
          onPressed: (){
            setState(() {
              for(ClientModel a in selectedList)
              {
                a.isSelected=false;
              }
              selectedList.clear();
            });
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.select_all,),
            onPressed: (){
              setState(() {
                selectedList.clear();
                selectedList.addAll(_isSearching?searchResult:clients);
                for(ClientModel a in selectedList)
                {
                  a.isSelected=true;
                }
              });
            },
          ),
          IconButton(
            onPressed: () async {
              showDialog(context: context, builder: (_)=>new AlertDialog(
                title: Text("Type the message you want to send"),
                content: Container(
                    height: 150,
                    child:TextFormField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                    maxLength: 200,
                    controller: textEditingController,
                    textInputAction: TextInputAction.newline,
                    style: TextStyle(),
                    expands: true,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: "Message",
                      prefixText: "[Client Name,]",
                      helperText: "Type the message you want to be sent to the selected Clients",
                      contentPadding:EdgeInsets.all(10.0),
                    ),
                )),
                actions: [ActionChip(label: Text("Send"), onPressed: (){
                  if(textEditingController.text!=""){
                    Navigator.of(_).pop();
                    showDialog(context: context, builder: (_)=>new AlertDialog(
                      title: Text("Confirm Send"),
                      content: Text("Are you sure to send the message to all the selected clients?"),
                      actions: [
                        ActionChip(label: Text("Yes"), onPressed: (){
                          setState(() {
                            SmsSender sender = new SmsSender();
                            selectedList.forEach((element) {
                              String address = element.mobileNo;
                              String message = "${element.name}, ${textEditingController.text}";
                              if(address!=null&&address!="")
                                sender.sendSms(new SmsMessage(address, message));
                            });
                            globalShowInSnackBar(scaffoldMessengerKey,"Message Sent!!");
                            for(ClientModel a in selectedList)
                            {
                              a.isSelected=false;
                            }
                            selectedList.clear();
                            textEditingController.clear();
                            Navigator.of(_).pop();
                          });
                        }),
                        ActionChip(label: Text("No"), onPressed: (){
                          setState(() {
                            textEditingController.clear();
                            Navigator.of(_).pop();
                          });
                        })
                      ],
                    ));
                  }
                  else{
                    globalShowInSnackBar(scaffoldMessengerKey, "You can't send null message to your clients.");
                    Navigator.of(_).pop();
                  }
                }),
                  ActionChip(label: Text("Cancel"), onPressed: (){
                    Navigator.of(_).pop();
                  }),],
              ));
            },
            icon: Icon(Icons.send),
          ),
          IconButton(
            onPressed: () async {
              showDialog(context: context, builder: (_)=>new AlertDialog(
                title: Text("Confirm Delete"),
                content: Text("Are you sure to delete all the selected clients?\n The change is irreversible."),
                actions: [
                  ActionChip(label: Text("Yes"), onPressed: (){
                    setState(() {
                      selectedList.forEach((element) {
                        deleteDatabaseNode(element.id);
                        if(_isSearching)searchResult.remove(element);
                        clients.remove(element);
                      });
                      for(ClientModel a in selectedList)
                      {
                        a.isSelected=false;
                      }
                      if(_isSearching)_handleSearchEnd();
                      selectedList.clear();
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
            icon: Icon(Icons.delete),
          )
        ],
      );
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
                child: Padding(child: Icon(Icons.swap_horizontal_circle_rounded,size: 20,),padding: EdgeInsets.only(left: 3),)
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
              setLastRegister("");
              GlobalClass.lastRegister="";
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
            DrawerActionModel(Icons.settings, "Settings", ()async{
              Navigator.pop(context);
              Navigator.of(context).push(CupertinoPageRoute(builder: (context)=>SettingsPage()));
            }),
          ],
        ),
      ),
      appBar: getAppBar(),
      body: this.clients!=null?this.clients.length==0?NoDataError():Column(children: <Widget>[
        Expanded(child: _isSearching?
        Provider.value(
            value: _counter,
            updateShouldNotify: (oldValue, newValue) => true,
            child: ClientList(listItems:this.searchResult,
                scaffoldMessengerKey:scaffoldMessengerKey,
                onTapList:(index){
                if(selectedList.length<1)Navigator.of(context).push(CupertinoPageRoute(builder: (context)=>ClientInformationPage(client:this.searchResult[index])));
                else {
                  setState(() {
                    searchResult[index].isSelected=!searchResult[index].isSelected;
                    if (searchResult[index].isSelected) {
                      selectedList.add(searchResult[index]);
                    } else {
                      selectedList.remove(searchResult[index]);
                    }
                  });
                }
              },
              onLongPressed:(index)
              {
                setState(() {
                  searchResult[index].isSelected=!searchResult[index].isSelected;
                  if (searchResult[index].isSelected) {
                    selectedList.add(searchResult[index]);
                  } else {
                    selectedList.remove(searchResult[index]);
                  }
                });
              },
              onDoubleTapList:(index){
              if(selectedList.length<1)showDialog(context: context, builder: (_)=>new AlertDialog(
                title: Text("Confirm Delete"),
                content: Text("Are you sure to delete ${searchResult[index].name}?"),
                actions: [
                  ActionChip(label: Text("Yes"), onPressed: (){
                    setState(() {
                      deleteDatabaseNode(searchResult[index].id);
                      globalShowInSnackBar(scaffoldMessengerKey,"Client Data ${searchResult[index].name} deleted!!");
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
              if(selectedList.length<1)Navigator.of(context).push(CupertinoPageRoute(builder: (context)=>ClientInformationPage(client:this.clients[index])));
              else {
                setState(() {
                  clients[index].isSelected=!clients[index].isSelected;
                  if (clients[index].isSelected) {
                    selectedList.add(clients[index]);
                  } else {
                    selectedList.remove(clients[index]);
                  }
                });
              }
            },
              onLongPressed:(index)
          {
            setState(() {
              clients[index].isSelected=!clients[index].isSelected;
              if (clients[index].isSelected) {
                selectedList.add(clients[index]);
              } else {
                selectedList.remove(clients[index]);
              }
            });
          },
              onDoubleTapList:(index){
            if(selectedList.length<1)showDialog(context: context, builder: (_)=>new AlertDialog(
              title: Text("Confirm Delete"),
              content: Text("Are you sure to delete ${clients[index].name}?"),
              actions: [
                ActionChip(label: Text("Yes"), onPressed: (){
                  setState(() {
                    deleteDatabaseNode(clients[index].id);
                    globalShowInSnackBar(scaffoldMessengerKey,"Client Data ${clients[index].name}, deleted!!");
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
      floatingActionButton:RegisterNewClientWidget(this.newClientModel),
    ),key:scaffoldMessengerKey);
  }
}
