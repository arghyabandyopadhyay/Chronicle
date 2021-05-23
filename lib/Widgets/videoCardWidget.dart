import 'package:cached_network_image/cached_network_image.dart';
import 'package:chronicle/Models/CourseModels/videoIndexModel.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';


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
            contentPadding: EdgeInsets.symmetric(horizontal: 10),
            isThreeLine: true,
            title: this.widget.item.thumbnailUrl!=null?AspectRatio(aspectRatio: 16/9,child:CachedNetworkImage(
              imageUrl: widget.item.thumbnailUrl,
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.fitWidth,
                    alignment: Alignment.topCenter,
                    //colorFilter:ColorFilter.mode(Colors.red, BlendMode.colorBurn)
                  ),
                ),
              ),
              placeholder: (context, url) => Container(
                  child: Center(
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey[300].withOpacity(0.3),
                      highlightColor: Colors.white,
                      enabled: true,
                      child: Container(
                        color: Colors.white,
                      ),
                    ),
                  )
              ),
              errorWidget: (context, url, error) => Icon(Icons.error),
            )):null,
            selectedTileColor: Colors.grey.withOpacity(0.2),
            selected: this.widget.item.isSelected,
            leading: this.widget.item.isSelected?Icon(Icons.verified):null,
            subtitle: Text(" "+this.widget.item.name+"\n "+((this.widget.item.description!=null)?this.widget.item.description:""),),)
      );
  }
}
//Card(
//             color: this.widget.item.isSelected?Colors.grey.withOpacity(0.1):Colors.transparent,
//             elevation: 5,
//             child:
//             Container(
//               decoration:BoxDecoration(
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               clipBehavior: Clip.antiAlias,
//               child: Stack(
//                 children: [
//                   this.widget.item.thumbnailUrl!=null?AspectRatio(aspectRatio: 16/9,child:Image.network(
//                     this.widget.item.thumbnailUrl,
//                     filterQuality: FilterQuality.medium,
//                     fit: BoxFit.cover,alignment: Alignment.topCenter,
//                   ),):null,
//                   AspectRatio(aspectRatio: 16/9,child: Align(alignment: Alignment.bottomLeft,child: Text("  "+this.widget.item.name,textAlign:TextAlign.center,style: TextStyle(fontWeight: FontWeight.w900),),),)
//                 ],
//               ),
//
//           ),)