import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  final _auth = FirebaseAuth.instance.currentUser;
  final _colecao = FirebaseFirestore.instance;
  String estadoUserr;

  Stream<DocumentSnapshot> userColecao() {
    return _colecao.collection('users').doc(_auth.uid).snapshots();
  }

  Future<String> estadoUser() async {
    String estado = await _colecao
        .collection('users')
        .doc(_auth.uid)
        .get()
        .then((event) async => await event.get('estado'));

    return estado;
  }
}
