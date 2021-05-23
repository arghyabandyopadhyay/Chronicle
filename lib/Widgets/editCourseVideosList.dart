import 'package:cached_network_image/cached_network_image.dart';
import 'package:chronicle/Models/CourseModels/videoIndexModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';


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
          // leading: widget.listItems[index].thumbnailUrl!=null?Image.network(
          //   widget.listItems[index].thumbnailUrl,
          // ):null,
          leading:widget.listItems[index].thumbnailUrl!=null?CachedNetworkImage(
            imageUrl: widget.listItems[index].thumbnailUrl,
            height: 100,
              width: 100,
            imageBuilder: (context, imageProvider) => Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.fitWidth,
                  //colorFilter:ColorFilter.mode(Colors.red, BlendMode.colorBurn)
                ),
              ),
            ),
            placeholder: (context, url) => Container(
                height: 100,
                width: 100,
                child: Center(
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey[300].withOpacity(0.3),
                    highlightColor: Colors.white,
                    enabled: true,
                    child: Container(
                      width:100,
                      height: 100,
                      color: Colors.white,
                    ),
                  ),
                )
            ),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ):null,
          title: Text(widget.listItems[index].name,style: TextStyle(fontWeight: FontWeight.w900),),
          trailing: IconButton(icon: Icon(Icons.delete_forever_outlined),onPressed: (){
            widget.onButtonTapped(index);
          },),
        );
      },
    );
  }
}
