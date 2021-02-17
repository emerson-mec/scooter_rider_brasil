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
  int curtidas;
  bool favorito;
  bool like;
  final String estado;

  FeedMODEL({
    this.idFeed,
    @required this.titulo,
    this.subtitulo,
    this.conteudo,
    this.tipoFeed,
    this.imagemPrincipal,
    this.dataPublicacao,
    this.curtidas = 0,
    this.favorito = false,
    this.estado,
    this.like = false,
  });

  dataPublicacaoAsFormat(dataPublicacao) {
    return Text(
      DateFormat('dd/MM/yyyy - hh:mm').format(dataPublicacao),
    );
  }

  String get tipoFeedAsText {
    switch (tipoFeed) {
      case TipoFeed.noticia:
        return 'Notícia';
      case TipoFeed.evento:
        return 'Evento';
      case TipoFeed.patrocinado:
        return 'Patrocínado';
      case TipoFeed.review:
        return 'Review';
      case TipoFeed.dica:
        return 'Dica';
      default:
        return 'Desconhecido';
    }
  }
}

enum TipoFeed { noticia, evento, patrocinado, review, dica }
