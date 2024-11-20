import 'package:firebase_auth/firebase_auth.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

//TODO: Refactor โค้ดส่วนนี้ให้เป็น provider แยก และ จัดการพวก getUser ซ้ำๆ ในหลายไฟล์ ให้อยู่รวมในไฟล์เดียว
final FirebaseAuth auth = FirebaseAuth.instance;

String getFirebaseUserId() {
  final User? user = auth.currentUser;
  return user?.uid ?? "anonymous_user";
}

Future<void> configureRevenueCat() async {
  final userId = getFirebaseUserId();

  await Purchases.configure(
    PurchasesConfiguration("appl_hHLMxSjhEDXVqqqazXdGQsozLmb")
      ..appUserID = userId,
  );
}