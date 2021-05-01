import 'dart:convert';

import 'package:chronicle/Models/registerModel.dart';
import 'package:chronicle/Pages/globalClass.dart';
import 'package:firebase_database/firebase_database.dart';
import '../Models/clientModel.dart';
import '../Models/userModel.dart';
FirebaseDatabase database=FirebaseDatabase.instance;
final databaseReference=database.reference();
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
void deleteDatabaseNode(DatabaseReference id) {
  databaseReference.child(id.path.replaceAll("registers", "registers/").replaceAll("client", "client/")).remove();
}
Future<DatabaseReference> registerUserDetail() async {
  DatabaseReference id;
  await getUserDetails().then((value) => {
    if(value==null){
      id=databaseReference.child('${GlobalClass.user.uid}/userDetails/').push(),
      id.set(new UserModel(displayName: GlobalClass.user.displayName,email: GlobalClass.user.email,canAccess: 0,phoneNumber: GlobalClass.user.phoneNumber).toJson()),
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
  id.update(client.toJson());
}

Future<List<ClientModel>> getAllClients(String registerId) async {

  DataSnapshot dataSnapshot = await databaseReference.child('${GlobalClass.user.uid}/registers/${registerId}/client/').once();
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
Future<List<ClientModel>> getNotificationClients() async {
  List<RegisterModel> registers=await getAllRegisters();
  List<ClientModel> clients = [];
  registers.forEach((registerElement)  {
    registerElement.clients.forEach((clientElement) async{
      int a=clientElement.endDate.difference(DateTime.now()).inDays;
      if((a>-3&&a<1)&&clientElement.due>=0)
      {
        clients.add(clientElement);
      }
    });
  });
  return clients;
}

Future<List<RegisterModel>> getAllRegisters() async {
  DataSnapshot dataSnapshot = await databaseReference.child('${GlobalClass.user.uid}/registers').once();
  List<RegisterModel> registers = [];
  if (dataSnapshot.value != null) {
    dataSnapshot.value.forEach((key, value) {
      RegisterModel register = RegisterModel.fromJson(jsonDecode(jsonEncode(value)),key);
      register.setId(databaseReference.child('${GlobalClass.user.uid}/registers' + key));
      registers.add(register);
    });
  }
  registers.sort((a,b)=>a.name.compareTo(b.name));
  return registers;
}

Future<UserModel> getUserDetails() async {
  DataSnapshot dataSnapshot = await databaseReference.child('${GlobalClass.user.uid}/userDetails/').once();
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