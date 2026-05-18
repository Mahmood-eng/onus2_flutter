import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';

enum AuthStatus {
  uninitialized,
  authenticating,
  authenticated,
  unauthenticated,
  error,
}

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  AuthStatus _status = AuthStatus.uninitialized;
  UserModel? _currentUser;
  String? errorMessage;

  AuthProvider() {
    _auth.authStateChanges().listen(_onAuthStateChanged);
  }

  AuthStatus get status => _status;
  UserModel? get currentUser => _currentUser;
  bool get isLoading => _status == AuthStatus.authenticating;
  String get userName => currentUser?.simpleName ?? 'Guest';

  Future<void> _onAuthStateChanged(User? firebaseUser) async {
    if (firebaseUser == null) {
      _status = AuthStatus.unauthenticated;
      _currentUser = null;
    } else {
      _currentUser = UserModel(
        uid: firebaseUser.uid,
        email: firebaseUser.email ?? '',
        displayName: firebaseUser.displayName,
      );
      _status = AuthStatus.authenticated;
    }
    errorMessage = null;
    notifyListeners();
  }

  Future<void> loginWithEmailPassword(String email, String password) async {
    _status = AuthStatus.authenticating;
    errorMessage = null;
    notifyListeners();

    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      errorMessage = null;
    } on FirebaseAuthException catch (e) {
      _status = AuthStatus.unauthenticated;
      errorMessage = _translateErrorCode(e.code);
    } catch (_) {
      _status = AuthStatus.unauthenticated;
      errorMessage = 'An error occurred during login. Please try again.';
    }

    notifyListeners();
  }

  Future<void> registerWithEmailPassword(
    String name,
    String email,
    String password,
  ) async {
    _status = AuthStatus.authenticating;
    errorMessage = null;
    notifyListeners();

    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final firebaseUser = credential.user;
      if (firebaseUser != null) {
        await firebaseUser.updateDisplayName(name.trim());
        await firebaseUser.reload();
        _currentUser = UserModel(
          uid: firebaseUser.uid,
          email: firebaseUser.email ?? '',
          displayName: firebaseUser.displayName ?? name.trim(),
        );
        _status = AuthStatus.authenticated;
      } else {
        _status = AuthStatus.unauthenticated;
        errorMessage = 'Could not create account. Please try again.';
      }
    } on FirebaseAuthException catch (e) {
      _status = AuthStatus.unauthenticated;
      errorMessage = _translateErrorCode(e.code);
    } catch (_) {
      _status = AuthStatus.unauthenticated;
      errorMessage = 'An error occurred during signup. Please try again.';
    }

    notifyListeners();
  }

  Future<void> logout() async {
    await _auth.signOut();
    _status = AuthStatus.unauthenticated;
    _currentUser = null;
    notifyListeners();
  }

  String _translateErrorCode(String code) {
    switch (code) {
      case 'invalid-email':
        return 'Invalid email address.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'user-not-found':
        return 'Account not found. Please sign up first.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'email-already-in-use':
        return 'This email is already in use.';
      case 'weak-password':
        return 'Password is too weak.';
      case 'operation-not-allowed':
        return 'Operation not allowed.';
      default:
        return 'An error occurred. Please check your data and try again.';
    }
  }
}
