import 'package:chronicle/Models/CourseModels/videoIndexModel.dart';
import 'package:chronicle/Modules/database.dart';
import 'package:chronicle/Modules/storage.dart';
import 'package:chronicle/Modules/universalModule.dart';
import 'package:chronicle/Pages/TutorPages/CoursesByMePages/editVideoPage.dart';
import 'package:chronicle/Widgets/videoCardWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';


class VideoList extends StatefulWidget {
  final List<VideoIndexModel> listItems;
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey;
  final Function onLongPressed;
  final Function onTapList;
  final Function refreshData;
  final ScrollController scrollController;
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey;
  VideoList({this.listItems,this.scaffoldMessengerKey,this.onTapList,this.onLongPressed,this.refreshData,this.scrollController,this.refreshIndicatorKey});
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

  updateVideoDetails(VideoIndexModel videoIndexModel,int index)
  {
    setState(() {
      renameVideo(videoIndexModel,videoIndexModel.id);
      displayList[index]=videoIndexModel;
    });
    globalShowInSnackBar(widget.scaffoldMessengerKey, "Video Renamed to ${videoIndexModel.name}!!");
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
                itemCount: displayList.length,
                itemBuilder: (context, index) {
                  return Slidable(
                    actionPane: SlidableDrawerActionPane(),
                    actionExtentRatio: 0.25,
                    child:VideoCardWidget(
                      key: ObjectKey(displayList[index].id.key),
                      item: displayList[index],
                      index: index,
                      onTapList: (index){
                        widget.onTapList(index);
                      },
                      onLongPressed: (index){
                        widget.onLongPressed(index);
                      },
                    ),
                    secondaryActions: <Widget>[
                      IconSlideAction(
                        caption: 'Edit',
                        iconWidget: Icon(Icons.edit_outlined),
                        onTap: () {
                          Navigator.of(context).push(CupertinoPageRoute(
                              builder: (editPageContext)=>
                                  EditVideoPage(callback:this.updateVideoDetails,videoIndex: displayList[index],index:index)));
                        },
                        closeOnTap: false,
                      ),
                      IconSlideAction(
                        caption: 'Delete',
                        iconWidget: Icon(Icons.delete),
                        onTap: () async {
                          setState(() {
                            deleteFromStorageModule(displayList[index],widget.scaffoldMessengerKey);
                            displayList.remove(displayList[index]);
                            widget.listItems.remove(displayList[index]);
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
