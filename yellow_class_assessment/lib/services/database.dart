import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:yellow_class_assessment/model/contact_model.dart';

class DatabaseMethods {
  Future<void> addUserInfo(userData) async {
    FirebaseFirestore.instance
        .collection("users")
        .add(userData)
        .catchError((e) {
      print(e.toString());
    });
  }

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  addContact(Contact employeeData) async {
    await _db.collection("Contact").add(employeeData.toMap());
  }

  Future<List<Contact>> retrieveContact(userId) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await _db
        .collection("Contact")
        .where('user_id', isEqualTo: userId)
        .get();
    return snapshot.docs
        .map((docSnapshot) => Contact.fromDocumentSnapshot(docSnapshot))
        .toList();
  }

  Future<void> deleteContact(String userId) async {
    FirebaseFirestore.instance.collection("Contact").doc(userId).delete();
  }

  getUserInfo(String email) async {
    return FirebaseFirestore.instance
        .collection("users")
        .where("userEmail", isEqualTo: email)
        .get()
        .catchError((e) {
      print(e.toString());
    });
  }
}
