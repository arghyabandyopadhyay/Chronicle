import 'package:shared_preferences/shared_preferences.dart';


Future<bool> getShowNotificationValue() async {
  final prefs = await SharedPreferences.getInstance();
  final key = 'showNotification';
  final value = prefs.getBool(key) ?? false;
  return value;
}
setShowNotificationValue(bool showNotification) async {
  final prefs = await SharedPreferences.getInstance();
  final key = 'showNotification';
  final value = showNotification;
  prefs.setBool(key,value);
}

Future<String> getLastRegister() async {
  final prefs = await SharedPreferences.getInstance();
  final key = 'lastRegister';
  final value = prefs.getString(key);
  return value;
}
Future<void> setLastRegister(String id) async {
  final prefs = await SharedPreferences.getInstance();
  final key = 'lastRegister';
  final value = id;
  prefs.setString(key,value);
}