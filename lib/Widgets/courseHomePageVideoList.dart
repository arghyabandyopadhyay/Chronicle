import 'package:chronicle/Models/CourseModels/videoIndexModel.dart';
import 'package:chronicle/Widgets/videoCardWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class CourseHomePageVideoList extends StatelessWidget {
  final List<VideoIndexModel> listItems;
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey;
  final Function onTapList;
  CourseHomePageVideoList({this.listItems,this.scaffoldMessengerKey,this.onTapList});
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.only(bottom: 100),
      itemCount: listItems.length,
      itemBuilder: (context, index) {
        return VideoCardWidget(
          key: ObjectKey(listItems[index].id.key),
          item: listItems[index],
          index: index,
          onTapList: (index){
            onTapList(index);
          },
        );
      },
    );
  }
}