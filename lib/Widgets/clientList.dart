import 'package:chronicle/Models/modalOptionModel.dart';
import 'package:chronicle/Modules/apiModule.dart';
import 'package:chronicle/Modules/universalModule.dart';
import 'package:chronicle/globalClass.dart';
import 'package:chronicle/Widgets/clientCardWidget.dart';
import 'package:chronicle/customColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../Models/clientModel.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';

import 'optionModalBottomSheet.dart';

class ClientList extends StatefulWidget {
  final List<ClientModel> listItems;
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey;
  final Function onLongPressed;
  final Function onTapList;
  final Function onDoubleTapList;
  final Function refreshData;
  final ScrollController scrollController;
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey;
  ClientList({this.listItems,this.scaffoldMessengerKey,this.onTapList,this.onLongPressed,this.onDoubleTapList,this.refreshData,this.scrollController,this.refreshIndicatorKey});
  @override
  _ClientListState createState() => _ClientListState();
}

class _ClientListState extends State<ClientList> {
  final TextEditingController alertTextController=new TextEditingController();
  bool isLoading;
  @override
  void initState()
  {
    super.initState();
    isLoading = false;
    _loadMore();
  }
  List displayList=[];
  int currentLength = 0;
  final int increment = 100;
  Future _loadMore() async {
    setState(() {
      isLoading = true;
    });
    int end=currentLength+increment;
    displayList.addAll(widget.listItems.getRange(currentLength, end>=widget.listItems.length?widget.listItems.length:end));
    setState(() {
      isLoading = false;
      currentLength = displayList.length;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LazyLoadScrollView(
          isLoading: isLoading,
          scrollOffset: 500,
          onEndOfPage: () => _loadMore(),
          child: RefreshIndicator(
            triggerMode: RefreshIndicatorTriggerMode.anywhere,
              displacement: 10,
              key: widget.refreshIndicatorKey,
              onRefresh: widget.refreshData,
              child:ListView.builder(
                physics: AlwaysScrollableScrollPhysics(),
                controller: widget.scrollController,
                padding: EdgeInsets.only(bottom: 100),
                itemCount: this.widget.listItems.length,
                itemBuilder: (context, index) {
                  return Slidable(
                    actionPane: SlidableDrawerActionPane(),
                    actionExtentRatio: 0.25,
                    child:ClientCardWidget(
                      key: ObjectKey(this.widget.listItems[index].id.key),
                      item: this.widget.listItems[index],
                      index: index,
                      onTapList: (index){
                        widget.onTapList(index);
                      },
                      onLongPressed: (index){
                        widget.onLongPressed(index);
                      },
                      onDoubleTap: (index){
                        widget.onDoubleTapList(index);
                      },
                    ),
                    secondaryActions: <Widget>[
                      if(this.widget.listItems[index].due>-1)IconSlideAction(
                        caption: 'Add Due',
                        iconWidget: Icon(Icons.more_time,color: CustomColors.addDueIconColor,),
                        onTap: () async {
                          addDueModule(this.widget.listItems[index],this);
                        },
                        closeOnTap: false,
                      ),
                      IconSlideAction(
                        caption: 'Add Payment',
                        iconWidget: Icon(Icons.payment,color: CustomColors.addPaymentIconColor,),
                        onTap: () {
                          addPaymentModule(this.widget.listItems[index],context,widget.scaffoldMessengerKey,this);
                        },
                        closeOnTap: false,
                      ),
                    ],
                    actions: <Widget>[
                      IconSlideAction(
                        caption: 'Call',
                        iconWidget: Icon(Icons.call,color: CustomColors.callIconColor,),
                        onTap: () async {
                          callModule(this.widget.listItems[index],widget.scaffoldMessengerKey);
                        },
                      ),
                      IconSlideAction(
                        caption: 'SMS',
                        iconWidget: Icon(Icons.send,color: CustomColors.sendIconColor,),
                        onTap: () {
                          showModalBottomSheet(context: context, builder: (_)=>
                              OptionModalBottomSheet(
                                appBarIcon: Icons.send,
                                appBarText: "How to send the reminder",
                                list: [
                                  ModalOptionModel(
                                      particulars: "Send Sms using Default Sim",
                                      icon: Icons.sim_card_outlined,iconColor:CustomColors.simCardIconColor,
                                      onTap: (){
                                        Navigator.of(_).pop();
                                        showDialog(context: context, builder: (_)=>new AlertDialog(
                                          title: Text("Confirm Send"),
                                          content: Text("Are you sure to send a reminder to ${widget.listItems[index].name}?"),
                                          actions: [
                                            ActionChip(label: Text("Yes"), onPressed: (){
                                              smsModule(this.widget.listItems[index],widget.scaffoldMessengerKey);
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
                                      icon: FontAwesomeIcons.server,iconColor:CustomColors.serverIconColor,
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
                                            content: Text("Are you sure to send a reminder to ${widget.listItems[index].name}?"),
                                            actions: [
                                              ActionChip(label: Text("Yes"), onPressed: (){
                                                try{
                                                  postForBulkMessage([widget.listItems[index]],"${GlobalClass.userDetail.reminderMessage!=null&&GlobalClass.userDetail.reminderMessage!=""?GlobalClass.userDetail.reminderMessage:"Your subscription has come to an end"
                                                      ", please clear your dues for further continuation of services."}");
                                                  globalShowInSnackBar(widget.scaffoldMessengerKey,"Message Sent!!");
                                                }
                                                catch(E){
                                                  globalShowInSnackBar(widget.scaffoldMessengerKey,"Something Went Wrong!!");
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
                                          globalShowInSnackBar(widget.scaffoldMessengerKey, "Please configure Sms Gateway Data in Settings.");
                                          Navigator.of(_).pop();
                                        }
                                      }),],));
                        },
                      ),
                      IconSlideAction(
                        caption: 'WhatsApp',
                        iconWidget: Icon(FontAwesomeIcons.whatsappSquare,color:CustomColors.whatsAppGreen),
                        onTap: () async {
                          whatsAppModule(this.widget.listItems[index], widget.scaffoldMessengerKey);
                        },
                      ),
                    ],
                  );
                },
              )
          )
          ),
    );
  }
  @override
  void didChangeDependencies() {
    Provider.of<int>(context);
    displayList.clear();
    currentLength = 0;
    _loadMore();
    super.didChangeDependencies();
  }
}
