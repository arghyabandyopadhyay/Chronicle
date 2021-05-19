import 'dart:io';
import 'package:chronicle/Models/modalOptionModel.dart';
import 'package:chronicle/Models/CourseModels/videoIndexModel.dart';
import 'package:chronicle/Modules/database.dart';
import 'package:chronicle/Modules/errorPage.dart';
import 'package:chronicle/Modules/storage.dart';
import 'package:chronicle/Modules/universalModule.dart';
import 'package:chronicle/Pages/TutorPages/videoPlayerPage.dart';
import 'package:chronicle/Widgets/Simmers/loaderWidget.dart';
import 'package:chronicle/Widgets/videoList.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import '../../customColors.dart';
import '../../globalClass.dart';

class VideosPage extends StatefulWidget {
  const VideosPage({ Key key}) : super(key: key);
  @override
  _VideosPageState createState() => _VideosPageState();
}
class _VideosPageState extends State<VideosPage> {
  List<VideoIndexModel> videos;
  List<VideoIndexModel> selectedList=[];
  int _counter=0;
  bool _isLoading;
  GlobalKey<ScaffoldState> scaffoldKey=GlobalKey<ScaffoldState>();
  GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey=GlobalKey<ScaffoldMessengerState>();
  bool _isSearching=false;
  int sortVal=1;
  List<VideoIndexModel> searchResult = [];
  Icon icon = new Icon(
    Icons.search,
  );
  //Controller
  final TextEditingController _searchController = new TextEditingController();
  final TextEditingController textEditingController=new TextEditingController();
  final TextEditingController renameRegisterTextEditingController=new TextEditingController();
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey =new GlobalKey<RefreshIndicatorState>();
  ScrollController scrollController = new ScrollController();
  //Widgets
  Widget appBarTitle;
  void _handleSearchStart() {
    setState(() {
      _isSearching = true;
    });
  }
  void _handleSearchEnd() {
    setState(() {
      this.icon = new Icon(
        Icons.search,
      );
      this.appBarTitle = Text("Videos");
      _isSearching = false;
      _searchController.clear();
    });
  }
  void searchOperation(String searchText)
  {
    searchResult.clear();
    if(_isSearching){
      searchResult=videos.where((VideoIndexModel element) => (element.name.toLowerCase()).contains(searchText.toLowerCase().replaceAll(new RegExp(r"\W+"), ""))).toList();
      setState(() {
      });
    }
  }
  void newVideoIndexModel(VideoIndexModel video) {
    video.setId(addVideoIndex(video));
    if(mounted)this.setState(() {
      videos.add(video);
    });
  }
  Future<Null> refreshData() async{
    if(selectedList.length!=0){
      setState(() {
        for(VideoIndexModel a in selectedList)
        {
          a.isSelected=false;
        }
        if(_isSearching)_handleSearchEnd();
        selectedList.clear();
      });
    }
    try{
      if(_isSearching)_handleSearchEnd();
      Connectivity connectivity=Connectivity();
      await connectivity.checkConnectivity().then((value)async {
        if(value!=ConnectivityResult.none)
        {
          if(!_isLoading){
            _isLoading=true;
            return getAllVideos().then((videos) {
              if(mounted)this.setState(() {
                this.videos = videos;
                _counter++;
                _isLoading=false;
                this.appBarTitle = Text("Videos");
              });
            });
          }
          else{
            globalShowInSnackBar(scaffoldMessengerKey, "Data is being loaded...");
            return;
          }
        }
        else{
          setState(() {
            _isLoading=false;
          });
          globalShowInSnackBar(scaffoldMessengerKey,"No Internet Connection!!");
          return;
        }
      });
    }
    catch(E)
    {
      setState(() {
        _isLoading=false;
      });
      globalShowInSnackBar(scaffoldMessengerKey,"Something Went Wrong");
      return;
    }
  }

