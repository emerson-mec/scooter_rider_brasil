import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  final _auth = FirebaseAuth.instance;
  final _colecao = Firestore.instance;


  String estado  ;

  Future<String> nomeUser() async {
    var uid = await _auth.currentUser().then((value) => value.uid);
    var user = _colecao.collection('users').document(uid).get();
    String nome = await user.then((value) => value['nome']);
    return nome;
  }


  estadoUser() async {
  var uid = await _auth.currentUser().then((value) => value.uid);
    
  String estado = await _colecao.collection('users')
      .document(uid)
      .get()
      .then((event) => event.data['estado']);
      
    return estado;
  }


  Future<String> emailUser() async {
    var uid = await _auth.currentUser().then((value) => value.uid);
    var user = _colecao.collection('users').document(uid).get();
    String email = await user.then((value) => value['email']);
    return email;
  }
}
