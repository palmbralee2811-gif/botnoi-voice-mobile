import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

/// Base State Class for Firebase Authentication Providers
class UserLoginBaseState {
  final User? user;
  final bool isLoggedIn;
  final String? errorMessage;

  UserLoginBaseState({this.user, this.isLoggedIn = false, this.errorMessage});
}

/// Base Notifier Class for Firebase Authentication Providers
abstract class UserLoginBaseNotifier<T extends UserLoginBaseState>
    extends StateNotifier<T> {
  final String _providerId;
  final Logger _logger = Logger();
  StreamSubscription<User?>? _authStateSubscription;

  UserLoginBaseNotifier(super.initialState, this._providerId) {
    _initializeAuthListener();
  }

  /// Initialize the Firebase Auth listener
  void _initializeAuthListener() {
    _authStateSubscription =
        FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        // Handle logout scenario
        if (state.isLoggedIn) {
          _logger.d("Logout detected for $_providerId");
          updateState(user: null, isLoggedIn: false, errorMessage: null);
        }
        return;
      }

      // Check if the current user is associated with this specific provider
      final isLinkedToProvider = user.providerData
          .any((userInfo) => userInfo.providerId == _providerId);

      if (isLinkedToProvider) {
        _logger.d("$_providerId Firebase User UID: ${user.uid}");
        updateState(user: user, isLoggedIn: true, errorMessage: null);
      }
    }, onError: (error) {
      _logger.e("Auth state change error: $error");
    });
  }

  /// Abstract method to update state, must be implemented by subclasses.
  /// This must be public to be overridden across different library files.
  void updateState({
    User? user,
    bool? isLoggedIn,
    String? errorMessage,
  });

  /// Check if the user is authenticated with this specific provider
  bool get isAuthenticated {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return false;

    final isLinked = currentUser.providerData
        .any((userInfo) => userInfo.providerId == _providerId);

    return isLinked && state.isLoggedIn;
  }

  @override
  void dispose() {
    _authStateSubscription?.cancel();
    super.dispose();
  }
}