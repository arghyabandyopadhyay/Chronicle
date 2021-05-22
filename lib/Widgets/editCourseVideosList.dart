//EditCourseVideosList
import 'package:chronicle/Models/CourseModels/videoIndexModel.dart';
import 'package:chronicle/customColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class EditCourseVideosList extends StatefulWidget {
  final List<VideoIndexModel> listItems;
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey;
  final Function onTapList;
  final Function onButtonTapped;
  EditCourseVideosList({Key key,this.listItems,this.scaffoldMessengerKey,this.onTapList,this.onButtonTapped});
  @override
  _EditCourseVideosListState createState() => _EditCourseVideosListState();

}
class _EditCourseVideosListState extends State<EditCourseVideosList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: AlwaysScrollableScrollPhysics(),
      itemCount: widget.listItems.length,
      itemBuilder: (context, index) {
        return ListTile(
          onTap: (){
            widget.onTapList(index);
          },
          leading: widget.listItems[index].thumbnailUrl!=null?Image.network(
            widget.listItems[index].thumbnailUrl,
          ):null,
          title: Text(widget.listItems[index].name,style: TextStyle(fontWeight: FontWeight.w900),),
          trailing: IconButton(icon: Icon(Icons.delete_forever_outlined,color: CustomColors.addDueIconColor,),onPressed: (){
            widget.onButtonTapped(index);
          },),
        );
      },
    );
  }
}
