import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:scooter_rider_brasil/utils/constantes.dart';
import '../exceptions/http_exceptions.dart';
import '../models/feed_model.dart';

class FeedProvider with ChangeNotifier {
  final String _baseUrl = "${Constantes.BASE_URL_API}/feed";
  List<FeedMODEL> _itemFeed = [];
  String _token; //preciso disso para passar para os links abaixo ".json?auth=$_token"
  String _userId;

  FeedProvider([this._token,this._userId, this._itemFeed = const []]);

  //o .reversed.toList() faz com que o feed seja adicionado em ordem correta.
  List<FeedMODEL> get itemFeed => [..._itemFeed.reversed.toList()];
  List<FeedMODEL> get itemFeedFavoritos => _itemFeed.where((element) => element.favorito).toList().reversed.toList();
  int itemCount() => _itemFeed.length;

  Future<void> favoritar(FeedMODEL itemRaw, String userId) async {
    final int index = _itemFeed.indexWhere((element) => element.idFeed == itemRaw.idFeed);

    if (index >= 0) {
      final item = _itemFeed[index];
      item.favorito = !item.favorito;
      notifyListeners();

      final response = await http.put( 
        //Criar pasta chamada "userFavorites" no Firebase e cruar uma pastar do id do usuário
        '${Constantes.BASE_URL_API}/userFavorites/$userId/${itemRaw.idFeed}.json?auth=$_token',
        body: json.encode(item.favorito),
        // body: json.encode(
        //   {'favorito': item.favorito},
        // ),
      );

      if (response.statusCode >= 400) {
        item.favorito = !item.favorito;
        notifyListeners();

        throw HttpException(
          'Erro ${response.statusCode} - Não foi possível salvar como favorito.',
        );
      }
    }
  }
  
  Future<void> like(FeedMODEL evento, String userId) async {
    final int index = _itemFeed.indexWhere((element) => element.idFeed == evento.idFeed);

    if (index >= 0) {
      final event = _itemFeed[index];

      //ALTERAR LIKE PARA VERDADEIRO OU FALSO
      bool like = event.like = !event.like;
      final response = await http.put( 
        '${Constantes.BASE_URL_API}/userLike/$userId/${evento.idFeed}.json?auth=$_token',
        body: json.encode(like),
      );
      notifyListeners();
      
      if (response.statusCode >= 400) {
        event.like = !event.like;
        notifyListeners();

        throw HttpException(
          'Erro ${response.statusCode} - Não foi possível salvar seu like.',
        );
      }

        
      await http.patch( 
        '${Constantes.BASE_URL_API}/feed/${evento.idFeed}/.json?auth=$_token',
        body: json.encode(
          {'curtidas': event.like ? event.curtidas = event.curtidas + 1 : event.curtidas = event.curtidas - 1 }
        ),
      ); 
      notifyListeners();


      if(event.curtidas < 0 ){
          event.curtidas = 0;
        await http.patch( 
          '${Constantes.BASE_URL_API}/feed/${evento.idFeed}/.json?auth=$_token',
          body: json.encode(
            {'curtidas': 0}
          ),
        );
        notifyListeners();
      } 


    }

  }


  Future<void> deletar(FeedMODEL itemRaw) async {
    final index = _itemFeed.indexWhere((item) => item.idFeed == itemRaw.idFeed);

    if (index >= 0) {
      final product = _itemFeed[index];
      _itemFeed.remove(product); //o mesmo que: _itemFeed[index]
      notifyListeners();

      final response = await http.delete('$_baseUrl/${product.idFeed}.json?auth=$_token');

      if (response.statusCode >= 400) {
        _itemFeed.insert(index, product);
        notifyListeners();

        //lançar exceptions. trate essa excessão no clique do botão.
        throw HttpException('Ocurreu um erro na exclusão do produto');
      }
    }
  }

