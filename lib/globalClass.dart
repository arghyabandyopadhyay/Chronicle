import 'package:chronicle/Models/CourseModels/courseIndexModel.dart';
import 'package:chronicle/Models/registerIndexModel.dart';
import 'package:chronicle/Models/userModel.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GlobalClass
{
  static String applicationToken;
  static UserModel userDetail;
  static User user;
  static List<RegisterIndexModel> registerList;
  static List<CourseIndexModel> myCourses;
  static String lastRegister;
}