import 'package:firebase_auth/firebase_auth.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

final FirebaseAuth auth = FirebaseAuth.instance;

String? getFirebaseUserId() {
  final User? user = auth.currentUser;
  return user?.uid;
}

Future<void> configureRevenueCat() async {
  final userId = getFirebaseUserId();

  await Purchases.configure(
    PurchasesConfiguration("appl_hHLMxSjhEDXVqqqazXdGQsozLmb")
      ..appUserID = userId,
  );
}
