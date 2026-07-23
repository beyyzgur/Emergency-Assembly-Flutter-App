import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

final authServiceProvider = Provider((ref) => AuthService());

enum AuthFailure {
  unexpected,
  userNotFound,
  wrongCredentials,
  invalidEmail,
  userDisabled,
  tooManyRequests,
  network,
  emailInUse,
  weakPassword,
  emailPasswordDisabled,
}

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  Future<void> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();

    final GoogleSignInAuthentication googleAuth = googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken!,
    );

    await _auth.signInWithCredential(credential);
  }

  Future<AuthFailure?> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null;
    } on FirebaseAuthException catch (e) {
      return _signInFailure(e);
    } catch (_) {
      return AuthFailure.unexpected;
    }
  }

  Future<AuthFailure?> registerWithEmail(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          return AuthFailure.emailInUse;
        case 'invalid-email':
          return AuthFailure.invalidEmail;
        case 'weak-password':
          return AuthFailure.weakPassword;
        case 'operation-not-allowed':
          return AuthFailure.emailPasswordDisabled;
        case 'network-request-failed':
          return AuthFailure.network;
        default:
          return AuthFailure.unexpected;
      }
    } catch (_) {
      return AuthFailure.unexpected;
    }
  }

  AuthFailure _signInFailure(FirebaseAuthException error) {
    switch (error.code) {
      case 'user-not-found':
        return AuthFailure.userNotFound;
      case 'wrong-password':
      case 'invalid-credential':
        return AuthFailure.wrongCredentials;
      case 'invalid-email':
        return AuthFailure.invalidEmail;
      case 'user-disabled':
        return AuthFailure.userDisabled;
      case 'too-many-requests':
        return AuthFailure.tooManyRequests;
      case 'network-request-failed':
        return AuthFailure.network;
      default:
        return AuthFailure.unexpected;
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}
