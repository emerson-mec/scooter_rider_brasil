import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scooter_rider_brasil/utils/constantes.dart';
//SCREENS
import '../../models/feed_model.dart';
import '../../utils/rotas.dart';

class DetalheFeedSCREEN extends StatefulWidget {
  final FeedMODEL item;
  final int index;

  DetalheFeedSCREEN([this.item, this.index]);

  @override
  _DetalheFeedSCREENState createState() => _DetalheFeedSCREENState();
}

class _DetalheFeedSCREENState extends State<DetalheFeedSCREEN> {
  @override
  Widget build(BuildContext context) {
    final item = ModalRoute.of(context).settings.arguments as FeedMODEL;

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
              item.titulo ?? 'Sem titulo no banco de dados',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
          
            ),
            Container(
              width: MediaQuery.of(context).size.width / 0.9,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: NetworkImage(item.imagemPrincipal ?? Constantes.SEM_IMAGEM),
                ),
              ),
              child: Image.network(item.imagemPrincipal ?? Constantes.SEM_IMAGEM),
            ),
            Text(
              '${item.subtitulo}',
              style: TextStyle(fontWeight: FontWeight.w300, fontSize: 15),
            ),
            SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // IconButton(
                    //   onPressed: () {},
                    //   icon: item.favorito
                    //       ? Icon(FontAwesomeIcons.thumbsUp)
                    //       : Icon(FontAwesomeIcons.thumbsUp),
                    // ),
                    // SizedBox(width: 10),
                    // IconButton(
                    //   onPressed: () {
                    //     setState(() {
                    //       Provider.of<FeedProvider>(context, listen: false)
                    //           .favoritar(item);
                    //     });
                    //   },
                    //   icon: item.favorito
                    //       ? Icon(Icons.star, size: 30, color: Colors.amber)
                    //       : Icon(Icons.star_border),
                    // ),
                    // Spacer(),
                    _exibeDataSe(item),
                  ],
                ),
              ],
            ),

            Text('${item.conteudo}'),
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
                : Container() ?? Container() ,
          ],
        ),
      ),
    );
  }
}
