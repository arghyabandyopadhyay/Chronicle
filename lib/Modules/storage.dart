import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;

Future uploadToStorage(String directory,String uid) async {
  try {
    final DateTime now = DateTime.now();
    final int millSeconds = now.millisecondsSinceEpoch;
    final String month = now.month.toString();
    final String date = now.day.toString();
    final String storageId = (millSeconds.toString() + uid);
    final String today = ('$month-$date');

    final file = await ImagePicker().getVideo(source: ImageSource.gallery);
    File videoFile=File(file.path);

    firebase_storage.Reference ref = storage.ref().child(directory).child(today).child(storageId);
    firebase_storage.UploadTask uploadTask = ref.putFile(videoFile, firebase_storage.SettableMetadata(contentType: 'video/mp4'));

    String downloadUrl = await firebase_storage.FirebaseStorage.instance
        .ref(directory)
        .getDownloadURL();

    print(downloadUrl);
  }on firebase_core.FirebaseException catch (error) {
    print(error);
  }
}

Future<void> downloadFile() async {
  Directory appDocDir = await getApplicationDocumentsDirectory();
  File downloadToFile = File('${appDocDir.path}/download-logo.png');

  try {
    await storage
        .ref('uploads/logo.png')
        .writeToFile(downloadToFile);
  }on firebase_core.FirebaseException catch(E){
    print(E);
  }
}
Future<void> list() async {
  firebase_storage.ListResult result =
  await storage.ref().listAll();

  result.items.forEach((firebase_storage.Reference ref) {
    print('Found file: $ref');
  });

  result.prefixes.forEach((firebase_storage.Reference ref) {
    print('Found directory: $ref');
  });
}

Future<String> downloadURL(String directory) async {
  String downloadURL = await storage
      .ref(directory)
      .getDownloadURL();
  return downloadURL;
}

Future<void> handleTask1() async {
  firebase_storage.UploadTask task = storage
      .ref('uploads/hello-world.txt')
      .putString('Hello World');

  try {
    // Storage tasks function as a Delegating Future so we can await them.
    firebase_storage.TaskSnapshot snapshot = await task;
    print('Uploaded ${snapshot.bytesTransferred} bytes.');
  }on firebase_core.FirebaseException catch (e) {
    // The final snapshot is also available on the task via `.snapshot`,
    // this can include 2 additional states, `TaskState.error` & `TaskState.canceled`
    print(task.snapshot);

    if (e.code == 'permission-denied') {
      print('User does not have permission to upload to this reference.');
    }
    // ...
  }
}

Future<void> handleTask2(String filePath) async {
  File largeFile = File(filePath);

  firebase_storage.UploadTask task = storage
      .ref('uploads/hello-world.txt')
      .putFile(largeFile);

  task.snapshotEvents.listen((firebase_storage.TaskSnapshot snapshot) {
    print('Task state: ${snapshot.state}');
    print(
        'Progress: ${(snapshot.bytesTransferred / snapshot.totalBytes) * 100} %');
  }, onError: (e) {
    // The final snapshot is also available on the task via `.snapshot`,
    // this can include 2 additional states, `TaskState.error` & `TaskState.canceled`
    print(task.snapshot);

    if (e.code == 'permission-denied') {
      print('User does not have permission to upload to this reference.');
    }
  });

  // We can still optionally use the Future alongside the stream.
  try {
    await task;
    print('Upload complete.');
  }
  on firebase_core.FirebaseException catch (e) {
    if (e.code == 'permission-denied') {
      print('User does not have permission to upload to this reference.');
    }
    // ...
  }
}

Future<void> handleTask4(String filePath) async {
  File largeFile = File(filePath);

  firebase_storage.UploadTask task = storage
      .ref('uploads/hello-world.txt')
      .putFile(largeFile);

  // Via a Stream
  task.snapshotEvents.listen((firebase_storage.TaskSnapshot snapshot) {
    // Handle your snapshot events...
  }, onError: (e) {
    // Check if cancelled by checking error code.
    if (e.code == 'canceled') {
      print('The task has been canceled');
    }
    // Or, you can also check for cancellations via the final task.snapshot state.
    if (task.snapshot.state == firebase_storage.TaskState.canceled) {
      print('The task has been canceled');
    }
    // If the task failed for any other reason then state would be:
    print(firebase_storage.TaskState.error);
  });

  // Cancel the upload.
  bool cancelled = await task.cancel();
  print('cancelled? $cancelled');

  // Or a Task Future (or both).
  try {
    await task;
  } on firebase_core.FirebaseException catch (e) {
    // Check if cancelled by checking error code.
    if (e.code == 'canceled') {
      print('The task has been canceled');
    }
    // Or, you can also check for cancellations via the final task.snapshot state.
    if (task.snapshot.state == firebase_storage.TaskState.canceled) {
      print('The task has been canceled');
    }
    // If the task failed for any other reason then state would be:
    print(firebase_storage.TaskState.error);
    // ...
  }
}