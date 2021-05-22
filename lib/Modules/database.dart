import 'dart:convert';
import 'package:chronicle/Models/CourseModels/courseIndexModel.dart';
import 'package:chronicle/Models/CourseModels/courseModel.dart';
import 'package:chronicle/Models/registerIndexModel.dart';
import 'package:chronicle/Models/registerModel.dart';
import 'package:chronicle/Models/tokenModel.dart';
import 'package:chronicle/Models/CourseModels/videoIndexModel.dart';
import 'package:chronicle/Modules/universalModule.dart';
import 'package:chronicle/globalClass.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import '../Models/clientModel.dart';
import '../Models/userModel.dart';
import 'auth.dart';
FirebaseDatabase database=FirebaseDatabase.instance;
final databaseReference=database.reference();
// void initiateDatabase(){
//   database.setPersistenceEnabled(true);
//   database.setPersistenceCacheSizeBytes(100000000);
// }
DatabaseReference addClientInRegister(ClientModel client,String registerId)
{
  var id=databaseReference.child('${GlobalClass.user.uid}/registers/$registerId/client/').push();
  id.set(client.toJson());
  return id;
}

DatabaseReference addRegister(String name,)
{
  var id=databaseReference.child('${GlobalClass.user.uid}/registers/').push();
  id.set({
    "Name":name,
  });
  return id;
}
DatabaseReference addRegisterIndex(RegisterIndexModel registerIndexModel)
{
  var id=databaseReference.child('${GlobalClass.user.uid}/registerIndex/').push();
  id.set(registerIndexModel.toJson());
  return id;
}

void renameRegister(RegisterIndexModel registerIndex, DatabaseReference id) async{
  id.update(registerIndex.toJson());
  DatabaseReference id2 = databaseReference.child('${GlobalClass.user.uid}/registers/${registerIndex.uid}/');
  id2.update({"Name":registerIndex.name});
}
void renameVideo(VideoIndexModel videoIndexModel, DatabaseReference id) async{
  id.update(videoIndexModel.toJson());
}

void deleteDatabaseNode(DatabaseReference id) {
  databaseReference.child(id.path).remove();
}
DatabaseReference getDatabaseReference(String directory)
{
  return databaseReference.child('${GlobalClass.user.uid}/$directory');
}
Future<DatabaseReference> addUserDetail() async {
  DatabaseReference id;
  await getUserDetails().then((value) => {
    if(value==null){
      id=databaseReference.child('${GlobalClass.user.uid}/userDetails/').push(),
      GlobalClass.userDetail=new UserModel(displayName: GlobalClass.user.displayName,email: GlobalClass.user.email,canAccess: 1,phoneNumber: GlobalClass.user.phoneNumber,isAppRegistered: 0),
      id.set(GlobalClass.userDetail.toJson()),
    }
    else{
      if(value.isOwner==1)id=value.id
      else if(value.isAppRegistered==1&&value.canAccess==0) id=null
      else id=value.id
    }
  });
  return id;
}

void updateClient(ClientModel client, DatabaseReference id) {
  client.masterFilter=(client.name+((client.mobileNo!=null)?client.mobileNo:"")+((client.startDate!=null)?client.startDate.toIso8601String():"")+((client.endDate!=null)?client.endDate.toIso8601String():"")).replaceAll(new RegExp(r'\W+'),"").toLowerCase();
  id.update(client.toJson());
}
///gets the list of clients in a register.
Future<List<ClientModel>> getAllClients(String registerId) async {
  DataSnapshot dataSnapshot = await databaseReference.child('${GlobalClass.user.uid}/registers/$registerId/client/').once();
  List<ClientModel> clients = [];
  if (dataSnapshot.value != null) {
    dataSnapshot.value.forEach((key, value) {
      ClientModel client = ClientModel.fromJson(jsonDecode(jsonEncode(value)));
      client.setId(databaseReference.child('${GlobalClass.user.uid}/registers/$registerId/client/' + key));
      clients.add(client);
    });
  }
  clients=sortClientsModule("A-Z", clients);
  return clients;
}
Future<List<ClientModel>> getNotificationClients(BuildContext context) async{
  await Authentication.initializeFirebase();
  if(GlobalClass.user==null)GlobalClass.user = FirebaseAuth.instance.currentUser;
  List<ClientModel> clients = [];
  if(GlobalClass.user!=null){
    await addUserDetail().then((value)async=>{
      if(value!=null){
        await getAllRegisters().then((registers) => {
          registers.forEach((registerElement){
            registerElement.clients.forEach((clientElement) async{
              DateTime now=DateTime.now();
              DateTime today=DateTime(now.year,now.month,now.day);
              int a=clientElement.endDate.difference(today).inDays;
              if((a>=-1&&a<=2)&&clientElement.due>=0)
              {
                clients.add(clientElement);
              }
            });
          })
        })
      }
    });
  }
  // List<RegisterModel> registers=await getAllRegisters();
  // List<ClientModel> clients = [];
  // registers.forEach((registerElement)  {
  //   registerElement.clients.forEach((clientElement) async{
  //     DateTime now=DateTime.now();
  //     DateTime today=DateTime(now.year,now.month,now.day);
  //     int a=clientElement.endDate.difference(today).inDays;
  //     if((a>=-1&&a<=2)&&clientElement.due>=0)
  //     {
  //       clients.add(clientElement);
  //     }
  //   });
  // });
  return clients;
}

