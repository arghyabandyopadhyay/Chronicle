import 'package:chronicle/Models/registerModel.dart';
import 'package:chronicle/Models/userModel.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GlobalClass
{
  static String applicationToken;
  static UserModel userDetail;
  static User user;
  static List<RegisterModel> registerList;
}