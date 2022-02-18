import 'package:chronicle/Models/CourseModels/courseIndexModel.dart';
import 'package:chronicle/Models/register_index_model.dart';
import 'package:chronicle/Models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GlobalClass {
  static String applicationToken;
  static UserModel userDetail;
  static User user;
  static List<RegisterIndexModel> registerList;
  static List<CourseIndexModel> myCourses;
  static String lastRegister;
}
