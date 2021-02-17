import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:scooter_rider_brasil/models/evento_model.dart';
import 'package:scooter_rider_brasil/providers/auth.dart';
import 'package:scooter_rider_brasil/utils/constantes.dart';

class EventoProvider with ChangeNotifier {
  List<EventoMODEL> _listEventos = [];
  List<Inscricoes> _listInscritos = [];

  String _token;
  EventoProvider([this._token, this._listEventos = const []]);

  List<EventoMODEL> get itemEvento => [..._listEventos.reversed.toList()];
  List<Inscricoes> get listInscritos => [..._listInscritos.reversed.toList()];

  int itemCount() => _listEventos.length;

  Future<void> deletar(EventoMODEL itemRaw) async {
    final int index = _listEventos.indexWhere((prod) => prod.id == itemRaw.id);

    if (index >= 0) {
      final itemFeed = _listEventos[index];
      _listEventos.remove(itemFeed); //o mesmo que: _itemFeed[index]
      notifyListeners();

      final response = await http.delete(
          '${Constantes.BASE_URL_API}/evento/${itemFeed.id}.json?auth=$_token');

      if (response.statusCode >= 400) {
        _listEventos.insert(index, itemFeed);
        notifyListeners();

        throw HttpException(
            'Erro ${response.statusCode} - Erro na exclusão do produto.');
      }
    }
  }

  Future<void> loadEvento() async {
    final response =
        await http.get('${Constantes.BASE_URL_API}/evento.json?auth=$_token');

    Map<String, dynamic> data = json.decode(response.body);
    _listEventos.clear();
    if (data != null) {
      data.forEach((eventoID, eventoData) {
        _listEventos.add(
          EventoMODEL(
            id: eventoID,
            titulo: eventoData['titulo'],
            subtitulo: eventoData['subtitulo'],
            imagemPrincipal: eventoData['imagemPrincipal'],
            conteudo: eventoData['conteudo'],
            dataEvento: DateTime.parse(eventoData['dataEvento']),
          ),
        );
        notifyListeners();
      });
    } else {
      return Future.value();
    }
  }

  Future<void> addEvento(EventoMODEL novoEvento) async {
    //final date = DateTime.now();
    final response = await http.post(
      '${Constantes.BASE_URL_API}/evento.json?auth=$_token',
      body: json.encode({
        'titulo': novoEvento.titulo,
        'subtitulo': novoEvento.subtitulo,
        'imagemPrincipal': novoEvento.imagemPrincipal,
        'conteudo': novoEvento.conteudo,
        'dataEvento': novoEvento.dataEvento.toIso8601String(),
      }),
    );

    _listEventos.add(
      EventoMODEL(
        id: json.decode(response.body)['name'],
        titulo: novoEvento.titulo,
        subtitulo: novoEvento.subtitulo,
        imagemPrincipal: novoEvento.imagemPrincipal,
        conteudo: novoEvento.conteudo,
        dataEvento: novoEvento.dataEvento,
      ),
    );
    notifyListeners();
  }

  Future<void> updateItemEvento(EventoMODEL itemEvento) async {
    if (itemEvento == null || itemEvento.id == null) {
      return;
    }

    final int index =
        _listEventos.indexWhere((item) => item.id == itemEvento.id);

    if (index >= 0) {
      //
      await http.patch(
        '${Constantes.BASE_URL_API}/evento/${itemEvento.id}.json?auth=$_token',
        body: json.encode(
          {
            'titulo': itemEvento.titulo,
            'subtitulo': itemEvento.subtitulo,
            'imagemPrincipal': itemEvento.imagemPrincipal,
            'conteudo': itemEvento.conteudo,
            'dataEvento': itemEvento.dataEvento.toIso8601String(),
          },
        ),
      );
      _listEventos[index] = itemEvento;
      notifyListeners();
    }
  }

  Future<void> addInscrito(EventoMODEL itemEvento, Auth user, String vaiComo) async {
    final response = await http.put('${Constantes.BASE_URL_API}/evento/${itemEvento.id}/inscritos/${user.userId}.json?auth=$_token',
      body: json.encode({
        'email': user.email,
        'isInscrito' : true,
        'idUser': user.userId,
        'eventoID' : itemEvento.id,
        'vaiComo' : vaiComo,
      }),
    );
    _listInscritos.clear();
    if(response.statusCode == 200){
      _listInscritos.add(
      Inscricoes(
        email: user.email,
        idUser: user.userId,
        isInscrito: true,
        eventoID: itemEvento.id,
        vaiComo : vaiComo,
      ),
    );
    }

    notifyListeners();
  }

  Future loadInscritos(String eventoID) async {
    final response = await http.get('${Constantes.BASE_URL_API}/evento/$eventoID/inscritos/.json?auth=$_token');

    Map<String, dynamic> data = json.decode(response.body);
    _listInscritos.clear();
       

    if (data != null) {
      data.forEach((inscricaoID, eventoData) {
        _listInscritos.add(
          Inscricoes(
            idUser: inscricaoID,
            email: eventoData['email'],
            isInscrito: eventoData['isInscrito'],
            eventoID: eventoData['eventoID'],
            vaiComo: eventoData['vaiComo'],
          ),
        );
        notifyListeners();
      });
    } else {
      return Future.value();
    }
  }

  Future<void> removerInscricao(EventoMODEL evento, Auth user) async {
    final int index = _listInscritos.indexWhere((item) => item.idUser == user.userId);

    if (index >= 0) {
      final itemFeed = _listInscritos[index];
      _listInscritos.remove(itemFeed); //o mesmo que: _itemFeed[index]
      notifyListeners();
      final response = await http.delete('${Constantes.BASE_URL_API}/evento/${evento.id}/inscritos/${user.userId}.json?auth=$_token');

      if (response.statusCode >= 400) {
        _listInscritos.insert(index, itemFeed);
        notifyListeners();

        throw HttpException(
            'Erro ${response.statusCode} - Erro na exclusão do produto.');
      }
    }
  }

}

class Inscricoes {
  String email;
  String idUser;
  bool isInscrito;
  String eventoID;
  String vaiComo;
  Inscricoes({this.email, this.idUser, this.isInscrito, this.eventoID, this.vaiComo});
}
