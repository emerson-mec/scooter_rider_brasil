import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  final _auth = FirebaseAuth.instance.currentUser;
  final _colecao = FirebaseFirestore.instance;

  Stream<DocumentSnapshot> userColecao() {
   return _colecao.collection('users').doc(_auth.uid).snapshots();
     //colecao.map((event) => print(event['estado']));
  }

}