  Future<void> loadFeed() async {
    final response = await http.get('$_baseUrl/.json?auth=$_token');
    Map<String, dynamic> data = json.decode(response.body);
    _itemFeed.clear();
   
    final favResponse = await http.get('${Constantes.BASE_URL_API}/userFavorites/$_userId/.json?auth=$_token');
    final favMap = json.decode(favResponse.body);
   
    final likeResponse = await http.get('${Constantes.BASE_URL_API}/userLike/$_userId/.json?auth=$_token');
    final likeMap = json.decode(likeResponse.body);

   
    if (data != null) {
      data.forEach((feedId, feedData) {
        _itemFeed.add(
          FeedMODEL(
            idFeed: feedId,
            titulo: feedData['titulo'],
            subtitulo: feedData['subtitulo'],
            imagemPrincipal: feedData['imagemPrincipal'],
            conteudo: feedData['conteudo'],
            tipoFeed: feedData['tipoFeed'] == 'TipoFeed.review'
                ? TipoFeed.review
                : feedData['tipoFeed'] == 'TipoFeed.dica'
                    ? TipoFeed.dica
                    : feedData['tipoFeed'] == 'TipoFeed.patrocinado'
                        ? TipoFeed.patrocinado
                        : feedData['tipoFeed'] == 'TipoFeed.evento'
                            ? TipoFeed.evento
                            : feedData['tipoFeed'] == 'TipoFeed.noticia'
                                ? TipoFeed.noticia
                                : feedData['tipoFeed'] == 'TipoFeed.evento'
                                    ? TipoFeed.evento
                                    : null,
            dataPublicacao: DateTime.parse(feedData['dataPublicacao']),
            favorito: favMap == null ? false : favMap[feedId] ?? false,
            like: likeMap == null ? false : likeMap[feedId] ?? false,
            curtidas: feedData['curtidas'] ?? 0,
            estado: feedData['estado'],
          ),
        );
            
        notifyListeners();
      });
    } else {
      return Future.value();
    }
  }

  Future<void> addFeed(FeedMODEL newFeed) async {
    final date = DateTime.now();

    final response = await http.post(
      '$_baseUrl/.json?auth=$_token',
      body: json.encode({
        //tente add este produto (o encode converteu pra Json) no servidor
        'titulo': newFeed.titulo,
        'subtitulo': newFeed.subtitulo,
        'imagemPrincipal': newFeed.imagemPrincipal,
        'conteudo': newFeed.conteudo,
        'tipoFeed': newFeed.tipoFeed.toString(),
        'dataPublicacao': date.toIso8601String(),
        'curtidas': newFeed.curtidas,
        'estado': newFeed.estado,
      }),
    );

    _itemFeed.add(
      FeedMODEL(
        idFeed: json.decode(response.body)['name'],
        titulo: newFeed.titulo,
        subtitulo: newFeed.subtitulo,
        imagemPrincipal: newFeed.imagemPrincipal,
        conteudo: newFeed.conteudo,
        tipoFeed: newFeed.tipoFeed,
        dataPublicacao: date,
        curtidas: newFeed.curtidas,
        estado: newFeed.estado,
      ),
    );
    notifyListeners();
  }

  Future<void> updateItemFeed(FeedMODEL itemFeed) async {
    if (itemFeed == null || itemFeed.idFeed == null) {
      return;
    }

    final int index =
        _itemFeed.indexWhere((item) => item.idFeed == itemFeed.idFeed);

    if (index >= 0) {
      //
      await http.patch(
        '$_baseUrl/${itemFeed.idFeed}.json?auth=$_token',
        body: json.encode(
          {
            'titulo': itemFeed.titulo,
            'subtitulo': itemFeed.subtitulo,
            'imagemPrincipal': itemFeed.imagemPrincipal,
            'conteudo': itemFeed.conteudo,
            'tipoFeed': itemFeed.tipoFeed.toString(),
            'estado' : itemFeed.estado,
            //'dataPublicacao': DateTime.now().toIso8601String(),
          },
        ),
      );
      _itemFeed[index] = itemFeed;
      notifyListeners();
    }
  }
}
