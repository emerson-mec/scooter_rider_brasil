import 'package:flutter/material.dart';

import 'package:scooter_rider_brasil/models/feed_model.dart';

class IconFeedType extends StatelessWidget {
  final FeedMODEL item;

  IconFeedType(this.item);

  _verificar(FeedMODEL item) {
    switch (item.tipoFeed) {
      case TipoFeed.noticia:
        return Stack(
          children: [
            CircleAvatar(
              backgroundColor: Colors.brown[400],
              child: Container(
                height: 25,
                child: Image.asset(
                  'assets/image/noticia.png',
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
        break;
      case TipoFeed.dica:
        return Stack(
          children: [
            CircleAvatar(
              backgroundColor: Colors.green[400],
              child: Container(
                height: 35,
                child: Image.asset(
                  'assets/image/dica.png',
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
        break;
      case TipoFeed.review:
        return Stack(
          children: [
            CircleAvatar(
              backgroundColor: Colors.red[400],
              child: Container(
                height: 30,
                child: Image.asset(
                  'assets/image/review.png',
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
        break;
      case TipoFeed.evento:
        return Stack(
          children: [
            CircleAvatar(
              backgroundColor: Colors.blue[400],
              child: Container(
                height: 28,
                child: Image.asset(
                  'assets/image/inscricao.png',
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
        break;
      case TipoFeed.patrocinado:
        return Stack(
          children: [
            CircleAvatar(
              backgroundColor: Colors.pinkAccent,
              child: Container(
                height: 23,
                child: Image.asset(
                  'assets/image/logo_colorida.png',
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
        break;
      default:
        return Icon(
          Icons.error_outline,
          color: Colors.red,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          _verificar(item),
        ],
      ),
    );
  }
}
