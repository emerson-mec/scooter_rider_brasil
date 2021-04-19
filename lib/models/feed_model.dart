import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FeedMODEL with ChangeNotifier {
  final String idFeed;
  final String titulo;
  final String subtitulo;
  final String imagemPrincipal;
  final String conteudo;
  final TipoFeed tipoFeed;
  final DateTime dataPublicacao;
  final EstadosFeed estado;
  final String autor;
  //int curtidas;
  //bool favorito;
  //bool like;
  

  FeedMODEL({
    @required this.idFeed,
    this.titulo,
    this.subtitulo,
    this.conteudo,
    this.tipoFeed,
    this.imagemPrincipal,
    this.dataPublicacao,
    this.estado = EstadosFeed.TODOS,
    this.autor,
    //this.curtidas = 0,
    //this.favorito = false,
    //this.like = false,
  });

  

  Map<String, dynamic> paraMap() {
    return {
      'idFeed': idFeed,
      'titulo': titulo,
      'subtitulo': subtitulo,
      'imagemPrincipal': imagemPrincipal,
      'conteudo': conteudo,
      'tipoFeed': tipoFeed.toString(),
      'dataPublicacao': dataPublicacao.toIso8601String(),
      'estado': estado.toString(),
      'autor': autor,
      //'curtidas': curtidas,
      //'favorito': favorito,
      //'like': like,
    };
  }

  factory FeedMODEL.daAPI(Map<String, dynamic> feed) {
    return FeedMODEL(
      idFeed: feed['idFeed'],
      titulo: feed['titulo'],
      subtitulo: feed['subtitulo'] ,
      imagemPrincipal: feed['imagemPrincipal'] ,
      conteudo: feed['conteudo'] ,
      tipoFeed: feed['tipoFeed'] == 'TipoFeed.review' ? TipoFeed.review : 
                feed['tipoFeed'] == 'TipoFeed.dica' ? TipoFeed.dica : 
                feed['tipoFeed'] == 'TipoFeed.patrocinado' ? TipoFeed.patrocinado : 
                feed['tipoFeed'] == 'TipoFeed.evento' ? TipoFeed.evento : 
                feed['tipoFeed'] == 'TipoFeed.noticia' ? TipoFeed.noticia : 
                feed['tipoFeed'] == 'TipoFeed.evento' ? TipoFeed.evento
                : null ,
      dataPublicacao: DateTime.parse(feed['dataPublicacao']),
      estado: feed['estado'] == 'EstadosFeed.RJ' ? EstadosFeed.RJ : 
              feed['estado'] == 'EstadosFeed.SP' ? EstadosFeed.SP : 
              feed['estado'] == 'EstadosFeed.MG' ? EstadosFeed.MG : 
              feed['estado'] == 'EstadosFeed.SC' ? EstadosFeed.SC : 
              feed['estado'] == 'EstadosFeed.TODOS' ? EstadosFeed.TODOS : 
              null ,
      autor: feed['autor'],
      //curtidas: feed['curtidas'] ,
      //favorito: feed['favorito'] ,
      //like: feed['like'] ,
    );
  }

  //String toJson() => json.encode(paraMap());
  //factory FeedMODEL.fromJson(String source) => FeedMODEL.daAPI(json.decode(source));
  
  dataPublicacaoAsFormat() {
    return DateFormat('dd/MM/yyyy - hh:mm').format(dataPublicacao);
  }

  String get tipoFeedAsText {
    switch (tipoFeed) {
      case TipoFeed.noticia:
        return 'Notícia';
      case TipoFeed.patrocinado:
        return 'Patrocínado';
      case TipoFeed.dica:
        return 'Dica';
      case TipoFeed.review:
        return 'Review';
      case TipoFeed.evento:
        return 'Evento';
      default:
        return 'Desconhecido';
    }
  }

  String get estadoFeedAsText {
    switch (estado) {
      case EstadosFeed.TODOS:
        return 'Todos';
      case EstadosFeed.RJ:
        return 'Rio de Janeiro';
      case EstadosFeed.SP:
        return 'São Paulo';
      case EstadosFeed.MG:
        return 'Minas Gerais';
      case EstadosFeed.SC:
        return 'Santa Catarina';
      default:
        return 'Desconhecido';
    }
  }
  
}

enum TipoFeed { noticia, evento, patrocinado, review, dica }

enum EstadosFeed { TODOS, MG, RJ, SC, SP }
