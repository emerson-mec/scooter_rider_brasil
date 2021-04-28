import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  
  final _db = FirebaseFirestore.instance;
  
  Stream<DocumentSnapshot> userColecao() {
    final User _auth = FirebaseAuth.instance.currentUser;
    return _db.collection('users').doc(_auth.uid).snapshots();
  }

}
