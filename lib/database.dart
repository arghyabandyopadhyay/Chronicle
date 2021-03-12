import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'Models/clientModel.dart';
final databaseReference=FirebaseDatabase.instance.reference();

DatabaseReference registerUser(ClientModel client)
{
  var id=databaseReference.child('arghyab13bga/client/').push();
  print(client.toJson());
  id.set(client.toJson());
  return id;
}

void updateClient(ClientModel client, DatabaseReference id) {
  id.update(client.toJson());
}

Future<List<ClientModel>> getAllClients() async {
  DataSnapshot dataSnapshot = await databaseReference.child('arghyab13bga/client/').once();
  List<ClientModel> clients = [];
  if (dataSnapshot.value != null) {
    print(dataSnapshot.value);
    dataSnapshot.value.forEach((key, value) {
      ClientModel client = ClientModel.fromJson(jsonDecode(jsonEncode(value)));
      client.setId(databaseReference.child('arghyab13bga/client/' + key));
      clients.add(client);
    });
  }
  return clients;
}