///gets list of registers enlisted in the account.
Future<List<RegisterModel>> getAllRegisters() async {
  DataSnapshot dataSnapshot = await databaseReference.child('${GlobalClass.user.uid}/registers/').once();
  List<RegisterModel> registers = [];
  if (dataSnapshot.value != null) {
    dataSnapshot.value.forEach((key, value) {
      RegisterModel register = RegisterModel.fromJson(jsonDecode(jsonEncode(value)),key);
      register.setId(databaseReference.child('${GlobalClass.user.uid}/registers/' + key));
      registers.add(register);
    });
  }
  registers.sort((a,b)=>a.name.compareTo(b.name));
  return registers;
}
///gets list of register indexes enlisted in the account.
Future<List<RegisterIndexModel>> getAllRegisterIndex() async {
  DataSnapshot dataSnapshot = await databaseReference.child('${GlobalClass.user.uid}/registerIndex/').once();
  List<RegisterIndexModel> registers = [];
  if (dataSnapshot.value != null) {
    dataSnapshot.value.forEach((key, value) {
      RegisterIndexModel register = RegisterIndexModel.fromJson(jsonDecode(jsonEncode(value)),key);
      register.setId(databaseReference.child('${GlobalClass.user.uid}/registerIndex/' + key));
      registers.add(register);
    });
  }
  registers.sort((a,b)=>a.name.compareTo(b.name));
  return registers;
}
///gets the details of the user.
Future<UserModel> getUserDetails() async {
  DatabaseReference userDetailReference=databaseReference.child('${GlobalClass.user.uid}/userDetails/');
  // userDetailReference.keepSynced(true);
  DataSnapshot dataSnapshot = await userDetailReference.once();
  UserModel userDetail;
  if (dataSnapshot.value != null) {
    dataSnapshot.value.forEach((key, value) {
      userDetail = UserModel.fromJson(jsonDecode(jsonEncode(value)),key);
      userDetail.setId(databaseReference.child('${GlobalClass.user.uid}/userDetails/'+key));
    });
    // userDetail = UserModel.fromJson(json[json.keys.toList()[0]]);
    // userDetail.setId(databaseReference.child('${GlobalClass.user.uid}/userDetails/'));
  }
  GlobalClass.userDetail=userDetail;
  return userDetail;
}
addToken(UserModel userModel,TokenModel tokenModel)
{
  var id=databaseReference.child(userModel.id.path+"/Tokens/").push();
  id.set(tokenModel.toJson());
  tokenModel.setId(id);
  if(userModel.tokens==null)userModel.tokens=[tokenModel];
  else userModel.tokens.add(tokenModel);
}
updateToken(TokenModel tokenModel)
{
  tokenModel.id.update(tokenModel.toJson());
}
///updates the details of the user.
void updateUserDetails(UserModel user, DatabaseReference id) {
  id.update(user.toJson());
}

DatabaseReference addVideoIndex(VideoIndexModel videoIndexModel)
{
  var id=databaseReference.child('VideoIndex/${GlobalClass.user.uid}/').push();
  id.set(videoIndexModel.toJson());
  return id;
}
///gets the list of videos.
Future<List<VideoIndexModel>> getAllVideos() async {
  DataSnapshot dataSnapshot = await databaseReference.child('VideoIndex/${GlobalClass.user.uid}/').once();
  List<VideoIndexModel> videos = [];
  if (dataSnapshot.value != null) {
    dataSnapshot.value.forEach((key, value) {
      VideoIndexModel video = VideoIndexModel.fromJson(jsonDecode(jsonEncode(value)),key);
      video.setId(databaseReference.child('VideoIndex/${GlobalClass.user.uid}/' + key));
      videos.add(video);
    });
  }
  return videos;
}

