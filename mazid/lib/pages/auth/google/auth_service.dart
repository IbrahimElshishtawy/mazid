import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<UserModel?> signUp(
    String name,
    String email,
    String password,
    String role,
  ) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      UserModel user = UserModel(
        id: userCredential.user!.uid,
        name: name,
        email: email,
        role: role,
      );

      await _db.collection('users').doc(user.id).set(user.toJson());
      return user;
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModel?> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      DocumentSnapshot doc = await _db
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      return UserModel.fromJson(doc.data() as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModel?> getUserData(String userId) async {
    try {
      DocumentSnapshot doc = await _db.collection('users').doc(userId).get();

      if (doc.exists) {
        return UserModel.fromJson(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      throw Exception("Failed to fetch user data: $e");
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn.instance;
      final GoogleSignInAccount account = await googleSignIn.authenticate();

      final GoogleSignInAuthentication auth = account.authentication;
      final String? accessToken = auth.accessToken;
      final String? idToken = auth.idToken;

      if (accessToken != null && idToken != null) {
        final credential = GoogleAuthProvider.credential(
          idToken: idToken,
          accessToken: accessToken,
        );

        await FirebaseAuth.instance.signInWithCredential(credential);
        if (kDebugMode) {
          print('تم تسجيل الدخول بنجاح');
        }
      } else {
        if (kDebugMode) {
          print('فشل في الحصول على الرموز المميزة');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('خطأ: $e');
      }
    }
  }
}

extension on GoogleSignInAuthentication {
  String? get accessToken => null;
}
