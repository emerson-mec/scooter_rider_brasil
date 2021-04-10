import 'package:flutter/material.dart';

class EventoMODEL {
  final String id;
  final String titulo;
  final String subtitulo;
  final String imagemPrincipal;
  final String conteudo;
  final DateTime dataEvento;
  final DateTime dataPublicacao;

  EventoMODEL({
    this.id,
    @required this.titulo,
    this.subtitulo,
    this.conteudo,
    this.imagemPrincipal,
    this.dataEvento, 
    this.dataPublicacao,
  });

  Map<String, dynamic> paraJson() {
    return {
      'id': id,
      'titulo': titulo,
      'subtitulo': subtitulo,
      'imagemPrincipal': imagemPrincipal,
      'conteudo': conteudo,
      'dataEvento': dataEvento.toIso8601String(),
      'dataPublicacao': dataPublicacao.toIso8601String(),
    };
  }

  factory EventoMODEL.daAPI(Map<String, dynamic> map) {
    return EventoMODEL(
      id: map['id'],
      titulo: map['titulo'],
      subtitulo: map['subtitulo'],
      imagemPrincipal: map['imagemPrincipal'],
      conteudo: map['conteudo'],
      dataEvento: DateTime.parse(map['dataEvento']),
      dataPublicacao: DateTime.parse(map['dataPublicacao']),
    );
  }


  //String toJson() => json.encode(paraJson());

  //factory EventoMODEL.fromJson(String source) => EventoMODEL.daAPI(json.decode(source));
}

