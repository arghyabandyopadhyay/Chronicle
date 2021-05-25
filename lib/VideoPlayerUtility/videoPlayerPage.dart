// import 'package:chronicle/Models/CourseModels/videoIndexModel.dart';
// import 'package:chronicle/Widgets/Simmers/loaderWidget.dart';
// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';
//
// import '../customColors.dart';
//
// class VideoPlayerPage extends StatefulWidget {
//   final VideoIndexModel video;
//   const VideoPlayerPage({@required this.video});
//
//   @override
//   _VideoPlayerPageState createState() => _VideoPlayerPageState();
// }
//
// class _VideoPlayerPageState extends State<VideoPlayerPage> {
//   VideoPlayerController _controller;
//   String appBarText='Video';
//   bool isRotated=false;
//   static const _examplePlaybackRates = [
//     0.25,
//     0.5,
//     1.0,
//     1.5,
//     2.0,
//   ];
//   @override
//   void initState() {
//     super.initState();
//     _controller = VideoPlayerController.network(widget.video.downloadUrl)
//       ..initialize().then((_) {
//         setState(() {});
//       });
//     _controller.play();
//     appBarText=this.widget.video.name.substring(this.widget.video.name.indexOf("_")+1);
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   Widget buildFullScreen({Widget child}) {
//     final size=_controller.value.size;
//     final width=size.width;
//     final height=size.height;
//     return FittedBox(child:SizedBox(height: height,width: width,child:  child),fit: BoxFit.contain,);
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: isRotated||MediaQuery.of(context).orientation==Orientation.landscape?null:AppBar(
//         title: Text(appBarText),
//       ),
//       body: RotatedBox(
//           quarterTurns: isRotated&&MediaQuery.of(context).orientation==Orientation.portrait?3:0,
//           child: _controller.value.isInitialized
//               ? Container(
//             color: Colors.black,
//             child: Stack(
//               fit: StackFit.expand,
//               alignment: Alignment.bottomCenter,
//               children: [
//                 buildFullScreen(child:AspectRatio(
//                   aspectRatio: _controller.value.aspectRatio,
//                   child: VideoPlayer(_controller),
//                 )),
//                 Stack(
//                   children: <Widget>[
//                     AnimatedSwitcher(
//                       duration: Duration(milliseconds: 50),
//                       reverseDuration: Duration(milliseconds: 200),
//                       child: _controller.value.isPlaying
//                           ? SizedBox.shrink()
//                           : Container(
//                         color: Colors.black26,
//                         child: Center(
//                           child: Icon(
//                             Icons.play_arrow,
//                             color: CustomColors.playbackSpeedTextColor,
//                             size: 100.0,
//                           ),
//                         ),
//                       ),
//                     ),
//                     GestureDetector(
//                       onTap: () {
//                         setState(() {
//                           if(_controller.value.position>=_controller.value.duration) {
//                                   _controller.seekTo(Duration.zero);
//                                   _controller.pause();
//                                 }
//                           else _controller.value.isPlaying ? _controller.pause() : _controller.play();
//                         });
//                       },
//                     ),
//                     Align(
//                       alignment: Alignment.topRight,
//                       child: PopupMenuButton<double>(
//                         initialValue: _controller.value.playbackSpeed,
//                         tooltip: 'Playback speed',
//                         onSelected: (speed) {
//                           setState(() {
//                             _controller.setPlaybackSpeed(speed);
//                           });
//                         },
//                         itemBuilder: (context) {
//                           return [
//                             for (final speed in _examplePlaybackRates)
//                               PopupMenuItem(
//                                 value: speed,
//                                 child: Text('${speed}x'),
//                               )
//                           ];
//                         },
//                         child: Padding(
//                           padding: const EdgeInsets.symmetric(
//                             // Using less vertical padding as the text is also longer
//                             // horizontally, so it feels like it would need more spacing
//                             // horizontally (matching the aspect ratio of the video).
//                             vertical: 12,
//                             horizontal: 16,
//                           ),
//                           child: Text('${_controller.value.playbackSpeed}x',style: TextStyle(color: CustomColors.playbackSpeedTextColor),),
//                         ),
//                       ),
//                     ),
//                     Align(
//                         alignment: Alignment.bottomRight,
//                         child: isRotated||MediaQuery.of(context).orientation==Orientation.landscape?IconButton(icon: Icon(Icons.fullscreen_exit_outlined,color: Colors.white,),onPressed: (){
//                           setState(() {
//                             isRotated=false;
//                           });
//                         },):IconButton(icon: Icon(Icons.fullscreen_outlined,color: Colors.white,),onPressed: (){
//                           setState(() {
//                             isRotated=true;
//                           });
//                         },)
//                     ),
//                     Align(alignment: Alignment.bottomCenter,child: VideoProgressIndicator(_controller, allowScrubbing: true),)
//                   ],
//                 ),
//               ],),): LoaderWidget()
//       ),
//     );
//   }
// }

import 'package:chewie/chewie.dart';
import 'package:chronicle/Models/CourseModels/doubtModel.dart';
import 'package:chronicle/Models/CourseModels/videoIndexModel.dart';
import 'package:chronicle/Widgets/loaderWidget.dart';
import 'package:chronicle/Widgets/doubtList.dart';
import 'package:chronicle/globalClass.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerPage extends StatefulWidget {
  final VideoIndexModel video;
  final bool isTutor;
  final bool isDoubtEnabled;
  const VideoPlayerPage({@required this.video,@required this.isTutor,@required this.isDoubtEnabled});

  @override
  _VideoPlayerPageState createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  VideoPlayerController _videoPlayerController1;
  ChewieController _chewieController;
  TextEditingController doubtTextField=TextEditingController();
  GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey=GlobalKey<ScaffoldMessengerState>();
  ScrollController scrollController = new ScrollController();
  TextEditingController textController =new TextEditingController();
  @override
  void initState() {
    super.initState();
    initializePlayer();
  }

  @override
  void dispose() {
    _videoPlayerController1.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  Future<void> initializePlayer() async {
    _videoPlayerController1 = VideoPlayerController.network(
        widget.video.downloadUrl);
    await Future.wait([
      _videoPlayerController1.initialize(),
    ]);
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController1,
      autoPlay: true,
      looping: false,
      // Try playing around with some of these other options:
      // showControls: false,
      // materialProgressColors: ChewieProgressColors(
      //   playedColor: Colors.red,
      //   handleColor: Colors.blue,
      //   backgroundColor: Colors.grey,
      //   bufferedColor: Colors.lightGreen,
      // ),
      placeholder: Container(
        color: Colors.black,
      ),
      // autoInitialize: true,
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(key: scaffoldMessengerKey,child: Scaffold(
      appBar: AppBar(
        title: Text(widget.video.name),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Center(
              child: _chewieController != null &&
                  _chewieController
                      .videoPlayerController.value.isInitialized
                  ? Chewie(
                controller: _chewieController,
              )
                  : LoaderWidget(),
            ),
          ),
          if(widget.isDoubtEnabled)SizedBox(height: 5,),
          if(widget.video.doubts!=null&&widget.isDoubtEnabled)Center(child: Text("Doubts",style: TextStyle(fontWeight: FontWeight.bold),),),
          if(widget.video.doubts!=null&&widget.isDoubtEnabled)Container(height: 300,child: DoubtList(isTutor:widget.isTutor,listItems: widget.video.doubts,scaffoldMessengerKey:scaffoldMessengerKey,scrollController: scrollController,textEditingController: textController,),),
          if(!widget.isTutor&&widget.isDoubtEnabled)Row(children:[
            CircleAvatar(
              radius: 25,
              child: Image.asset(
                'assets/address.png',
                height: 30,
              ),
              backgroundColor: Colors.transparent,
            ),Expanded(child: Container(
                height: 70,
                child: TextFormField(
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  maxLength: 200,
                  controller: doubtTextField,
                  textInputAction: TextInputAction.newline,
                  style: TextStyle(),
                  expands: true,
                  decoration: InputDecoration(
                    suffix: IconButton(icon: Icon(Icons.add_comment_outlined),onPressed: (){
                      setState(() {
                        if(doubtTextField.text.isNotEmpty)widget.video.addDoubtToVideo(DoubtModel(userName: GlobalClass.user.displayName,question: doubtTextField.text,answer: null));
                      });
                    },),
                    border: const OutlineInputBorder(),
                    labelText: "Doubt",
                    contentPadding:
                    EdgeInsets.all(10.0),
                  ),
                )
            ),),]),
        ],
      ),
    ),);
  }
}