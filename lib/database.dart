import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'Models/clientModel.dart';
import 'Models/userModel.dart';
final databaseReference=FirebaseDatabase.instance.reference();

DatabaseReference registerUser(ClientModel client,User user)
{
  var id=databaseReference.child('${user.uid}/client/').push();
  id.set(client.toJson());
  return id;
}
Future<DatabaseReference> registerUserDetail(User user) async {
  var id=databaseReference.child('${user.uid}/userDetails/').push();
  await getUserDetails(user).then((value) => {
    if(value==null)id.set(new UserModel(displayName: user.displayName,email: user.email,canAccess: 1,phoneNumber: user.phoneNumber).toJson())
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

Future<List<ClientModel>> getAllClients(User user) async {
  DataSnapshot dataSnapshot = await databaseReference.child('${user.uid}/client/').once();
  List<ClientModel> clients = [];
  if (dataSnapshot.value != null) {
    dataSnapshot.value.forEach((key, value) {
      ClientModel client = ClientModel.fromJson(jsonDecode(jsonEncode(value)));
      client.setId(databaseReference.child('${user.uid}/client/' + key));
      clients.add(client);
    });
  }
  return clients;
}

Future<UserModel> getUserDetails(User user) async {
  DataSnapshot dataSnapshot = await databaseReference.child('${user.uid}/userDetails/').once();
  var json=jsonDecode(jsonEncode(dataSnapshot.value));
  UserModel userDetail;
  if (dataSnapshot.value != null) {
    userDetail = UserModel.fromJson(json[json.keys.toList()[0]]);
  }
  return userDetail;
}