import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:scooter_rider_brasil/providers/auth.dart';
import 'package:scooter_rider_brasil/providers/feed_provider.dart';
//SCREENS
import '../../models/feed_model.dart';
import '../../utils/rotas.dart';

class DetalheFeed extends StatefulWidget {
  final FeedMODEL item;
  final int index;

  DetalheFeed([this.item, this.index]);

  @override
  _DetalheFeedState createState() => _DetalheFeedState();
}

class _DetalheFeedState extends State<DetalheFeed> {
  @override
  Widget build(BuildContext context) {
    final item = ModalRoute.of(context).settings.arguments as FeedMODEL;
    Auth auth = Provider.of(context);

    _exibeDataSe(FeedMODEL item) {
    if (item.tipoFeed == TipoFeed.evento ||
        item.tipoFeed == TipoFeed.patrocinado) {
      return Container();
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Text(
          'Publicado em: ' +
              DateFormat('dd/MM/yyyy - hh:mm').format(item.dataPublicacao),
          style: TextStyle(
              fontWeight: FontWeight.w300, color: Colors.grey, fontSize: 12),
        ),
      );
    }
  }

    return Scaffold(
      appBar: AppBar(
        title: Text(item.tipoFeedAsText),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Text(
              item.titulo,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            ),
            Container(
              width: MediaQuery.of(context).size.width / 0.9,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: NetworkImage(item.imagemPrincipal),
                ),
              ),
              child: Image.network(item.imagemPrincipal),
            ),
            Text(
              item.subtitulo,
              style: TextStyle(fontWeight: FontWeight.w300, fontSize: 15),
            ),
            SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: item.favorito
                          ? Icon(FontAwesomeIcons.thumbsUp)
                          : Icon(FontAwesomeIcons.thumbsUp),
                    ),
                    SizedBox(width: 10),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          Provider.of<FeedProvider>(context, listen: false)
                              .favoritar(item, auth.userId);
                        });
                      },
                      icon: item.favorito
                          ? Icon(Icons.star, size: 30, color: Colors.amber)
                          : Icon(Icons.star_border),
                    ),
                    Spacer(),
                    _exibeDataSe(item),
                  ],
                ),
              ],
            ),

            Text(item.conteudo),
            //QUERO PARTICIPAR
            item.tipoFeed == TipoFeed.evento
                ? TextButton.icon(
                    icon: Icon(Icons.subdirectory_arrow_right_sharp),
                    onPressed: () => Navigator.of(context).pushNamed(
                      ROTAS.DETALHE_EVENTO,
                      arguments: item,
                    ),
                    label: Text('Quero me inscrever'),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
