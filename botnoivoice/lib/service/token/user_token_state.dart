import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Define the state for EmailToken (Assuming this file is named user_token_state.dart or similar)
class UserTokenState {
  // Existing state fields...
  final String? userID;
  final String? userName;
  final String? jwtToken;
  final String? remainingCredits;
  // These are the fields we want to access:
  final int? remainingNormalCredits;
  final int? remainingMonthlyPoints;
  final String? credentialsToken;
  final bool isSubscription;

  UserTokenState({
    this.userID,
    this.userName,
    this.jwtToken,
    this.remainingCredits,
    this.remainingNormalCredits,
    this.remainingMonthlyPoints,
    this.credentialsToken,
    this.isSubscription = false,
  });

  /// Copy method for creating a new state instance.
  UserTokenState copyWith({
    String? userID,
    String? userName,
    String? jwtToken,
    String? remainingCredits,
    int? remainingNormalCredits,
    int? remainingMonthlyPoints,
    String? credentialsToken,
    bool? isSubscription,
  }) {
    return UserTokenState(
      userID: userID ?? this.userID,
      userName: userName ?? this.userName,
      jwtToken: jwtToken ?? this.jwtToken,
      remainingCredits: remainingCredits ?? this.remainingCredits,
      remainingNormalCredits: remainingNormalCredits ?? this.remainingNormalCredits,
      remainingMonthlyPoints: remainingMonthlyPoints ?? this.remainingMonthlyPoints,
      credentialsToken: credentialsToken ?? this.credentialsToken,
      isSubscription: isSubscription ?? this.isSubscription,
    );
  }
}

/// The Notifier class replaces the ChangeNotifier (EmailToken).
/// It manages and updates the UserTokenState.
class UserTokenNotifier extends Notifier<UserTokenState> {
  // Initialize the state with the default UserTokenState
  @override
  UserTokenState build() {
    return UserTokenState(); // Initial state, likely loaded from a secure storage in a real app
  }

  /// Public method to update all tokens/credits at once.
  void updateTokenState(UserTokenState newState) {
    // Replace the entire state with the new state
    state = newState;
  }

  /// Example method to update only the credits/points after a purchase/load
  void updateCredits({required int normalCredits, required int monthlyPoints}) {
    state = state.copyWith(
      remainingNormalCredits: normalCredits,
      remainingMonthlyPoints: monthlyPoints,
    );
  }
}

/// Global provider to expose the UserTokenNotifier instance and its state.
final userTokenProvider = NotifierProvider<UserTokenNotifier, UserTokenState>(
  () => UserTokenNotifier(),
);

