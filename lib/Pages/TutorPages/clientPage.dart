import 'package:chronicle/Models/modalOptionModel.dart';
import 'package:chronicle/Models/registerIndexModel.dart';
import 'package:chronicle/Modules/apiModule.dart';
import 'package:chronicle/Modules/errorPage.dart';
import 'package:chronicle/Modules/universalModule.dart';
import 'package:chronicle/Pages/TutorPages/invoiceCreator.dart';
import 'package:chronicle/appBarVariables.dart';
import 'package:chronicle/globalClass.dart';
import 'package:chronicle/Widgets/loaderWidget.dart';
import 'package:chronicle/Widgets/optionModalBottomSheet.dart';
import 'package:chronicle/Widgets/registerOptionBottomSheet.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chronicle/Modules/database.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sms/sms.dart';
import '../../Models/clientModel.dart';
import '../../Widgets/clientList.dart';
import '../../Widgets/registerNewClientWidget.dart';
import '../notificationsPage.dart';
import 'clientInformationPage.dart';
import 'package:chronicle/Models/excelClientModel.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:typed_data';


class ClientPage extends StatefulWidget {
  final RegisterIndexModel register;
  final BuildContext mainScreenContext;
  final bool hideStatus;
  final GlobalKey<ScaffoldState> scaffoldKey;
  ClientPage({Key key,this.register,this.mainScreenContext,this.scaffoldKey,this.hideStatus});

  @override
  _ClientPageState createState() => _ClientPageState();
}

class _ClientPageState extends State<ClientPage> {
  List<ClientModel> clients;
  List<ClientModel> selectedList=[];
  int _counter=0;
  bool _isLoading;
  String _filePath;
  //
  GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey=GlobalKey<ScaffoldMessengerState>();
  bool _isSearching=false;

