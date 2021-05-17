import 'package:chronicle/Models/videoIndexModel.dart';
import 'package:flutter/material.dart';
import 'package:video_thumbnail/video_thumbnail.dart';


class VideoCardWidget extends StatefulWidget {
  final Key key;
  final VideoIndexModel item;
  final double size;
  final Function onTapList;
  final Function onLongPressed;
  final Function onDoubleTap;
  final int index;
  VideoCardWidget({this.item, this.key,this.size,this.onTapList,this.index,this.onLongPressed,this.onDoubleTap});
  @override
  _VideoCardWidgetState createState() => _VideoCardWidgetState();
}

class _VideoCardWidgetState extends State<VideoCardWidget> {
  String name;
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
    name=this.widget.item.name.substring(this.widget.item.name.indexOf("_")+1);
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
          onDoubleTap: (){
            widget.onDoubleTap(widget.index);
          },
          child: ListTile(
            leading: this.widget.item.thumbnailUrl!=null?Image.network(
              this.widget.item.thumbnailUrl,
            ):null,
            selectedTileColor: Colors.grey.withOpacity(0.1),
            selected: this.widget.item.isSelected,
            title: Text(name,style: TextStyle(fontWeight: FontWeight.w900),),
            subtitle: Text(this.widget.item.sharedRegisterKeys,style: TextStyle(fontWeight: FontWeight.w900),),)
      );
  }
}