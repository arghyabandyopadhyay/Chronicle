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