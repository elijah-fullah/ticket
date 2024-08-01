import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../model/user_model.dart';

class UserRepository {
  Future<DocumentSnapshot> getUserDetails(String userId) async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    String currentMonth = DateFormat('MMMM yyyy').format(DateTime.now());
    return FirebaseFirestore.instance
        .collection('users')
        .doc(currentMonth)
        .collection('userList')
        .doc(uid)
        .get();
  }
}

class AuthController extends GetxController {
  var myUser = UserModel().obs;

  getUserData() {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    String currentMonth = DateFormat('MMMM yyyy').format(DateTime.now());
    FirebaseFirestore.instance
        .collection('users')
        .doc(currentMonth)
        .collection('userList')
        .doc(uid)
        .snapshots()
        .listen((event) {
      if (event.exists) {
        myUser.value = UserModel.fromJson(event.data()!);
      }
    });
  }
}