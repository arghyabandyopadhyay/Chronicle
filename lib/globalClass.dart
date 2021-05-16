import 'package:chronicle/Models/registerIndexModel.dart';
import 'package:chronicle/Models/userModel.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GlobalClass
{
  static String applicationToken;
  static UserModel userDetail;
  static User user;
  static List<RegisterIndexModel> registerList;
  static String lastRegister;
}

// API for sending videos
const muxBaseUrl = 'https://api.mux.com';

// API server running on localhost
const muxServerUrl = 'http://192.168.43.23:3000';

// API for generating thumbnails of a video
const muxImageBaseUrl = 'https://image.mux.com';

// API for streaming a video
const muxStreamBaseUrl = 'https://stream.mux.com';

// Received video file format
const videoExtension = 'm3u8';

// Thumbnail file type and size
const imageTypeSize = 'thumbnail.jpg?time=5&width=200';

// Content Type used in API calls
const contentType = 'application/json';

// Access token in corrent format
var authToken = '$accessTokenMUX:$secretTokenMUX';

// Test video url provided by MUX
const demoVideoUrl = 'https://storage.googleapis.com/muxdemofiles/mux-video-intro.mp4';

// Specifying playback policy to public
const playbackPolicy = 'public';

String accessTokenMUX="532d6c92-b190-4a4e-a7ec-1205029fbd11";
String secretTokenMUX="HYxDrVMl2RJAgA2wktmqdNnb+glS0vMHi46BOOlCqjnBZmMCDpswW8ewIwCpY87Qmp8ShXK1LSv";