import 'package:chronicle/Modules/shared_preference_handler.dart';
import 'package:chronicle/Modules/universal_module.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

Future<User> signInWithGoogle() async {
  final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
  final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;
  final AuthCredential credential = GoogleAuthProvider.credential(
      idToken: googleSignInAuthentication.idToken,
      accessToken: googleSignInAuthentication.accessToken);

  final UserCredential authResult =
      await _auth.signInWithCredential(credential);
  final User user = authResult.user;

  assert(!user.isAnonymous);
  assert(await user.getIdToken() != null);

  final User currentUser = _auth.currentUser;
  assert(currentUser.uid == user.uid);

  return user;
}

void signOutGoogle() async {
  await googleSignIn.signOut();
}

class FirebaseAuthService {
  String uid;
  String name;
  String userEmail;
  String imageUrl;
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  FirebaseAuthService({FirebaseAuth firebaseAuth, GoogleSignIn googleSignin})
      : _firebaseAuth = firebaseAuth,
        _googleSignIn = googleSignin;

  User _userFromFirebase(User user) {
    if (user == null) {
      return null;
    }
    return user;
  }

  Stream<User> get onAuthStateChanged {
    return _firebaseAuth.authStateChanges().map(_userFromFirebase);
  }

  Future<User> signInAnonymously() async {
    final authResult = await _firebaseAuth.signInAnonymously();
    return _userFromFirebase(authResult.user);
  }

  Future<User> signInWithGoogle() async {
    final googleUser = await _googleSignIn.signIn();
    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final authResult = await _firebaseAuth.signInWithCredential(credential);
    return _userFromFirebase(authResult.user);
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  Future<User> currentUser() async {
    final user = _firebaseAuth.currentUser;
    return _userFromFirebase(user);
  }
}

class Authentication {
  static String uniqueId;
  static String uniqueuserName;
  static String uniqueuserEmail;
  static String uniqueUserimageUrl;
  static Future<FirebaseApp> initializeFirebase({
    BuildContext context,
  }) async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    return firebaseApp;
  }

  static Future<User> signInWithGoogle(BuildContext context,
      GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User user;
    if (kIsWeb) {
      GoogleAuthProvider authProvider = GoogleAuthProvider();

      try {
        final UserCredential userCredential =
            await _auth.signInWithPopup(authProvider);

        user = userCredential.user;
      } catch (e) {
        globalShowInSnackBar(scaffoldMessengerKey, e);
      }
    } else {
      final GoogleSignIn googleSignIn = GoogleSignIn();

      final GoogleSignInAccount googleSignInAccount =
          (await googleSignIn.signIn());

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        try {
          final UserCredential userCredential =
              await auth.signInWithCredential(credential);

          user = userCredential.user;
        } on FirebaseAuthException catch (e) {
          if (e.code == 'account-exists-with-different-credential') {
            ScaffoldMessenger.of(context).showSnackBar(
              Authentication.customSnackBar(
                content:
                    'The account already exists with a different credential.',
              ),
            );
          } else if (e.code == 'invalid-credential') {
            ScaffoldMessenger.of(context).showSnackBar(
              Authentication.customSnackBar(
                content:
                    'Error occurred while accessing credentials. Try again.',
              ),
            );
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            Authentication.customSnackBar(
              content: 'Error occurred using Google Sign-In. Try again.',
            ),
          );
        }
      }
    }
    if (user != null) {
      uniqueId = user.uid;
      uniqueuserName = user.displayName;
      uniqueuserEmail = user.email;
      uniqueUserimageUrl = user.photoURL;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('auth', true);
    }
    return user;
  }

  static SnackBar customSnackBar({String content}) {
    return SnackBar(
      backgroundColor: Colors.black,
      content: Text(
        content,
        style: TextStyle(color: Colors.redAccent, letterSpacing: 0.5),
      ),
    );
  }

  Future<User> registerWithEmailPassword(String email, String password,
      GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey) async {
    await Firebase.initializeApp();
    User user;

    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      user = userCredential.user;

      if (user != null) {
        uniqueId = user.uid;
        uniqueuserEmail = user.email;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        globalShowInSnackBar(
            scaffoldMessengerKey, 'The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        globalShowInSnackBar(
            scaffoldMessengerKey, 'The account already exists for that email.');
      }
    } catch (e) {
      globalShowInSnackBar(scaffoldMessengerKey, e);
    }

    return user;
  }

  Future<User> signInWithEmailPassword(String email, String password,
      GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey) async {
    await Firebase.initializeApp();
    User user;

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = userCredential.user;

      if (user != null) {
        uniqueId = user.uid;
        uniqueuserEmail = user.email;

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('auth', true);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        globalShowInSnackBar(
            scaffoldMessengerKey, 'No user found for that email.');
      } else if (e.code == 'wrong-password') {
        globalShowInSnackBar(scaffoldMessengerKey, 'Wrong password provided.');
      }
    }

    return user;
  }

  Future getUser() async {
    await Firebase.initializeApp();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool authSignedIn = prefs.getBool('auth') ?? false;

    final User user = _auth.currentUser;

    if (authSignedIn == true) {
      if (user != null) {
        uniqueId = user.uid;
        uniqueuserName = user.displayName;
        uniqueuserEmail = user.email;
        uniqueUserimageUrl = user.photoURL;
      }
    }
  }

  static Future<void> signOut({BuildContext context}) async {
    setLastRegister("");
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      if (!kIsWeb) {
        await googleSignIn.signOut();
      }
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        Authentication.customSnackBar(
          content: 'Error signing out. Try again.',
        ),
      );
    }
  }
}
