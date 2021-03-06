import 'package:chronicle/Models/modal_option_model.dart';
import 'package:chronicle/Modules/api_module.dart';
import 'package:chronicle/Modules/error_page.dart';
import 'package:chronicle/Modules/universal_module.dart';
import 'package:chronicle/Widgets/loader_widget.dart';
import 'package:chronicle/Widgets/option_modal_bottom_sheet.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chronicle/Modules/database.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../Models/client_model.dart';
import '../Widgets/client_list.dart';
import 'TutorPages/clientInformationPage.dart';
import '../global_class.dart';

class NotificationsPage extends StatefulWidget {
  static const String routeName = '/notificationPage';
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  List<ClientModel> clients;
  int _counter = 0;
  GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey();
  bool _isSearching = false;
  List<ClientModel> searchResult = [];
  Icon icon = new Icon(
    Icons.search,
  );
  bool _isLoading;
  //Controller
  final TextEditingController _searchController = new TextEditingController();
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  ScrollController scrollController = new ScrollController();
  //Widgets
  Widget appBarTitle = Text(
    "",
    textScaleFactor: 1,
    style: TextStyle(fontSize: 24.0, height: 2.5),
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
      this.appBarTitle = Text(
        "Notifications",
      );
      _isSearching = false;
      _searchController.clear();
    });
  }

  void searchOperation(String searchText) {
    searchResult.clear();
    if (_isSearching) {
      searchResult = clients
          .where((ClientModel element) => (element.masterFilter.toLowerCase())
              .contains(
                  searchText.toLowerCase().replaceAll(new RegExp(r"\s+"), "")))
          .toList();
      setState(() {});
    }
  }

  void getNotifications() {
    getNotificationClients(context).then((clients) => {
          if (mounted)
            this.setState(() {
              this.clients = clients;
              _counter++;
              _isLoading = false;
              this.appBarTitle = Text(
                "Notifications",
              );
            })
        });
  }

  @override
  void initState() {
    super.initState();
    _isLoading = false;
    getNotifications();
    appBarTitle = Text("Notifications");
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<Null> refreshData() async {
    try {
      if (_isSearching) _handleSearchEnd();
      Connectivity connectivity = Connectivity();
      await connectivity.checkConnectivity().then((value) async {
        if (value != ConnectivityResult.none) {
          if (!_isLoading) {
            _isLoading = true;
            return getNotificationClients(context).then((clients) => {
                  if (mounted)
                    this.setState(() {
                      this.clients = clients;
                      _counter++;
                      _isLoading = false;
                      this.appBarTitle = Text(
                        "Notifications",
                      );
                    })
                });
          } else {
            globalShowInSnackBar(
                scaffoldMessengerKey, "Data is being loaded...");
            return null;
          }
        } else {
          setState(() {
            _isLoading = false;
          });
          globalShowInSnackBar(
              scaffoldMessengerKey, "No Internet Connection!!");
          return null;
        }
      });
    } catch (E) {
      setState(() {
        _isLoading = false;
      });
      globalShowInSnackBar(scaffoldMessengerKey, "Something Went Wrong");
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      child: Scaffold(
        appBar: AppBar(
          title: appBarTitle,
          leading: IconButton(
            onPressed: () {
              if (!_isSearching) Navigator.of(context).pop();
            },
            icon: Icon(_isSearching ? Icons.search : Icons.arrow_back),
          ),
          actions: [
            new IconButton(
                icon: icon,
                onPressed: () {
                  setState(() {
                    if (this.icon.icon == Icons.search) {
                      this.icon = new Icon(Icons.close);
                      this.appBarTitle = TextFormField(
                        autofocus: true,
                        controller: _searchController,
                        style: TextStyle(fontSize: 15),
                        decoration: InputDecoration(
                            border: const OutlineInputBorder(
                                borderSide: BorderSide.none),
                            hintText: "Search Notifications",
                            hintStyle: TextStyle(fontSize: 15)),
                        onChanged: searchOperation,
                      );
                      _handleSearchStart();
                    } else
                      _handleSearchEnd();
                  });
                }),
            PopupMenuButton<ModalOptionModel>(
              itemBuilder: (BuildContext popupContext) {
                return [
                  ModalOptionModel(
                      particulars: "Send Reminder",
                      icon: Icons.send,
                      onTap: () async {
                        Navigator.pop(popupContext);
                        showModalBottomSheet(
                            context: context,
                            builder: (_) => OptionModalBottomSheet(
                                  appBarIcon: Icons.send,
                                  appBarText: "How to send the reminder",
                                  list: [
                                    ModalOptionModel(
                                        particulars:
                                            "Send Sms using Default Sim",
                                        icon: Icons.sim_card_outlined,
                                        onTap: () {
                                          Navigator.of(_).pop();
                                          showDialog(
                                              context: context,
                                              builder: (_) => new AlertDialog(
                                                    title: Text("Confirm Send"),
                                                    content: Text(
                                                        "Are you sure to send a reminder to all the clients?"),
                                                    actions: [
                                                      ActionChip(
                                                          label: Text("Yes"),
                                                          onPressed: () {
                                                            List<String>
                                                                addressList =
                                                                [];
                                                            clients.forEach(
                                                                (ClientModel
                                                                    element) {
                                                              String address =
                                                                  element
                                                                      .mobileNo;
                                                              if (address !=
                                                                      null &&
                                                                  address != "")
                                                                addressList.add(
                                                                    address);
                                                            });
                                                            sendSMS(
                                                                message:
                                                                    "${GlobalClass.userDetail.reminderMessage != null && GlobalClass.userDetail.reminderMessage != "" ? GlobalClass.userDetail.reminderMessage : "Your subscription has come to an end"
                                                                        ", please clear your dues for further continuation of services."}\npowered by Chronicle Business Solutions",
                                                                recipients:
                                                                    addressList);
                                                            Navigator.of(_)
                                                                .pop();
                                                          }),
                                                      ActionChip(
                                                          label: Text("No"),
                                                          onPressed: () {
                                                            Navigator.of(_)
                                                                .pop();
                                                          })
                                                    ],
                                                  ));
                                        }),
                                    ModalOptionModel(
                                        particulars:
                                            "Send Sms using Sms Gateway",
                                        icon: FontAwesomeIcons.server,
                                        onTap: () {
                                          if (GlobalClass.userDetail.smsAccessToken != null &&
                                              GlobalClass
                                                      .userDetail.smsApiUrl !=
                                                  null &&
                                              GlobalClass
                                                      .userDetail.smsUserId !=
                                                  null &&
                                              GlobalClass
                                                      .userDetail.smsMobileNo !=
                                                  null &&
                                              GlobalClass
                                                      .userDetail.smsAccessToken !=
                                                  "" &&
                                              GlobalClass
                                                      .userDetail.smsApiUrl !=
                                                  "" &&
                                              GlobalClass
                                                      .userDetail.smsUserId !=
                                                  "" &&
                                              GlobalClass
                                                      .userDetail.smsMobileNo !=
                                                  "") {
                                            Navigator.of(_).pop();
                                            showDialog(
                                                context: context,
                                                builder: (_) => new AlertDialog(
                                                      title:
                                                          Text("Confirm Send"),
                                                      content: Text(
                                                          "Are you sure to send a reminder to all the clients?"),
                                                      actions: [
                                                        ActionChip(
                                                            label: Text("Yes"),
                                                            onPressed: () {
                                                              try {
                                                                postForBulkMessage(
                                                                    clients,
                                                                    "${GlobalClass.userDetail.reminderMessage != null && GlobalClass.userDetail.reminderMessage != "" ? GlobalClass.userDetail.reminderMessage : "Your subscription has come to an end"
                                                                        ", please clear your dues for further continuation of services."}\npowered by Chronicle Business Solutions");
                                                                globalShowInSnackBar(
                                                                    scaffoldMessengerKey,
                                                                    "Message Sent!!");
                                                              } catch (E) {
                                                                globalShowInSnackBar(
                                                                    scaffoldMessengerKey,
                                                                    "Something Went Wrong!!");
                                                              }
                                                              Navigator.of(_)
                                                                  .pop();
                                                            }),
                                                        ActionChip(
                                                            label: Text("No"),
                                                            onPressed: () {
                                                              Navigator.of(_)
                                                                  .pop();
                                                            })
                                                      ],
                                                    ));
                                          } else {
                                            globalShowInSnackBar(
                                                scaffoldMessengerKey,
                                                "Please configure Sms Gateway Data in Settings.");
                                            Navigator.of(_).pop();
                                          }
                                        }),
                                  ],
                                ));
                      }),
                  ModalOptionModel(
                      particulars: "Sort",
                      icon: Icons.sort,
                      onTap: () {
                        Navigator.pop(popupContext);
                        showModalBottomSheet(
                            context: context,
                            builder: (BuildContext alertDialogContext) {
                              return OptionModalBottomSheet(
                                  appBarText: "Sort Options",
                                  appBarIcon: Icons.sort,
                                  list: [
                                    ModalOptionModel(
                                      icon: Icons.more_time,
                                      particulars: "Dues First",
                                      onTap: () {
                                        setState(() {
                                          clients = sortClientsModule(
                                              "Dues First", clients);
                                        });
                                        Navigator.pop(alertDialogContext);
                                      },
                                    ),
                                    ModalOptionModel(
                                      icon: Icons.hourglass_bottom_outlined,
                                      particulars: "Last Months First",
                                      onTap: () {
                                        setState(() {
                                          clients = sortClientsModule(
                                              "Last Months First", clients);
                                        });
                                        Navigator.pop(alertDialogContext);
                                      },
                                    ),
                                    ModalOptionModel(
                                      icon: Icons.payment_outlined,
                                      particulars: "Paid First",
                                      onTap: () {
                                        setState(() {
                                          clients = sortClientsModule(
                                              "Paid First", clients);
                                        });
                                        Navigator.pop(alertDialogContext);
                                      },
                                    ),
                                    ModalOptionModel(
                                      icon: Icons.sort_by_alpha_outlined,
                                      particulars: "A-Z",
                                      onTap: () {
                                        setState(() {
                                          clients =
                                              sortClientsModule("A-Z", clients);
                                        });
                                        Navigator.pop(alertDialogContext);
                                      },
                                    ),
                                    ModalOptionModel(
                                      icon: Icons.sort_by_alpha_outlined,
                                      particulars: "Z-A",
                                      onTap: () {
                                        setState(() {
                                          clients =
                                              sortClientsModule("Z-A", clients);
                                        });
                                        Navigator.pop(alertDialogContext);
                                      },
                                    ),
                                    ModalOptionModel(
                                      icon: Icons.date_range_outlined,
                                      particulars: "Start Date Ascending",
                                      onTap: () {
                                        setState(() {
                                          clients = sortClientsModule(
                                              "Start Date Ascending", clients);
                                        });
                                        Navigator.pop(alertDialogContext);
                                      },
                                    ),
                                    ModalOptionModel(
                                      icon: Icons.date_range_outlined,
                                      particulars: "Start Date Descending",
                                      onTap: () {
                                        setState(() {
                                          clients = sortClientsModule(
                                              "Start Date Descending", clients);
                                        });
                                        Navigator.pop(alertDialogContext);
                                      },
                                    ),
                                    ModalOptionModel(
                                      icon: Icons.date_range_outlined,
                                      particulars: "End Date Ascending",
                                      onTap: () {
                                        setState(() {
                                          clients = sortClientsModule(
                                              "End Date Ascending", clients);
                                        });
                                        Navigator.pop(alertDialogContext);
                                      },
                                    ),
                                    ModalOptionModel(
                                      icon: Icons.date_range_outlined,
                                      particulars: "End Date Descending",
                                      onTap: () {
                                        setState(() {
                                          clients = sortClientsModule(
                                              "End Date Descending", clients);
                                        });
                                        Navigator.pop(alertDialogContext);
                                      },
                                    ),
                                  ]);
                            });
                      }),
                  if (this.clients != null && this.clients.length != 0)
                    ModalOptionModel(
                        particulars: "Move to top",
                        icon: Icons.vertical_align_top_outlined,
                        onTap: () async {
                          Navigator.pop(popupContext);
                          scrollController.animateTo(
                            scrollController.position.minScrollExtent,
                            duration: Duration(seconds: 1),
                            curve: Curves.fastOutSlowIn,
                          );
                        }),
                  if (this.clients != null && this.clients.length != 0)
                    ModalOptionModel(
                        particulars: "Info",
                        icon: Icons.info_outline,
                        onTap: () {
                          Navigator.pop(popupContext);
                          int totalDues = 0;
                          int totalPaid = 0;
                          int totalLastMonths = 0;
                          int totalPaidClients = 0;
                          int totalDuedClients = 0;
                          clients.forEach((element) {
                            if (element.due > 0) {
                              totalDues = totalDues + element.due;
                              totalDuedClients = totalDuedClients + 1;
                            } else if (element.due < 0) {
                              totalPaid = totalPaid + element.due.abs() + 1;
                              totalPaidClients = totalPaidClients + 1;
                            } else
                              totalLastMonths++;
                          });
                          showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                    title: Text("${"Notifications"}"),
                                    content: Container(
                                      child: ListView(
                                        shrinkWrap: true,
                                        physics: BouncingScrollPhysics(),
                                        children: [
                                          Container(
                                            height: 50,
                                            padding: EdgeInsets.all(10),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "Total Dues:",
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontSize: 17.0,
                                                  ),
                                                ),
                                                Expanded(
                                                    child: Text(
                                                  totalDues.toString(),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontSize: 17.0,
                                                  ),
                                                  textAlign: TextAlign.end,
                                                ))
                                              ],
                                            ),
                                          ),
                                          Container(
                                            height: 50,
                                            padding: EdgeInsets.all(10),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "Total Paid:",
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontSize: 17.0,
                                                  ),
                                                ),
                                                Expanded(
                                                    child: Text(
                                                  totalPaid.toString(),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontSize: 17.0,
                                                  ),
                                                  textAlign: TextAlign.end,
                                                ))
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Center(
                                            child:
                                                Text("*The data is in Months."),
                                          ),
                                          Container(
                                            height: 50,
                                            padding: EdgeInsets.all(10),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "Due Clients:",
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontSize: 17.0,
                                                  ),
                                                ),
                                                Expanded(
                                                    child: Text(
                                                  totalDuedClients.toString(),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontSize: 17.0,
                                                  ),
                                                  textAlign: TextAlign.end,
                                                ))
                                              ],
                                            ),
                                          ),
                                          Container(
                                            height: 50,
                                            padding: EdgeInsets.all(10),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "Paid Clients:",
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontSize: 17.0,
                                                  ),
                                                ),
                                                Expanded(
                                                    child: Text(
                                                  totalPaidClients.toString(),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontSize: 17.0,
                                                  ),
                                                  textAlign: TextAlign.end,
                                                ))
                                              ],
                                            ),
                                          ),
                                          Container(
                                            height: 50,
                                            padding: EdgeInsets.all(10),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "Last Months:",
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontSize: 17.0,
                                                  ),
                                                ),
                                                Expanded(
                                                    child: Text(
                                                  totalLastMonths.toString(),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontSize: 17.0,
                                                  ),
                                                  textAlign: TextAlign.end,
                                                ))
                                              ],
                                            ),
                                          ),
                                          Container(
                                            height: 50,
                                            padding: EdgeInsets.all(10),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "Total Clients:",
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontSize: 17.0,
                                                  ),
                                                ),
                                                Expanded(
                                                    child: Text(
                                                  (totalLastMonths +
                                                          totalDuedClients +
                                                          totalPaidClients)
                                                      .toString(),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontSize: 17.0,
                                                  ),
                                                  textAlign: TextAlign.end,
                                                ))
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Center(
                                            child: Text(
                                                "*The data is in no of clients."),
                                          ),
                                        ],
                                      ),
                                      width: double.minPositive,
                                    ),
                                    actions: [
                                      ActionChip(
                                          label: Text("Close"),
                                          onPressed: () {
                                            Navigator.of(_).pop();
                                          }),
                                    ],
                                  ));
                        }),
                ].map((ModalOptionModel choice) {
                  return PopupMenuItem<ModalOptionModel>(
                    value: choice,
                    child: ListTile(
                      title: Text(choice.particulars),
                      leading: Icon(choice.icon, color: choice.iconColor),
                      onTap: choice.onTap,
                    ),
                  );
                }).toList();
              },
            ),
          ],
        ),
        body: this.clients != null
            ? this.clients.length == 0
                ? NoDataError()
                : Column(children: <Widget>[
                    Expanded(
                        child: _isSearching
                            ? Provider.value(
                                value: _counter,
                                updateShouldNotify: (oldValue, newValue) =>
                                    true,
                                child: ClientList(
                                    listItems: this.searchResult,
                                    refreshData: () {
                                      return refreshData();
                                    },
                                    refreshIndicatorKey: refreshIndicatorKey,
                                    scrollController: scrollController,
                                    scaffoldMessengerKey: scaffoldMessengerKey,
                                    onTapList: (index) {
                                      Navigator.of(context)
                                          .push(CupertinoPageRoute(
                                              builder: (context) =>
                                                  ClientInformationPage(
                                                      client: this.searchResult[
                                                          index])))
                                          .then((value) {
                                        setState(() {
                                          if (value == null) {
                                          } else {
                                            this.clients.remove(
                                                this.searchResult[index]);
                                            this.searchResult.remove(
                                                this.searchResult[index]);
                                          }
                                        });
                                      });
                                    },
                                    onLongPressed: (index) {},
                                    onDoubleTapList: (index) {
                                      showDialog(
                                          context: context,
                                          builder: (_) => new AlertDialog(
                                                title: Text("Confirm Delete"),
                                                content: Text(
                                                    "Are you sure to delete ${searchResult[index].name}?"),
                                                actions: [
                                                  ActionChip(
                                                      label: Text("Yes"),
                                                      onPressed: () {
                                                        setState(() {
                                                          deleteDatabaseNode(
                                                              searchResult[
                                                                      index]
                                                                  .id);
                                                          searchResult
                                                              .removeAt(index);
                                                          Navigator.of(_).pop();
                                                        });
                                                      }),
                                                  ActionChip(
                                                      label: Text("No"),
                                                      onPressed: () {
                                                        setState(() {
                                                          Navigator.of(_).pop();
                                                        });
                                                      })
                                                ],
                                              ));
                                    }))
                            : Provider.value(
                                value: _counter,
                                updateShouldNotify: (oldValue, newValue) =>
                                    true,
                                child: ClientList(
                                    listItems: this.clients,
                                    scaffoldMessengerKey: scaffoldMessengerKey,
                                    onTapList: (index) {
                                      Navigator.of(context)
                                          .push(CupertinoPageRoute(
                                              builder: (context) =>
                                                  ClientInformationPage(
                                                      client:
                                                          this.clients[index])))
                                          .then((value) {
                                        setState(() {
                                          if (value == null) {
                                          } else
                                            this
                                                .clients
                                                .remove(this.clients[index]);
                                        });
                                      });
                                    },
                                    scrollController: scrollController,
                                    refreshData: () {
                                      return refreshData();
                                    },
                                    refreshIndicatorKey: refreshIndicatorKey,
                                    onLongPressed: (index) {},
                                    onDoubleTapList: (index) {
                                      showDialog(
                                          context: context,
                                          builder: (_) => new AlertDialog(
                                                title: Text("Confirm Delete"),
                                                content: Text(
                                                    "Are you sure to delete ${clients[index].name}?"),
                                                actions: [
                                                  ActionChip(
                                                      label: Text("Yes"),
                                                      onPressed: () {
                                                        setState(() {
                                                          deleteDatabaseNode(
                                                              clients[index]
                                                                  .id);
                                                          clients
                                                              .removeAt(index);
                                                          Navigator.of(_).pop();
                                                        });
                                                      }),
                                                  ActionChip(
                                                      label: Text("No"),
                                                      onPressed: () {
                                                        setState(() {
                                                          Navigator.of(_).pop();
                                                        });
                                                      })
                                                ],
                                              ));
                                    }))),
                  ])
            : LoaderWidget(),
        // floatingActionButton: FloatingActionButton(child: Icon(Icons.clear_all),onPressed: (){
        //   //clearAllAnimation
        // },),
      ),
      key: scaffoldMessengerKey,
    );
  }
}
