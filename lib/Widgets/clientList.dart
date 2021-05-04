import 'package:chronicle/Modules/universalModule.dart';
import 'package:chronicle/Widgets/clientCardWidget.dart';
import 'package:chronicle/customColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../Models/clientModel.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';

class ClientList extends StatefulWidget {
  final List<ClientModel> listItems;
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey;
  final Function onLongPressed;
  final Function onTapList;
  final Function onDoubleTapList;
  ClientList({this.listItems,this.scaffoldMessengerKey,this.onTapList,this.onLongPressed,this.onDoubleTapList});
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
          child: ListView.builder(
            physics: BouncingScrollPhysics(),
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
                    icon: Icons.more_time,
                    color: Colors.red,
                    onTap: () async {
                      addDueModule(this.widget.listItems[index],this);
                    },
                    closeOnTap: false,
                  ),
                  IconSlideAction(
                    caption: 'Add Payment',
                    icon: Icons.payment,
                    color: Colors.green,
                    onTap: () {
                      addPaymentModule(this.widget.listItems[index],context,widget.scaffoldMessengerKey,this);
                    },
                    closeOnTap: false,
                  ),
                ],
                actions: <Widget>[
                  IconSlideAction(
                    caption: 'Call',
                    icon: Icons.call,
                    onTap: () async {
                      callModule(this.widget.listItems[index]);
                    },
                  ),
                  IconSlideAction(
                    caption: 'SMS',
                    icon: Icons.message,
                    onTap: () async {
                      smsModule(this.widget.listItems[index],widget.scaffoldMessengerKey);
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
          )),
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
