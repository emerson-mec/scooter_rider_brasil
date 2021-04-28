import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:scooter_rider_brasil/models/evento_model.dart';

class EventoProvider with ChangeNotifier {
  final _db = FirebaseFirestore.instance;

  Stream<List<EventoMODEL>> loadEvento(String idClubeDoUser) {
    return _db
        .collection('evento')
        .where('idClube', whereIn: ['$idClubeDoUser'])
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => EventoMODEL.daAPI(doc.data())).toList());
  }

  Future<void> addEvento(EventoMODEL evento) async {
    final User _user = FirebaseAuth.instance.currentUser;
    var user = await _db
        .collection('users')
        .doc(_user.uid)
        .get()
        .then((value) => value);

    await _db.collection('evento').add(evento.paraJson()).then((value) {
      //quando terminar os passos acima, retorne o ID para salvar.
      value.update({
        'id': '${value.id}',
        'autor': '${_user.email}',
        'inscritos': {}, //precisa criar pra não quebrar
        'idClube': '${user.get('idClube')}',
      });
    });
  }

  Future<void> updateEvento(EventoMODEL eventoItem) async {
    return await _db
        .collection('evento')
        .doc(eventoItem.id)
        .update(eventoItem.paraJson());
  }

  Future<void> removeFeed(String idEvento) {
    return _db.collection('evento').doc(idEvento).delete();
  }

  Future<void> inscreverSe(String idEvento,[String resposta, bool garupa, bool amigo]) async {
    final User _user = FirebaseAuth.instance.currentUser;
    var user = await _db
        .collection('users')
        .doc(_user.uid)
        .get()
        .then((value) => value);

    await FirebaseFirestore.instance.collection('evento').doc(idEvento).set({
      'inscritos': {
        "${_user.uid}": {
          'nome': '${user.get('nome')}' ?? '',
          'id': '${_user.uid}' ?? '',
          'pontoEncontro': resposta ?? '',
          'garupa': garupa ?? false,
          'amigo': amigo ?? false,
          'urlAvatar': user.get('urlAvatar') ?? null,
          'dataInscricao': Timestamp.now(),
        }
      },
    }, SetOptions(merge: true));
  }

  Future<void> removerInscricao(String idEvento) async {
    final User _user = FirebaseAuth.instance.currentUser;
    var doc = FirebaseFirestore.instance.collection('evento').doc(idEvento);

    await doc.set(
      {
        'inscritos': {"${_user.uid}": FieldValue.delete()}
      },
      SetOptions(merge: true),
    );
  }
}
