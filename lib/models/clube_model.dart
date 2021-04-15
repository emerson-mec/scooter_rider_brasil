import 'package:flutter/cupertino.dart';

class ClubeMODEL {
  final String clube;
  final String descricao;
  final EstadosClube estado;
  final String id;
  final String imagemUrl;

  ClubeMODEL({
    @required this.clube,
    this.descricao,
    @required this.estado,
    @required this.id,
    @required this.imagemUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'clube': clube,
      'descricao': descricao,
      'id': id,
      'imagem_url': imagemUrl ?? 'https://imperialtecnologia.com.br/images/sem_foto.png',
      'estado': estado == EstadosClube.RJ ? 'RJ' :
                estado == EstadosClube.SP ? 'SP' :
                estado == EstadosClube.MG ? 'MG' :
                estado == EstadosClube.SC ? 'SC' :
                estado == EstadosClube.TODOS ? 'TODOS' :
                null,

    };
  }

  factory ClubeMODEL.fromMap(Map<String, dynamic> map) {
    return ClubeMODEL(
      clube: map['clube'],
      descricao: map['descricao'],
      id: map['id'],
      imagemUrl: map['imagem_url'] ?? 'https://imperialtecnologia.com.br/images/sem_foto.png',
      estado: map['estado'] == 'EstadosClube.RJ' ? EstadosClube.RJ : 
              map['estado'] == 'EstadosClube.SP' ? EstadosClube.SP : 
              map['estado'] == 'EstadosClube.MG' ? EstadosClube.MG : 
              map['estado'] == 'EstadosClube.SC' ? EstadosClube.SC : 
              map['estado'] == 'EstadosClube.TODOS' ? EstadosClube.TODOS : 
              null ,
    );
  }

  //PARA TEXT STRING
  String get estadoFeedAsText {
    switch (estado) {
      case EstadosClube.TODOS:
        return 'Todos';
      case EstadosClube.RJ:
        return 'Rio de Janeiro';
      case EstadosClube.SP:
        return 'São Paulo';
      case EstadosClube.MG:
        return 'Minas Gerais';
      case EstadosClube.SC:
        return 'Santa Catarina';
      default:
        return 'Desconhecido';
    }
  }

}

enum EstadosClube { TODOS, MG, RJ, SC, SP }
