import 'package:chronicle/Models/modalOptionModel.dart';
import 'package:chronicle/Models/videoIndexModel.dart';
import 'package:chronicle/Modules/apiModule.dart';
import 'package:chronicle/Modules/database.dart';
import 'package:chronicle/Modules/storage.dart';
import 'package:chronicle/Modules/universalModule.dart';
import 'package:chronicle/Pages/TutorPages/videoInformationPage.dart';
import 'package:chronicle/Pages/TutorPages/videoPlayerPage.dart';
import 'package:chronicle/Widgets/videoTile.dart';
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

class VideoList extends StatefulWidget {
  final List<VideoIndexModel> listItems;
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey;
  final Function onLongPressed;
  final Function onTapList;
  final Function onDoubleTapList;
  final Function refreshData;
  final ScrollController scrollController;
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey;
  VideoList({this.listItems,this.scaffoldMessengerKey,this.onTapList,this.onLongPressed,this.onDoubleTapList,this.refreshData,this.scrollController,this.refreshIndicatorKey});
  @override
  _VideoListState createState() => _VideoListState();
}

class _VideoListState extends State<VideoList> {
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
                controller: widget.scrollController,
                physics: AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.only(bottom: 100),
                itemCount: this.widget.listItems.length,
                itemBuilder: (context, index) {
                  return Slidable(
                    actionPane: SlidableDrawerActionPane(),
                    actionExtentRatio: 0.25,
                    child:VideoCardWidget(
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
                      IconSlideAction(
                        caption: 'Information',
                        iconWidget: Icon(Icons.info_outline,color: CustomColors.addPaymentIconColor,),
                        onTap: () {
                          Navigator.of(context).push(CupertinoPageRoute(builder: (videoPlayerContext)=>VideoInformationPage(video: this.widget.listItems[index])));
                        },
                        closeOnTap: false,
                      ),
                      IconSlideAction(
                        caption: 'Delete',
                        iconWidget: Icon(Icons.delete,color: CustomColors.addDueIconColor,),
                        onTap: () async {
                          setState(() {
                            deleteFromStorageModule(this.widget.listItems[index]);
                            this.widget.listItems.remove(this.widget.listItems[index]);
                          });
                        },
                        closeOnTap: false,
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
