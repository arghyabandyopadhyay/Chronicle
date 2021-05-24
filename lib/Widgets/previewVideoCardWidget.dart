import 'package:cached_network_image/cached_network_image.dart';
import 'package:chronicle/Models/CourseModels/videoIndexModel.dart';
import 'package:chronicle/customColors.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';


class PreviewVideoCardWidget extends StatefulWidget {
  final Key key;
  final VideoIndexModel item;
  final double size;
  final Function onTapList;
  final int index;
  PreviewVideoCardWidget({this.item, this.key,this.size,this.onTapList,this.index});
  @override
  _PreviewVideoCardWidgetState createState() => _PreviewVideoCardWidgetState();
}

class _PreviewVideoCardWidgetState extends State<PreviewVideoCardWidget> {
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
          child: AspectRatio(
            aspectRatio: 16/9,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(child: this.widget.item.thumbnailUrl!=null?CachedNetworkImage(
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
                ):null,),
                Align(alignment: Alignment.center,child: Icon(Icons.play_circle_fill_outlined,size: 50),),
              ],
            ),
          )
      );
  }
}