  List<ClientModel> searchResult = [];
  Icon icon = new Icon(
    Icons.search,
  );
  //Controller
  final TextEditingController _searchController = new TextEditingController();
  final TextEditingController textEditingController=new TextEditingController();
  final TextEditingController renameRegisterTextEditingController=new TextEditingController();
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey =new GlobalKey<RefreshIndicatorState>();
  ScrollController scrollController = new ScrollController();
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
      this.appBarTitle = AppBarVariables.appBarLeading(widget.mainScreenContext);
      _isSearching = false;
      _searchController.clear();
    });
  }
  void searchOperation(String searchText) {
    searchResult.clear();
    if(_isSearching){
      searchResult=clients.where((ClientModel element) => (element.masterFilter).contains(searchText.toLowerCase().replaceAll(new RegExp(r"\W+"), ""))).toList();
      setState(() {
      });
    }
  }
  Future<String> get localPath async {
    final directory = await getExternalStorageDirectory();
    return directory.path;
  }
  fileLocalName(String type, String assetPath) async {
    String dic = await localPath + "/filereader/files/";
    return dic + "ClientUploadExcelFile"+ "." + type;
  }
  void getFilePath() async {
    // try {
      FilePickerResult filePickerResult = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['xlsx', 'csv', 'xls']);
      String filePath=filePickerResult.paths[0];
      if (filePath == '') {
        return;
      }
      this._filePath = filePath;
      var bytes = File(_filePath).readAsBytesSync();
      var excel = Excel.decodeBytes(bytes);
      int i = 0;
      List<dynamic> keys = [];
      List<Map<String, dynamic>> json = [];
      for (var table in excel.tables.keys) {
        for (List<Data> row in excel.tables[table].rows) {
          if (i == 0) {
            keys = row;
            i++;
          }
          else {
            Map<String, dynamic> temp = Map<String, dynamic>();
            int j = 0;
            String tk = '';
            for (Data key in keys) {
              tk = key.value;
              temp[tk] = row[j]!=null?row[j].value.toString():null;
              j++;
            }
            json.add(temp);
          }
        }
      }

      // for (var table in excel.tables.keys) {
      //   for (var row in excel.tables[table].rows) {
      //     if (i == 0) {
      //       keys = row;
      //       i++;
      //     } else {
      //       Map<String, dynamic> temp = Map<String, dynamic>();
      //       int j = 0;
      //       String tk = '';
      //       for (String key in keys) {
      //         tk = key;
      //         temp[tk] = (row[j].runtimeType==String)?row[j].toString():row[j];
      //         j++;
      //       }
      //       json.add(temp);
      //     }
      //   }
      // }
      json.forEach((jsonItem)
      {
        ExcelClientModel excelClientModel=ExcelClientModel.fromJson(jsonItem);
        ClientModel temp=excelClientModel.toClientModel();
        newClientModel(temp);
      });
    // } catch (e) {
    //   globalShowInSnackBar(scaffoldMessengerKey, "Something Went Wrong !!"+e.toString());
    // }
  }
  fileExists(String type, String assetPath) async {
    String fileName = await fileLocalName(type, assetPath);
    if (await File(fileName).exists()) {
      return true;
    }
    return false;
  }
  asset2Local(String type, String assetPath) async {
    var path=await fileLocalName(type, assetPath);
    File file = File(path);
    if (await fileExists(type, assetPath)) {
      await file.delete();
    }
    await file.create(recursive: true);
    ByteData bd = await rootBundle.load(assetPath);
    await file.writeAsBytes(bd.buffer.asUint8List(), flush: true);
    await OpenFile.open(path);
    return true;
  }
  void newClientModel(ClientModel client) {
    client.setId(addClientInRegister(client,widget.register.uid));
    if(mounted)this.setState(() {
      clients.add(client);
    });
  }
  Future<Null> refreshData() async{
    if(selectedList.length!=0){
      setState(() {
        for(ClientModel a in selectedList)
        {
          a.isSelected=false;
        }
        if(_isSearching)_handleSearchEnd();
        selectedList.clear();
      });
    }
    try{
      if(_isSearching)_handleSearchEnd();
      Connectivity connectivity=Connectivity();
      await connectivity.checkConnectivity().then((value)async {
        if(value!=ConnectivityResult.none)
        {
          if(!_isLoading){
            _isLoading=true;
            return getAllClients(widget.register.uid).then((clients) {
              if(mounted)this.setState(() {
                this.clients = clients;
                _counter++;
                _isLoading=false;
                this.appBarTitle = AppBarVariables.appBarLeading(widget.mainScreenContext);
              });
            });
          }
          else{
            globalShowInSnackBar(scaffoldMessengerKey, "Data is being loaded...");
            return;
          }
        }
        else{
          setState(() {
            _isLoading=false;
          });
          globalShowInSnackBar(scaffoldMessengerKey,"No Internet Connection!!");
          return;
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

  void getClientModels() {
    getAllClients(widget.register.uid).then((clients) => {
      if(mounted)this.setState(() {
        this.clients = clients;
        _counter++;
        _isLoading=false;
        this.appBarTitle = AppBarVariables.appBarLeading(widget.mainScreenContext);
      })
    });
  }
  getAppBar(){
    if(selectedList.length < 1)
      return AppBar(
        title: appBarTitle,
        // leading: IconButton(onPressed: () { if(!_isSearching)widget.scaffoldKey.currentState.openDrawer(); }, icon: Icon(_isSearching?Icons.search:Icons.menu),),
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
          new IconButton(icon: Icon(Icons.notifications_outlined), onPressed:(){
            setState(() {
              Navigator.of(widget.mainScreenContext).push(CupertinoPageRoute(builder: (notificationPageContext)=>NotificationsPage()));
            });
          }),
          PopupMenuButton<ModalOptionModel>(
            itemBuilder: (BuildContext popupContext){
              return [
                ModalOptionModel(particulars: "Sort",icon: Icons.sort,onTap: (){
                Navigator.pop(popupContext);
                showModalBottomSheet(
                    context: widget.mainScreenContext,
                    builder: (BuildContext alertDialogContext) {
                      return OptionModalBottomSheet(
                        appBarText: "Sort Options",
                        appBarIcon: Icons.sort,
                        list: [
                          ModalOptionModel(
                            icon:Icons.more_time,

                            particulars:"Dues First",
                            onTap: (){setState(() {
                              clients=sortClientsModule("Dues First", clients);
                            });
                            Navigator.pop(alertDialogContext);
                            },
                          ),
                          ModalOptionModel(
                            icon:Icons.hourglass_bottom_outlined,
                            particulars:"Last Months First",
                            onTap: (){setState(() {
                              clients=sortClientsModule("Last Months First", clients);
                            });
                            Navigator.pop(alertDialogContext);
                            },
                          ),
                          ModalOptionModel(
                            icon:Icons.payment_outlined,
                            particulars:"Paid First",
                            onTap: (){setState(() {
                              clients=sortClientsModule("Paid First", clients);
                            });
                            Navigator.pop(alertDialogContext);
                            },
                          ),
                          ModalOptionModel(
                            icon:Icons.sort_outlined,
                            particulars:"Registration Id Ascending",
                            onTap: (){setState(() {
                              clients=sortClientsModule("Registration Id Ascending", clients);
                            });
                            Navigator.pop(alertDialogContext);
                            },
                          ),
                          ModalOptionModel(
                            icon:Icons.sort_outlined,
                            particulars:"Registration Id Descending",
                            onTap: (){setState(() {
                              clients=sortClientsModule("Registration Id Descending", clients);
                            });
                            Navigator.pop(alertDialogContext);
                            },
                          ),
                          ModalOptionModel(
                            icon:Icons.sort_by_alpha_outlined,
                            particulars:"A-Z",
                            onTap: (){setState(() {
                              clients=sortClientsModule("A-Z", clients);
                            });
                            Navigator.pop(alertDialogContext);
                            },
                          ),
                          ModalOptionModel(
                            icon:Icons.sort_by_alpha_outlined,
                            particulars:"Z-A",
                            onTap: (){setState(() {
                              clients=sortClientsModule("Z-A", clients);
                            });
                            Navigator.pop(alertDialogContext);
                            },
                          ),
                          ModalOptionModel(
                            icon:Icons.date_range_outlined,
                            particulars:"Start Date Ascending",
                            onTap: (){setState(() {
                              clients=sortClientsModule("Start Date Ascending", clients);
                            });
                            Navigator.pop(alertDialogContext);
                            },
                          ),
                          ModalOptionModel(
                            icon:Icons.date_range_outlined,
                            particulars:"Start Date Descending",
                            onTap: (){setState(() {
                              clients=sortClientsModule("Start Date Descending", clients);
                            });
                            Navigator.pop(alertDialogContext);
                            },
                          ),
                          ModalOptionModel(
                            icon:Icons.date_range_outlined,
                            particulars:"End Date Ascending",
                            onTap: (){setState(() {
                              clients=sortClientsModule("End Date Ascending", clients);
                            });
                            Navigator.pop(alertDialogContext);
                            },
                          ),
                          ModalOptionModel(
                            icon:Icons.date_range_outlined,
                            particulars:"End Date Descending",
                            onTap: (){setState(() {
                              clients=sortClientsModule("End Date Descending", clients);
                            });
                            Navigator.pop(alertDialogContext);
                            },
                          ),
                        ]
                      );
                    }
                );
              }),
                ModalOptionModel(particulars: "Rename",icon:Icons.edit, onTap: () async {
                  Navigator.pop(popupContext);
                  showDialog(context: context, builder: (_)=>new AlertDialog(
                    title: Text("Rename Register"),
                    content: TextField(controller: renameRegisterTextEditingController,
                      textCapitalization: TextCapitalization.words,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: "Name of the Register",
                        contentPadding:
                        EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0),
                      ),
                    ),
                    actions: [ActionChip(label: Text("Rename"), onPressed: (){
                      if(renameRegisterTextEditingController.text!=""){
                        setState(() {
                          widget.register.name=renameRegisterTextEditingController.text.replaceAll(new RegExp(r'[^\s\w]+'),"");
                          renameRegister(widget.register,widget.register.id);
                          renameRegisterTextEditingController.clear();
                          Navigator.of(_).pop();
                          this.appBarTitle = AppBarVariables.appBarLeading(widget.mainScreenContext);

                        });
                        globalShowInSnackBar(scaffoldMessengerKey, "Register Renamed to ${widget.register.name}!!");
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
                }),
                ModalOptionModel(particulars: "Create Invoice",icon:Icons.receipt_long_outlined, onTap: () async {
                  Navigator.pop(popupContext);
                  Navigator.of(widget.mainScreenContext).push(CupertinoPageRoute(builder: (invoiceCreatorPageContext)=>InvoiceCreator()));
                }),
                if(this.clients!=null&&this.clients.length!=0)ModalOptionModel(particulars: "Move to top",icon:Icons.vertical_align_top_outlined, onTap: () async {
                  Navigator.pop(popupContext);
                  scrollController.animateTo(
                    scrollController.position.minScrollExtent,
                    duration: Duration(seconds: 1),
                    curve: Curves.fastOutSlowIn,
                  );
                }),
                if(this.clients!=null&&this.clients.length!=0)ModalOptionModel(particulars: "Info",icon: Icons.info_outline,onTap: (){
                  Navigator.pop(popupContext);
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
                    content: Container(child:  ListView(
                      shrinkWrap: true,
                      physics:BouncingScrollPhysics(),
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
                      ],),
                      width: double.minPositive,),
                    actions: [
                      ActionChip(label: Text("Close"), onPressed: (){
                        Navigator.of(_).pop();
                      }),
                    ],
                  ));
                }),
                ModalOptionModel(particulars: "Upload Client list",icon:Icons.upload_file, onTap: () async {
                  Navigator.pop(popupContext);
                  getFilePath();
                }),
                ModalOptionModel(particulars: "Download Template",icon: Icons.download_sharp,onTap: (){
                  Navigator.pop(popupContext);
                  asset2Local("xlsx", "assets/clientList.xlsx");
                })
              ].map((ModalOptionModel choice){
                return PopupMenuItem<ModalOptionModel>(
                  value: choice,
                  child: ListTile(title: Text(choice.particulars),leading: Icon(choice.icon,color: choice.iconColor),onTap: choice.onTap,),
                );
              }).toList();
            },
          ),
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
              showModalBottomSheet(context: widget.mainScreenContext, builder: (_)=>RegisterOptionBottomSheet(isAddToRegister: true,selectedClients:this.selectedList)).then((value) =>
              {
                refreshIndicatorKey.currentState.show(),
              });
            },
            icon: Icon(Icons.add_box_outlined),
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
    _isLoading = false;
    getClientModels();
    appBarTitle=AppBarVariables.appBarLeading(widget.mainScreenContext);
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(child: Scaffold(
      appBar: getAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        if(!_isSearching)GestureDetector(
            onTap: (){
              showModalBottomSheet(context: widget.mainScreenContext, builder: (_)=>RegisterOptionBottomSheet(isAddToRegister: false));},
          child: Container(
            padding: EdgeInsets.only(left:10,top: 0,bottom: 30),
            child: RichText(
              textAlign: TextAlign.start,
              text: TextSpan(
                children: [
                  WidgetSpan(child: Text(widget.register.name,textScaleFactor:1,style: TextStyle(fontSize: 25),)),
                  WidgetSpan(
                      child: Padding(child: Icon(Icons.arrow_drop_down_sharp,size: 30,),padding: EdgeInsets.only(left: 3),)
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(child: this.clients!=null?this.clients.length==0?NoDataError():Column(children: <Widget>[
          Expanded(child: _isSearching?
          Provider.value(
              value: _counter,
              updateShouldNotify: (oldValue, newValue) => true,
              child: ClientList(listItems:this.searchResult,
                  refreshIndicatorKey: refreshIndicatorKey,
                  refreshData: (){
                    return refreshData();
                  },
                  scrollController:scrollController,
                  scaffoldMessengerKey:scaffoldMessengerKey,
                  onTapList:(index){
                    if(selectedList.length<1)
                      Navigator.of(widget.mainScreenContext).push(CupertinoPageRoute(builder: (context)=>
                          ClientInformationPage(client:this.searchResult[index]))).then((value) {
                        setState(() {if(value==null){}else{
                          this.clients.remove(this.searchResult[index]);
                          this.searchResult.remove(this.searchResult[index]);
                        }});
                      });
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
                  refreshData: (){
                    return refreshData();
                  },
                  refreshIndicatorKey: refreshIndicatorKey,
                  scrollController: scrollController,
                  onTapList:(index){
                    if(selectedList.length<1)
                      Navigator.of(widget.mainScreenContext).push(CupertinoPageRoute(builder: (context)=>
                          ClientInformationPage(client:this.clients[index]))).then((value){
                        setState(() {
                          if(value==null) {}
                          else this.clients.remove(this.clients[index]);
                        });
                      });
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
              )
          )),
        ]):
        LoaderWidget(),)
      ],),
      floatingActionButton:(selectedList.length < 1)?
      RegisterNewClientWidget(this.newClientModel,widget.mainScreenContext):
      FloatingActionButton(
        heroTag: "sendMessageClientPageHeroTag",
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
          actions: [ActionChip(label: Text("Send Sms using Default Sim"), onPressed: (){
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
            ActionChip(label: Text("Send Sms using Sms Gateway"), onPressed: (){
              if(GlobalClass.userDetail.smsAccessToken!=null
                  &&GlobalClass.userDetail.smsApiUrl!=null
                  &&GlobalClass.userDetail.smsUserId!=null
                  &&GlobalClass.userDetail.smsMobileNo!=null
                  &&GlobalClass.userDetail.smsAccessToken!=""
                  &&GlobalClass.userDetail.smsApiUrl!=""
                  &&GlobalClass.userDetail.smsUserId!=""
                  &&GlobalClass.userDetail.smsMobileNo!=""
              ){
                if(textEditingController.text!=""){
                  Navigator.of(_).pop();
                  showDialog(context: context, builder: (_)=>new AlertDialog(
                    title: Text("Confirm Send"),
                    content: Text("Are you sure to send the message to all the selected clients?"),
                    actions: [
                      ActionChip(label: Text("Yes"), onPressed: (){
                        setState(() {
                          try{
                            postForBulkMessage(selectedList,textEditingController.text);
                            globalShowInSnackBar(scaffoldMessengerKey,"Message Sent!!");
                          }
                          catch(E){
                            globalShowInSnackBar(scaffoldMessengerKey,"Something Went Wrong!!");
                          }
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
              }
              else{
                globalShowInSnackBar(scaffoldMessengerKey, "Please configure Sms Gateway Data in Settings.");
                Navigator.of(_).pop();
              }
            }),
            ActionChip(label: Text("Cancel"), onPressed: (){
              Navigator.of(_).pop();
            }),],
        ));
      },
        child: Icon(Icons.message_outlined),
        tooltip: "Send Message",
      ),
    ),key: scaffoldMessengerKey,);
  }
}
