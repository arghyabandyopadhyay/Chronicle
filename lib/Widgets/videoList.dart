import 'package:chronicle/Models/CourseModels/videoIndexModel.dart';
import 'package:chronicle/Modules/database.dart';
import 'package:chronicle/Modules/storage.dart';
import 'package:chronicle/Modules/universalModule.dart';
import 'package:chronicle/Pages/TutorPages/videoInformationPage.dart';
import 'package:chronicle/Widgets/videoCardWidget.dart';
import 'package:chronicle/customColors.dart';
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
  final TextEditingController renameRegisterTextEditingController=new TextEditingController();
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
                        caption: 'Rename',
                        iconWidget: Icon(Icons.edit_outlined,color: CustomColors.editIconColor,),
                        onTap: () {
                          showDialog(context: context, builder: (_)=>new AlertDialog(
                            title: Text("Rename Video"),
                            content: TextField(controller: renameRegisterTextEditingController,
                              textCapitalization: TextCapitalization.words,
                              textInputAction: TextInputAction.done,
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                labelText: "Name of the Video",
                                contentPadding:
                                EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0),
                              ),
                            ),
                            actions: [ActionChip(label: Text("Rename"), onPressed: (){
                              if(renameRegisterTextEditingController.text!=""){
                                setState(() {
                                  displayList[index].name=renameRegisterTextEditingController.text.replaceAll(new RegExp(r'[^\s\w]+'),"");
                                  renameVideo(displayList[index],displayList[index].id);
                                  renameRegisterTextEditingController.clear();
                                  Navigator.of(_).pop();
                                });
                                globalShowInSnackBar(widget.scaffoldMessengerKey, "Video Renamed to ${displayList[index].name}!!");
                              }
                              else{
                                globalShowInSnackBar(widget.scaffoldMessengerKey, "Please enter a valid name for your video!!");
                                Navigator.of(_).pop();
                              }
                            }),
                              ActionChip(label: Text("Cancel"), onPressed: (){
                                Navigator.of(_).pop();
                              }),],
                          ));
                        },
                        closeOnTap: false,
                      ),
                      IconSlideAction(
                        caption: 'Delete',
                        iconWidget: Icon(Icons.delete,color: CustomColors.addDueIconColor,),
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
