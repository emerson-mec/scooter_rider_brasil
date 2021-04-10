import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scooter_rider_brasil/utils/constantes.dart';

//SCREENS
import '../../models/feed_model.dart';
import '../../utils/rotas.dart';
import 'icon_tipo-feed_widget.dart';

class CardFeedWIDGET extends StatefulWidget {
  final FeedMODEL item;

  CardFeedWIDGET(this.item);

  @override
  _CardFeedWIDGETState createState() => _CardFeedWIDGETState();
}

class _CardFeedWIDGETState extends State<CardFeedWIDGET> {
  // _favoritos(FeedMODEL item, Auth auth) {
  //   return item.favorito
  //       ? IconButton(
  //           onPressed: () {
  //             setState(() {
  //               Provider.of<FeedProvider>(context, listen: false)
  //                   .favoritar(item);
  //             });
  //           },
  //           icon: Icon(Icons.star, size: 28, color: Colors.yellow[800]),
  //           // icon: Icon(FontAwesomeIcons.solidBookmark),
  //         )
  //       : IconButton(
  //           onPressed: () {
  //             setState(() {
  //               Provider.of<FeedProvider>(context, listen: false)
  //                   .favoritar(item);
  //             });
  //           },

  //           icon:
  //               Icon(Icons.star_border, size: 28, color: Colors.blueGrey[800]),
  //           //icon: Icon(FontAwesomeIcons.bookmark),
  //         );
  // }

  // _like(FeedMODEL item, Auth auth) {
  //   return item.like
  //       ? IconButton(
  //           onPressed: () {
  //             setState(() {
  //               Provider.of<FeedProvider>(context, listen: false)
  //                   .like(item, auth.userId);
  //             });
  //           },
  //           icon: Icon(
  //             Icons.favorite,
  //             size: 28,
  //             color: Colors.red[500],
  //           ),
  //           // icon: Icon(FontAwesomeIcons.solidBookmark),
  //         )
  //       : IconButton(
  //           onPressed: () {
  //             setState(() {
  //               Provider.of<FeedProvider>(context, listen: false)
  //                   .like(item, auth.userId);
  //             });
  //           },

  //           icon: Icon(
  //             Icons.favorite_border,
  //             size: 28,
  //             color: Colors.blueGrey[800],
  //           ),
  //           //icon: Icon(FontAwesomeIcons.bookmark),
  //         );
  // }

  _exibeDataSe(FeedMODEL item) {
    //Exibe data, exceto para "patrocinado" e "evento"
    if (item.tipoFeed == TipoFeed.evento || item.tipoFeed == TipoFeed.patrocinado) {
      return Container();
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Text(
          'Publicado em: ' + DateFormat('dd/MM/yyyy - hh:mm').format(item.dataPublicacao),
          style: TextStyle(fontWeight: FontWeight.w300, color: Colors.grey, fontSize: 12),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300], width: 1),
       
      ),
          child: Column(
          children: [
          Row(
            children: [
                 Padding(
                   padding: const EdgeInsets.only(
                     left: 15,
                     right: 9,
                     top: 10,
                     bottom: 10,
                   ),
                   child: IconFeedType(widget.item),
                 ),
              Text(
                '${widget.item.tipoFeedAsText}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 60),
              Column(
                children: [
                  Text('${widget.item.estadoFeedAsText}'),
                ],
              ),
               
            ],
          ),
          
          InkWell(
            onTap: () {
              Navigator.of(context).pushNamed(
                ROTAS.DETALHE_FEED,
                arguments: widget.item,
              );
            },
            child: Image.network(
              widget.item.imagemPrincipal ?? Constantes.SEM_IMAGEM,
              fit: BoxFit.contain,
              loadingBuilder: (BuildContext context, Widget child,
                  ImageChunkEvent loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes
                        : null,
                  ),
                );
              },
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Row(
                  children: [
                    //_like(widget.item, auth), 
                    //Text('${widget.item.curtidas}',style: TextStyle(color: Colors.grey),),
                    //_favoritos(widget.item, auth),
                    Spacer(),
                    _exibeDataSe(widget.item),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 15, bottom: 15, right: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.item.titulo ?? 'Sem titulo no banco de dados',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        color: Colors.black87
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      '${widget.item.subtitulo}',
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
         // Divider(indent: 40, endIndent: 40),
        ],
      ),
    );
  }
}


// class CardFeed extends StatelessWidget {
//     final String titulo;

//     CardFeed({this.titulo});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Text(titulo.toString()),
//     );
//   }
// }
