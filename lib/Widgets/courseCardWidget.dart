import 'package:cached_network_image/cached_network_image.dart';
import 'package:chronicle/Models/CourseModels/courseIndexModel.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';


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
    return GestureDetector(
      onTap: (){
        widget.onTapList(widget.index);
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment:CrossAxisAlignment.start,
          children: [
            Container(alignment:Alignment.center,child: widget.item.previewThumbnailUrl!=null?CachedNetworkImage(
              imageUrl: widget.item.previewThumbnailUrl,
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
            ):null),
            SizedBox(width: 5),
            Expanded(child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment:CrossAxisAlignment.start,
              children: [
                Text(widget.item.title,style: TextStyle(fontWeight: FontWeight.w900),),
                Text(widget.item.description,maxLines: 3,),
                SizedBox(height: 8,),
                Row(children:[Text("A course by "),Text(widget.item.authorName,style: TextStyle(fontWeight: FontWeight.bold),)]),
              ],))
          ],
      ),),
    );


    return ListTile(
      onTap: () {
        widget.onTapList(widget.index);
      },
      // contentPadding: EdgeInsets.symmetric(horizontal: 10),
      // isThreeLine: true,
      // title: this.widget.item.previewThumbnailUrl!=null?AspectRatio(aspectRatio: 16/9,child:Image.network(
      //   this.widget.item.previewThumbnailUrl,
      //   fit: BoxFit.fitWidth,alignment: Alignment.topCenter,
      // ),):null,
      // title: this.widget.item.previewThumbnailUrl!=null?AspectRatio(aspectRatio: 16/9,child:CachedNetworkImage(
      //   imageUrl: widget.item.previewThumbnailUrl,
      //   imageBuilder: (context, imageProvider) => Container(
      //     decoration: BoxDecoration(
      //       color: Colors.white,
      //       image: DecorationImage(
      //         image: imageProvider,
      //         fit: BoxFit.fitWidth,
      //         alignment: Alignment.topCenter,
      //         //colorFilter:ColorFilter.mode(Colors.red, BlendMode.colorBurn)
      //       ),
      //     ),
      //   ),
      //   placeholder: (context, url) => Container(
      //       child: Center(
      //         child: Shimmer.fromColors(
      //           baseColor: Colors.grey[300].withOpacity(0.3),
      //           highlightColor: Colors.white,
      //           enabled: true,
      //           child: Container(
      //             color: Colors.white,
      //           ),
      //         ),
      //       )
      //   ),
      //   errorWidget: (context, url, error) => Icon(Icons.error),
      // )):null,
      // subtitle: Text(" "+this.widget.item.title+"\n "+((this.widget.item.authorName!=null)?this.widget.item.authorName:""),),
      leading:widget.item.previewThumbnailUrl!=null?CachedNetworkImage(
        imageUrl: widget.item.previewThumbnailUrl,
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
      title: Text(widget.item.title,style: TextStyle(fontWeight: FontWeight.w900),),
      subtitle: Text(widget.item.description),
    );
  }
}

// ListTile(
//   onTap: () {
//     widget.onTapList(widget.index);
//   },
//   leading: this.widget.item.previewThumbnailUrl!=null?Image.network(
//     this.widget.item.previewThumbnailUrl,
//   ):null,
//   title: Text(this.widget.item.title),
//   subtitle: Text(this.widget.item.authorName,),);