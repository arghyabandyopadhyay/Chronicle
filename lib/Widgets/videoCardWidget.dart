import 'package:chronicle/Models/CourseModels/videoIndexModel.dart';
import 'package:flutter/material.dart';


class VideoCardWidget extends StatefulWidget {
  final Key key;
  final VideoIndexModel item;
  final double size;
  final Function onTapList;
  final Function onLongPressed;
  final int index;
  VideoCardWidget({this.item, this.key,this.size,this.onTapList,this.index,this.onLongPressed});
  @override
  _VideoCardWidgetState createState() => _VideoCardWidgetState();
}

class _VideoCardWidgetState extends State<VideoCardWidget> {
  // var uint8list;
  // getThumbnail()  async{
  //   uint8list = await VideoThumbnail.thumbnailData(
  //     video: this.widget.item.downloadUrl,
  //     imageFormat: ImageFormat.JPEG,
  //     maxWidth: 128,
  //     quality: 10,);
  //   if(mounted)setState(() {});
  // }
  @override
  void initState() {
    super.initState();
    // getThumbnail();
  }
  @override
  Widget build(BuildContext context) {
    return
      GestureDetector(
          onTap: () {
            widget.onTapList(widget.index);
          },
          onLongPress: (){
            widget.onLongPressed(widget.index);
          },
          child: ListTile(
            leading: this.widget.item.thumbnailUrl!=null?Image.network(
              this.widget.item.thumbnailUrl,
            ):null,
            selectedTileColor: Colors.grey.withOpacity(0.1),
            selected: this.widget.item.isSelected,
            title: Text(this.widget.item.name,style: TextStyle(fontWeight: FontWeight.w900),),
            subtitle: Text(this.widget.item.sharedRegisterKeys,style: TextStyle(fontWeight: FontWeight.w900),),)
      );
  }
}