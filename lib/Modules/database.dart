import 'dart:convert';

import 'package:chronicle/OwnerModules/chronicleUserModel.dart';
import 'package:chronicle/Models/registerIndexModel.dart';
import 'package:chronicle/Models/registerModel.dart';
import 'package:chronicle/Pages/globalClass.dart';
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
DatabaseReference registerUser(ClientModel client,String registerId)
{
  var id=databaseReference.child('${GlobalClass.user.uid}/registers/$registerId/client/').push();
  id.set(client.toJson());
  return id;
}

DatabaseReference addToRegister(String name,)
{
  var id=databaseReference.child('${GlobalClass.user.uid}/registers/').push();
  id.set({
    "Name":name,
  });
  return id;
}
DatabaseReference addToRegisterIndex(RegisterIndexModel registerIndexModel)
{
  var id=databaseReference.child('${GlobalClass.user.uid}/registerIndex/').push();
  id.set(registerIndexModel.toJson());
  return id;
}
void deleteDatabaseNode(DatabaseReference id) {
  databaseReference.child(id.path).remove();
}
DatabaseReference getDatabaseReference(String directory)
{
  return databaseReference.child('${GlobalClass.user.uid}/$directory');
}
Future<DatabaseReference> registerUserDetail() async {
  DatabaseReference id;
  await getUserDetails().then((value) => {
    if(value==null){
      id=databaseReference.child('${GlobalClass.user.uid}/userDetails/').push(),
      id.set(new UserModel(displayName: GlobalClass.user.displayName,email: GlobalClass.user.email,canAccess: 0,phoneNumber: GlobalClass.user.phoneNumber,isAppRegistered: 0).toJson()),
    }
    else{
      if(value.canAccess==0)
        {
          id=null
        }
      else{
        id=value.id
      }
    }
  });
  return id;
}

void updateClient(ClientModel client, DatabaseReference id) {
  client.masterFilter=(client.name+((client.mobileNo!=null)?client.mobileNo:"")+((client.startDate!=null)?client.startDate.toIso8601String():"")+((client.endDate!=null)?client.endDate.toIso8601String():"")).replaceAll(new RegExp(r'\W+'),"").toLowerCase();
  id.update(client.toJson());
}

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
  clients.sort((a,b)=>a.name.compareTo(b.name));
  return clients;
}
Future<List<ClientModel>> getNotificationClients(BuildContext context) async{
  await Authentication.initializeFirebase();
  if(GlobalClass.user==null)GlobalClass.user = FirebaseAuth.instance.currentUser;
  List<ClientModel> clients = [];
  if(GlobalClass.user!=null){
    await registerUserDetail().then((value)async=>{
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

Future<UserModel> getUserDetails() async {
  DatabaseReference userDetailReference=databaseReference.child('${GlobalClass.user.uid}/userDetails/');
  // userDetailReference.keepSynced(true);
  DataSnapshot dataSnapshot = await userDetailReference.once();
  UserModel userDetail;
  if (dataSnapshot.value != null) {
    dataSnapshot.value.forEach((key, value) {
      userDetail = UserModel.fromJson(jsonDecode(jsonEncode(value)));
      userDetail.setId(databaseReference.child('${GlobalClass.user.uid}/userDetails/'+key));
    });
    // userDetail = UserModel.fromJson(json[json.keys.toList()[0]]);
    // userDetail.setId(databaseReference.child('${GlobalClass.user.uid}/userDetails/'));
  }
  GlobalClass.userDetail=userDetail;
  return userDetail;
}

void updateUserDetails(UserModel user, DatabaseReference id) {
  id.update(user.toJson());
}
