import 'package:chronicle/Models/videoIndexModel.dart';
import 'package:chronicle/Widgets/Simmers/clientListSimmerWidget.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../customColors.dart';

class VideoPlayerPage extends StatefulWidget {
  final VideoIndexModel video;
  const VideoPlayerPage({@required this.video});

  @override
  _VideoPlayerPageState createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  VideoPlayerController _controller;
  String appBarText='Video';
  bool isRotated=false;
  static const _examplePlaybackRates = [
    0.25,
    0.5,
    1.0,
    1.5,
    2.0,
  ];
  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.video.downloadUrl)
      ..initialize().then((_) {
        setState(() {});
      });
    _controller.play();
    appBarText=this.widget.video.name.substring(this.widget.video.name.indexOf("_")+1);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget buildFullScreen({Widget child}) {
    final size=_controller.value.size;
    final width=size.width;
    final height=size.height;
    return FittedBox(child:SizedBox(height: height,width: width,child:  child),fit: BoxFit.contain,);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isRotated||MediaQuery.of(context).orientation==Orientation.landscape?null:AppBar(
        title: Text(appBarText),
      ),
      body: RotatedBox(
          quarterTurns: isRotated&&MediaQuery.of(context).orientation==Orientation.portrait?3:0,
          child: _controller.value.isInitialized
              ? Container(
            color: Colors.black,
            child: Stack(
              fit: StackFit.expand,
              alignment: Alignment.bottomCenter,
              children: [
                buildFullScreen(child:AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                )),
                Stack(
                  children: <Widget>[
                    AnimatedSwitcher(
                      duration: Duration(milliseconds: 50),
                      reverseDuration: Duration(milliseconds: 200),
                      child: _controller.value.isPlaying
                          ? SizedBox.shrink()
                          : Container(
                        color: Colors.black26,
                        child: Center(
                          child: Icon(
                            Icons.play_arrow,
                            color: CustomColors.playbackSpeedTextColor,
                            size: 100.0,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if(_controller.value.position>=_controller.value.duration) {
                                  _controller.seekTo(Duration.zero);
                                  _controller.pause();
                                }
                          else _controller.value.isPlaying ? _controller.pause() : _controller.play();
                        });
                      },
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: PopupMenuButton<double>(
                        initialValue: _controller.value.playbackSpeed,
                        tooltip: 'Playback speed',
                        onSelected: (speed) {
                          setState(() {
                            _controller.setPlaybackSpeed(speed);
                          });
                        },
                        itemBuilder: (context) {
                          return [
                            for (final speed in _examplePlaybackRates)
                              PopupMenuItem(
                                value: speed,
                                child: Text('${speed}x'),
                              )
                          ];
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            // Using less vertical padding as the text is also longer
                            // horizontally, so it feels like it would need more spacing
                            // horizontally (matching the aspect ratio of the video).
                            vertical: 12,
                            horizontal: 16,
                          ),
                          child: Text('${_controller.value.playbackSpeed}x',style: TextStyle(color: CustomColors.playbackSpeedTextColor),),
                        ),
                      ),
                    ),
                    Align(
                        alignment: Alignment.bottomRight,
                        child: isRotated||MediaQuery.of(context).orientation==Orientation.landscape?IconButton(icon: Icon(Icons.fullscreen_exit_outlined,color: Colors.white,),onPressed: (){
                          setState(() {
                            isRotated=false;
                          });
                        },):IconButton(icon: Icon(Icons.fullscreen_outlined,color: Colors.white,),onPressed: (){
                          setState(() {
                            isRotated=true;
                          });
                        },)
                    ),
                    Align(alignment: Alignment.bottomCenter,child: VideoProgressIndicator(_controller, allowScrubbing: true),)
                  ],
                ),
              ],),): ClientListSimmerWidget()
      ),
    );
  }
}