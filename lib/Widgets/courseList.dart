import 'package:chronicle/Models/CourseModels/courseIndexModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'courseCardWidget.dart';

class CourseList extends StatefulWidget {
  final List<CourseIndexModel> listItems;
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey;
  final Function onTapList;
  final Function refreshData;
  final ScrollController scrollController;
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey;
  CourseList({this.listItems,this.scaffoldMessengerKey,this.onTapList,this.refreshData,this.scrollController,this.refreshIndicatorKey});
  @override
  _CourseListState createState() => _CourseListState();
}

class _CourseListState extends State<CourseList> {
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
                padding: EdgeInsets.only(bottom: 100,left: 10,right: 10),
                itemCount: displayList.length,
                itemBuilder: (context, index) {
                  return CourseCardWidget(
                    key: displayList[index].id!=null?ObjectKey(displayList[index].id.key):UniqueKey(),
                    item: displayList[index],
                    index: index,
                    onTapList: (index){
                      widget.onTapList(index);
                    },
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
