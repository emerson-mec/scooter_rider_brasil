import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:scooter_rider_brasil/models/evento_model.dart';

class EventoProvider with ChangeNotifier {
  Firestore _db = Firestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;


  Stream<List<EventoMODEL>> loadEvento(String idClubeDoUser) {
    return _db.collection('evento')
      .where('idClube', whereIn: ['$idClubeDoUser'])
      .snapshots().map((snapshot) => snapshot.documents
      .map((doc) => EventoMODEL.daAPI(doc.data))
      .toList());
  }

  Future<void> addEvento(EventoMODEL evento) async {
    final FirebaseUser currentUser = await _auth.currentUser();
    
    var user = await _db
        .collection('users')
        .document(currentUser.uid)
        .get()
        .then((value) => value);

    await _db.collection('evento').add(evento.paraJson()).then((value) {
      //quando terminar os passos acima, retorne o ID para salvar.
      value.updateData({
        'id': '${value.documentID}',
        'autor': '${currentUser.email}',
        'inscritos': {}, //precisa criar pra não quebrar
        'idClube': '${user['idClube']}', 
      });
    });
  }

  Future<void> updateEvento(EventoMODEL eventoItem) {
    return _db
        .collection('evento')
        .document(eventoItem.id)
        .updateData(eventoItem.paraJson());
  }

  Future<void> removeFeed(String idEvento) {
    return _db.collection('evento').document(idEvento).delete();
  }

  Future<void> inscreverSe(String idEvento , [String resposta, bool garupa, bool amigo]) async {
    FirebaseUser currentUser = await _auth.currentUser().then((value) => value);
    var user = await _db
        .collection('users')
        .document(currentUser.uid)
        .get()
        .then((value) => value);

    await Firestore.instance.collection('evento').document(idEvento).setData({
      'inscritos': {
        "${currentUser.uid}": {
          'nome': '${user["nome"]}' ?? '',
          'id': '${user["id"]}' ?? '',
          'pontoEncontro' : resposta ?? '',
          'garupa' : garupa ?? false,
          'amigo' : amigo ?? false,
          'urlAvatar' : user['urlAvatar'] ?? null,
          'dataInscricao' : Timestamp.now(),
        }
      }
    }, merge: true);
  }

  Future<void> removerInscricao(String idEvento) async {
    FirebaseUser currentUser = await _auth.currentUser().then((value) => value);

    var doc = Firestore.instance.collection('evento').document(idEvento);

    await doc.setData({
      'inscritos': {"${currentUser.uid}": FieldValue.delete()}
    }, merge: true);
  }
}
