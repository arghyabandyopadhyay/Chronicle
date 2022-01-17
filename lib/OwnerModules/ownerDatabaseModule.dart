import 'dart:convert';
import 'package:chronicle/Models/userModel.dart';
import 'package:chronicle/Modules/database.dart';
import 'package:chronicle/globalClass.dart';
import 'package:firebase_database/firebase_database.dart';
import 'chronicleUserModel.dart';

DatabaseReference chronicleUserRegistration(ChronicleUserModel user)
{
  var id=databaseReference.child('${GlobalClass.userDetail.repo}/chronicleUsers/').push();
  id.set(user.toJson());
  return id;
}
void updateChronicleUserDetails(ChronicleUserModel user, DatabaseReference id,bool isForAccessChange) async{
  id.update(user.toJson());
  if(isForAccessChange){
    UserModel userDetails=await getChronicleUserDetails(user.uid);
    userDetails.isAppRegistered=user.isAppRegistered;
    userDetails.update();
  }
}

Future<UserModel> getChronicleUserDetails(String uid) async {
  DataSnapshot dataSnapshot = await databaseReference.child('$uid/userDetails/').once();
  UserModel userDetail;
  if (dataSnapshot.value != null) {
    dataSnapshot.value.forEach((key, value) {
      userDetail = UserModel.fromJson(jsonDecode(jsonEncode(value)),key);
      userDetail.setId(databaseReference.child('$uid/userDetails/'+key));
    });
  }
  return userDetail;
}