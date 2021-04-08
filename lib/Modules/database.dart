import 'dart:convert';

import 'package:chronicle/Models/registerModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import '../Models/clientModel.dart';
import '../Models/userModel.dart';
FirebaseDatabase database=FirebaseDatabase.instance;
final databaseReference=database.reference();
DatabaseReference registerUser(ClientModel client,User user,String registerId)
{
  var id=databaseReference.child('${user.uid}/registers/$registerId/client/').push();
  id.set(client.toJson());
  return id;
}

DatabaseReference addToRegister(User user,String name,)
{
  var id=databaseReference.child('${user.uid}/registers/').push();
  id.set({
    "Name":name,
  });
  return id;
}
void deleteDatabaseNode(DatabaseReference id) {
  databaseReference.child(id.path.replaceAll("registers", "registers/").replaceAll("client", "client/")).remove();
}
Future<DatabaseReference?> registerUserDetail(User user) async {
  database.setPersistenceEnabled(true);
  database.setPersistenceCacheSizeBytes(10000000);
  DatabaseReference? id=databaseReference.child('${user.uid}/userDetails/').push();
  await getUserDetails(user).then((value) => {
    if(value==null){
      id!.set(new UserModel(displayName: user.displayName,email: user.email,canAccess: 0,phoneNumber: user.phoneNumber).toJson()),
    }
    else{
      if(value.canAccess==0)
      {
        id=null
      }
    }
  });
  return id;
}

void updateClient(ClientModel client, DatabaseReference id) {
  id.update(client.toJson());
}

Future<List<ClientModel>> getAllClients(User user,String registerId) async {
  DataSnapshot dataSnapshot = await databaseReference.child('${user.uid}/registers/${registerId}/client/').once();
  List<ClientModel> clients = [];
  if (dataSnapshot.value != null) {
    dataSnapshot.value.forEach((key, value) {
      ClientModel client = ClientModel.fromJson(jsonDecode(jsonEncode(value)));
      client.setId(databaseReference.child('${user.uid}/registers/$registerId/client/' + key));
      clients.add(client);
    });
  }
  return clients;
}

Future<List<RegisterModel>> getAllRegisters(User user) async {
  DataSnapshot dataSnapshot = await databaseReference.child('${user.uid}/registers').once();
  List<RegisterModel> registers = [];
  if (dataSnapshot.value != null) {
    dataSnapshot.value.forEach((key, value) {
      RegisterModel register = RegisterModel.fromJson(jsonDecode(jsonEncode(value)));
      register.setId(databaseReference.child('${user.uid}/registers' + key));
      registers.add(register);
    });
  }
  return registers;
}

Future<UserModel?> getUserDetails(User user) async {
  DataSnapshot dataSnapshot = await databaseReference.child('${user.uid}/userDetails/').once();
  UserModel? userDetail;
  if (dataSnapshot.value != null) {
    dataSnapshot.value.forEach((key, value) {
      userDetail = UserModel.fromJson(jsonDecode(jsonEncode(value)));
      userDetail!.setId(databaseReference.child('${user.uid}/userDetails/'+key));
    });
    // userDetail = UserModel.fromJson(json[json.keys.toList()[0]]);
    // userDetail.setId(databaseReference.child('${user.uid}/userDetails/'));
  }
  return userDetail;
}

void updateUserDetails(UserModel user, DatabaseReference id) {
  id.update(user.toJson());
}