///gets list of courses enlisted in the account.
Future<CourseModel> getCourse(CourseIndexModel courseIndex) async {
  DataSnapshot dataSnapshot = await databaseReference.child(courseIndex.uid).once();
  CourseModel course ;
  if (dataSnapshot.value != null) {
    course = CourseModel.fromJson(jsonDecode(jsonEncode(dataSnapshot.value)),courseIndex.uid);
    course.setId(databaseReference.child(courseIndex.uid));
  }
  return course;
}

Future<List<CourseIndexModel>> getAllCourseIndexes(String coursesType,bool isGlobal) async {
  DataSnapshot dataSnapshot = await databaseReference.child(isGlobal?('CourseIndexes/'):('${GlobalClass.user.uid}/$coursesType/')).once();
  List<CourseIndexModel> courses = [];
  if (dataSnapshot.value != null) {
    dataSnapshot.value.forEach((key, value) {
      CourseIndexModel course = CourseIndexModel.fromJson(jsonDecode(jsonEncode(value)),key);
      course.setId(databaseReference.child((isGlobal?('CourseIndexes/'):('${GlobalClass.user.uid}/$coursesType/')) + key));
      courses.add(course);
    });
  }
  courses.sort((a,b)=>a.title.compareTo(b.title));
  return courses;
}

DatabaseReference addCoursesToOwnLists(String coursesType,CourseIndexModel courseIndex) {
  var id = databaseReference.child(('${GlobalClass.user.uid}/$coursesType/')).push();
  id.set(courseIndex.toJson());
  if(GlobalClass.myPurchasedCourses!=null&&coursesType=="Courses"){
    courseIndex.setId(id);
    GlobalClass.myPurchasedCourses.add(courseIndex);
  }
  return id;
}

CourseIndexModel addCourse(CourseModel course)
{
  DateTime now=DateTime.now();
  course.totalUsers=0;
  course.sellingPrice=course.authorPrice+course.coursePackageDurationInMonths*100;
  course.authorUid=GlobalClass.user.uid;
  course.authorName=GlobalClass.user.displayName;
  course.lastUpdated=DateTime(now.year,now.month,now.day);
  var id=databaseReference.child('Courses/${GlobalClass.user.uid}').push();
  id.set(course.toJson());
  course.setId(id);
  course.addCourseVideoIndexes();
  course.addCoursePreviewVideoIndex();
  var id2=databaseReference.child('CourseIndexes/').push();
  CourseIndexModel courseIndex=CourseIndexModel(uid: id.path,authorName:GlobalClass.user.displayName,sellingPrice:course.sellingPrice,totalUsers:course.totalUsers,title: course.title,description: course.description,previewThumbnailUrl: course.previewThumbnailUrl);
  id2.set(courseIndex.toJson());
  course.id.update({"CourseIndexKey":id2.key});
  var id3=databaseReference.child('${GlobalClass.user.uid}/CoursesByMe/').push();
  id3.set(courseIndex.toJson());
  courseIndex.setId(id3);
  return courseIndex;
}
Future<CourseIndexModel> updateCourse(CourseModel course,CourseIndexModel courseByMe)async {
  DateTime now=DateTime.now();
  course.lastUpdated=DateTime(now.year,now.month,now.day);
  course.id.update(course.toJson());
  // course.updateVideoIndexes();
  // course.updatePreviewVideoIndex();
  CourseIndexModel courseIndexModel;
  DataSnapshot dataSnapshot = await databaseReference.child('CourseIndexes/${course.courseIndexKey}').once();
  if (dataSnapshot.value != null) {
    courseIndexModel = CourseIndexModel.fromJson(jsonDecode(jsonEncode(dataSnapshot.value)),"");
    courseIndexModel.setId(databaseReference.child('CourseIndexes/${course.courseIndexKey}'));
    courseIndexModel.id.update(CourseIndexModel(uid: course.id.path,authorName:GlobalClass.user.displayName,sellingPrice:course.sellingPrice,totalUsers:course.totalUsers,title: course.title,description: course.description,previewThumbnailUrl: course.previewThumbnailUrl).toJson());
  }
  courseByMe.id.update(CourseIndexModel(uid: course.id.path,authorName:GlobalClass.user.displayName,sellingPrice:course.sellingPrice,totalUsers:course.totalUsers,title: course.title,description: course.description,previewThumbnailUrl: course.previewThumbnailUrl).toJson());
  return courseByMe;
}