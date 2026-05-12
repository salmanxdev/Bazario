import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/app_user.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<AppUser?> getCurrentUser() async {
    final user = _auth.currentUser;
    if (user != null) {
      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists) {
        return AppUser.fromMap(doc.data()!, doc.id);
      }
    }
    return null;
  }

  Future<AppUser?> login(String email, String password) async {
    final credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
    if (credential.user != null) {
       final doc = await _firestore.collection('users').doc(credential.user!.uid).get();
       if (doc.exists) {
         return AppUser.fromMap(doc.data()!, doc.id);
       }
    }
    return null;
  }

  Future<AppUser?> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String role,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    if (credential.user != null) {
      final appUser = AppUser(
        id: credential.user!.uid,
        email: email,
        firstName: firstName,
        lastName: lastName,
        role: role,
      );
      
      await _firestore.collection('users').doc(appUser.id).set(appUser.toMap());
      return appUser;
    }
    return null;
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  Future<void> updateProfileImage(String imageUrl) async {
    final user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).update({
        'profileImageUrl': imageUrl,
      });
    }
  }
}
