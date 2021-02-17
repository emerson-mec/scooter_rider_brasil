import 'package:flutter/material.dart';

class EventoMODEL with ChangeNotifier {
  final String id;
  final String titulo;
  final String subtitulo;
  final String imagemPrincipal;
  final String conteudo;
  final DateTime dataEvento;

  EventoMODEL({
    this.id,
    @required this.titulo,
    this.subtitulo,
    this.conteudo,
    this.imagemPrincipal,
    this.dataEvento, 
  });

  

   
}

