import 'package:chronicle/Models/CourseModels/courseIndexModel.dart';
import 'package:flutter/material.dart';


class CourseCardWidget extends StatefulWidget {
  final Key key;
  final CourseIndexModel item;
  final double size;
  final Function onTapList;
  final int index;
  CourseCardWidget({this.item, this.key,this.size,this.onTapList,this.index});
  @override
  _CourseCardWidgetState createState() => _CourseCardWidgetState();
}

class _CourseCardWidgetState extends State<CourseCardWidget> {
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return
      ListTile(
        onTap: () {
          widget.onTapList(widget.index);
        },
        leading: this.widget.item.previewThumbnailUrl!=null?Image.network(
          this.widget.item.previewThumbnailUrl,
        ):null,
        title: Text(this.widget.item.title),
        subtitle: Text(this.widget.item.authorName,),);
  }
}