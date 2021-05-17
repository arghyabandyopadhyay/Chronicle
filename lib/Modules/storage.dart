import 'dart:io';
import 'package:chronicle/Models/videoIndexModel.dart';
import 'package:chronicle/Modules/universalModule.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'database.dart';
firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;

void deleteFromStorageModule(VideoIndexModel video,GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey) {
  try {
    firebase_storage.Reference ref = storage.ref().child(video.directory);
    ref.delete();
    ref = storage.ref().child(video.directory.replaceFirst("/", "/thumbnail_",video.directory.lastIndexOf("/")-1));
    ref.delete();
  }on firebase_core.FirebaseException catch (error) {
    globalShowInSnackBar(scaffoldMessengerKey,error.message);
  }
  deleteDatabaseNode(video.id);
}

Future<void> downloadFile(GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey) async {
  Directory appDocDir = await getApplicationDocumentsDirectory();
  File downloadToFile = File('${appDocDir.path}/download-logo.png');

  try {
    await storage
        .ref('uploads/logo.png')
        .writeToFile(downloadToFile);
  }on firebase_core.FirebaseException catch(E){
    globalShowInSnackBar(scaffoldMessengerKey,E.message);
  }
}
Future<void> list(GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey) async {
  firebase_storage.ListResult result =
  await storage.ref().listAll();

  result.items.forEach((firebase_storage.Reference ref) {
    globalShowInSnackBar(scaffoldMessengerKey,'Found file: $ref');
  });

  result.prefixes.forEach((firebase_storage.Reference ref) {
    globalShowInSnackBar(scaffoldMessengerKey,'Found directory: $ref');
  });
}

Future<String> downloadURL(String directory) async {
  String downloadURL = await storage
      .ref(directory)
      .getDownloadURL();
  return downloadURL;
}

Future<void> handleTask1(GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey) async {
  firebase_storage.UploadTask task = storage
      .ref('uploads/hello-world.txt')
      .putString('Hello World');

  try {
    // Storage tasks function as a Delegating Future so we can await them.
    firebase_storage.TaskSnapshot snapshot = await task;
    globalShowInSnackBar(scaffoldMessengerKey,'Uploaded ${snapshot.bytesTransferred} bytes.');
  }on firebase_core.FirebaseException catch (e) {
    // The final snapshot is also available on the task via `.snapshot`,
    // this can include 2 additional states, `TaskState.error` & `TaskState.canceled`
    globalShowInSnackBar(scaffoldMessengerKey,e.message);

    if (e.code == 'permission-denied') {
      globalShowInSnackBar(scaffoldMessengerKey,'User does not have permission to upload to this reference.');
    }
    // ...
  }
}

Future<void> handleTask2(String filePath,GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey) async {
  File largeFile = File(filePath);

  firebase_storage.UploadTask task = storage
      .ref('uploads/hello-world.txt')
      .putFile(largeFile);

  task.snapshotEvents.listen((firebase_storage.TaskSnapshot snapshot) {
    globalShowInSnackBar(scaffoldMessengerKey,'Task state: ${snapshot.state}');
    globalShowInSnackBar(scaffoldMessengerKey,
        'Progress: ${(snapshot.bytesTransferred / snapshot.totalBytes) * 100} %');
  }, onError: (e) {
    // The final snapshot is also available on the task via `.snapshot`,
    // this can include 2 additional states, `TaskState.error` & `TaskState.canceled`
    globalShowInSnackBar(scaffoldMessengerKey,e);

    if (e.code == 'permission-denied') {
      globalShowInSnackBar(scaffoldMessengerKey,'User does not have permission to upload to this reference.');
    }
  });

  // We can still optionally use the Future alongside the stream.
  try {
    await task;
    globalShowInSnackBar(scaffoldMessengerKey,'Upload complete.');
  }
  on firebase_core.FirebaseException catch (e) {
    if (e.code == 'permission-denied') {
      globalShowInSnackBar(scaffoldMessengerKey,'User does not have permission to upload to this reference.');
    }
    // ...
  }
}

Future<void> handleTask4(String filePath,GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey) async {
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
      globalShowInSnackBar(scaffoldMessengerKey,'The task has been canceled');
    }
    // Or, you can also check for cancellations via the final task.snapshot state.
    if (task.snapshot.state == firebase_storage.TaskState.canceled) {
      globalShowInSnackBar(scaffoldMessengerKey,'The task has been canceled');
    }
    // If the task failed for any other reason then state would be:
    globalShowInSnackBar(scaffoldMessengerKey,firebase_storage.TaskState.error.toString());
  });

  // Cancel the upload.
  bool cancelled = await task.cancel();
  globalShowInSnackBar(scaffoldMessengerKey,'cancelled? $cancelled');

  // Or a Task Future (or both).
  try {
    await task;
  } on firebase_core.FirebaseException catch (e) {
    // Check if cancelled by checking error code.
    if (e.code == 'canceled') {
      globalShowInSnackBar(scaffoldMessengerKey,'The task has been canceled');
    }
    // Or, you can also check for cancellations via the final task.snapshot state.
    if (task.snapshot.state == firebase_storage.TaskState.canceled) {
      globalShowInSnackBar(scaffoldMessengerKey,'The task has been canceled');
    }
    // If the task failed for any other reason then state would be:
    globalShowInSnackBar(scaffoldMessengerKey,firebase_storage.TaskState.error.toString());
    // ...
  }
}