  void getVideoIndexModels() {
    getAllVideos().then((videos) => {
      if(mounted)this.setState(() {
        this.videos = videos;
        _counter++;
        _isLoading=false;
        this.appBarTitle = Text("Videos");
      })
    });
  }
  double progressValue=0;
  bool isUploading=false;
  @override
  void initState() {
    super.initState();
    getVideoIndexModels();
    this.appBarTitle = Text("Videos");
  }
  getAppBar(){
    if(selectedList.length < 1)
      return AppBar(
        title: appBarTitle,
        leading: IconButton(onPressed: () { if(!_isSearching)Navigator.of(context).pop(); }, icon: Icon(_isSearching?Icons.search:Icons.arrow_back),),
        bottom: PreferredSize(
          child: (isUploading)?LinearProgressIndicator(value: progressValue,minHeight: 2,):Container(width: 0.0, height: 0.0), preferredSize: Size(double.infinity,2),
        ),
        actions: [
          new IconButton(icon: icon, onPressed:(){
            setState(() {
              if(this.icon.icon == Icons.search)
              {
                this.icon=new Icon(Icons.close);
                this.appBarTitle=TextFormField(autofocus:true,controller: _searchController,style: TextStyle(fontSize: 15),decoration: InputDecoration(border: const OutlineInputBorder(borderSide: BorderSide.none),hintText: "Search...",hintStyle: TextStyle(fontSize: 15)),onChanged: searchOperation,);
                _handleSearchStart();
              }
              else _handleSearchEnd();
            });
          }),
          PopupMenuButton<ModalOptionModel>(
            itemBuilder: (BuildContext popupContext){
              return [
                ModalOptionModel(particulars: "Move to top",icon:Icons.vertical_align_top_outlined,iconColor:CustomColors.moveToTopIconColor, onTap: () async {
                  Navigator.pop(popupContext);
                  scrollController.animateTo(
                    scrollController.position.minScrollExtent,
                    duration: Duration(seconds: 1),
                    curve: Curves.fastOutSlowIn,
                  );
                }),
                ModalOptionModel(particulars: "Upload",icon:Icons.video_call_outlined,iconColor:CustomColors.uploadIconColor, onTap: () async {
                  Navigator.pop(popupContext);
                  final file = await ImagePicker().getVideo(source: ImageSource.gallery,maxDuration: const Duration(seconds: 300),);
                  if(file!=null)showDialog(context: context, builder: (_)=>new AlertDialog(
                    title: Text("Name the video"),
                    content: TextField(controller: textEditingController,
                      textCapitalization: TextCapitalization.words,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: "Name of the Video",
                        contentPadding:
                        EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0),
                      ),
                    ),
                    actions: [ActionChip(label: Text("Upload"), onPressed: () async {
                      if(textEditingController.text!=""){
                        Navigator.pop(_);
                        await uploadFile(file.path,textEditingController.text.replaceAll(new RegExp(r'[^\s\w]+'),""));
                        textEditingController.clear();
                      }
                      else{
                        globalShowInSnackBar(scaffoldMessengerKey, "Please enter a valid name for your video!!");
                        Navigator.of(_).pop();
                      }
                    }),
                      ActionChip(label: Text("Cancel"), onPressed: (){
                        Navigator.of(_).pop();
                      }),],
                  ));
                }),
              ].map((ModalOptionModel choice){
                return PopupMenuItem<ModalOptionModel>(
                  value: choice,
                  child: ListTile(title: Text(choice.particulars),leading: Icon(choice.icon,color: choice.iconColor),onTap: choice.onTap,),
                );
              }).toList();
            },
          ),
        ],);
    else
      return AppBar(
        elevation: 0,
        title: Text("${selectedList.length} item selected"),
        leading:IconButton(
          icon: Icon(Icons.clear,),
          onPressed: (){
            setState(() {
              for(VideoIndexModel a in selectedList)
              {
                a.isSelected=false;
              }
              selectedList.clear();
            });
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.select_all,),
            onPressed: (){
              setState(() {
                selectedList.clear();
                selectedList.addAll(_isSearching?searchResult:videos);
                for(VideoIndexModel a in selectedList)
                {
                  a.isSelected=true;
                }
              });
            },
          ),
          IconButton(
            onPressed: () async {
              showDialog(context: context, builder: (_)=>new AlertDialog(
                title: Text("Confirm Delete"),
                content: Text("Are you sure to delete all the selected videos?\n The change is irreversible."),
                actions: [
                  ActionChip(label: Text("Yes"), onPressed: (){
                    setState(() {
                      selectedList.forEach((element) {
                        deleteFromStorageModule(element,scaffoldMessengerKey);
                        if(_isSearching)searchResult.remove(element);
                        videos.remove(element);
                      });
                      for(VideoIndexModel a in selectedList)
                      {
                        a.isSelected=false;
                      }
                      if(_isSearching)_handleSearchEnd();
                      selectedList.clear();
                      Navigator.of(_).pop();
                    });
                  }),
                  ActionChip(label: Text("No"), onPressed: (){
                    setState(() {
                      Navigator.of(_).pop();
                    });
                  })
                ],
              ));

            },
            icon: Icon(Icons.delete),
          )
        ],
      );
  }
  Future<void> uploadFile(String filePath,String name) async {
    try {
      progressValue=0;
      final DateTime now = DateTime.now();
      final int millSeconds = now.millisecondsSinceEpoch;
      final String month = now.month.toString();
      final String date = now.day.toString();
      final String storageId = (millSeconds.toString() + "_$name");
      final String today = ('$month-$date');
      File file = File(filePath);
      int fileSize=await file.length();
      setState(() {
        isUploading=true;
      });
      firebase_storage.UploadTask task=storage.ref('${GlobalClass.user.uid}/$today/$storageId').putFile(file,firebase_storage.SettableMetadata(contentType: 'video/mp4'));
      task.snapshotEvents.listen((firebase_storage.TaskSnapshot snapshot) {
        if(mounted)setState(() {
          progressValue=(snapshot.bytesTransferred / snapshot.totalBytes);
        });
      }, onError: (e) {
        // The final snapshot is also available on the task via `.snapshot`,
        // this can include 2 additional states, `TaskState.error` & `TaskState.canceled`
        globalShowInSnackBar(scaffoldMessengerKey,e.toString());

        if (e.code == 'permission-denied') {
          globalShowInSnackBar(scaffoldMessengerKey,'You does not have permission to upload to this reference.');
        }
      });
      await task;
      globalShowInSnackBar(scaffoldMessengerKey,"The video has been uploaded. Uploading metadata...");
      String url=await downloadURL('${GlobalClass.user.uid}/$today/$storageId');
      String thumbnailFilePath = await VideoThumbnail.thumbnailFile(
        video: url,
        thumbnailPath: (await getTemporaryDirectory()).path,
        imageFormat: ImageFormat.WEBP,
        maxHeight: 100, // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
        quality: 75,
      );
      File thumbnailFile=File(thumbnailFilePath);
      int thumbnailFileSize=await thumbnailFile.length();
      firebase_storage.UploadTask task2=storage.ref('${GlobalClass.user.uid}/$today/thumbnail_$storageId').putFile(thumbnailFile,firebase_storage.SettableMetadata(contentType: 'WEBP'));
      task2.snapshotEvents.listen((firebase_storage.TaskSnapshot snapshot) {
        if(mounted)setState(() {
          progressValue=(snapshot.bytesTransferred / snapshot.totalBytes);
        });
      }, onError: (e) {
        // The final snapshot is also available on the task via `.snapshot`,
        // this can include 2 additional states, `TaskState.error` & `TaskState.canceled`
        globalShowInSnackBar(scaffoldMessengerKey,e.toString());
        if (e.code == 'permission-denied') {
          globalShowInSnackBar(scaffoldMessengerKey,'User does not have permission to upload to this reference.');
        }
      });
      await task2;
      String thumbnailUrl=await downloadURL('${GlobalClass.user.uid}/$today/thumbnail_$storageId');
      newVideoIndexModel(new VideoIndexModel(cloudStorageSize:fileSize,thumbnailSize:thumbnailFileSize,name:storageId,directory:'${GlobalClass.user.uid}/$today/$storageId',downloadUrl: url,sharedRegisterKeys: "",thumbnailUrl: thumbnailUrl));
      GlobalClass.userDetail.cloudStorageSize=GlobalClass.userDetail.cloudStorageSize+thumbnailFileSize+fileSize;
      GlobalClass.userDetail.update();
      globalShowInSnackBar(scaffoldMessengerKey,"Upload complete!!");
      if(mounted)setState(() {
        isUploading=false;
      });
      refreshIndicatorKey.currentState.show();
    }
    on firebase_core.FirebaseException catch (e) {
      if (e.code == 'permission-denied') {
        globalShowInSnackBar(scaffoldMessengerKey,'User does not have permission to upload to this reference.');
      }
      // ...
    }
  }
  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(child: Scaffold(
      appBar: getAppBar(),
      body: this.videos!=null?this.videos.length==0?NoDataError():Column(children: <Widget>[
        Center(child: Text("Storage Occupied: ${classifySize(GlobalClass.userDetail.cloudStorageSize)} of ${classifySize(GlobalClass.userDetail.cloudStorageSizeLimit)}",style: TextStyle(color: GlobalClass.userDetail.cloudStorageSize>GlobalClass.userDetail.cloudStorageSizeLimit?Colors.red:null),),),
        Expanded(child: _isSearching?
        Provider.value(
            value: _counter,
            updateShouldNotify: (oldValue, newValue) => true,
            child: VideoList(listItems:this.searchResult,
                refreshIndicatorKey: refreshIndicatorKey,
                refreshData: (){
                  return refreshData();
                },
                scrollController:scrollController,
                scaffoldMessengerKey:scaffoldMessengerKey,
                onTapList:(index) async {
                  if(selectedList.length<1){
                    Navigator.of(context).push(CupertinoPageRoute(builder: (context)=>
                        VideoPlayerPage(video:this.searchResult[index])));
                  }
                  else {
                    setState(() {
                      searchResult[index].isSelected=!searchResult[index].isSelected;
                      if (searchResult[index].isSelected) {
                        selectedList.add(searchResult[index]);
                      } else {
                        selectedList.remove(searchResult[index]);
                      }
                    });
                  }
                },
                onLongPressed:(index)
                {
                  setState(() {
                    searchResult[index].isSelected=!searchResult[index].isSelected;
                    if (searchResult[index].isSelected) {
                      selectedList.add(searchResult[index]);
                    } else {
                      selectedList.remove(searchResult[index]);
                    }
                  });
                },
            )):
        Provider.value(
            value: _counter,
            updateShouldNotify: (oldValue, newValue) => true,
            child: VideoList(listItems:this.videos,scaffoldMessengerKey:scaffoldMessengerKey,
                refreshData: (){
                  return refreshData();
                },
                refreshIndicatorKey: refreshIndicatorKey,
                scrollController: scrollController,
                onTapList:(index) async {
                  if(selectedList.length<1){
                    Navigator.of(context).push(CupertinoPageRoute(builder: (context)=>
                        VideoPlayerPage(video:this.videos[index]))).then((value){
                      setState(() {
                        if(value==null) {}
                        else this.videos.remove(this.videos[index]);
                      });
                    });
                  }
                  else {
                    setState(() {
                      videos[index].isSelected=!videos[index].isSelected;
                      if (videos[index].isSelected) {
                        selectedList.add(videos[index]);
                      } else {
                        selectedList.remove(videos[index]);
                      }
                    });
                  }
                },
                onLongPressed:(index)
                {
                  setState(() {
                    videos[index].isSelected=!videos[index].isSelected;
                    if (videos[index].isSelected) {
                      selectedList.add(videos[index]);
                    } else {
                      selectedList.remove(videos[index]);
                    }
                  });
                },
            )
        )),
      ]):
      LoaderWidget(),
    ),key: scaffoldMessengerKey,);
  }
}