import 'package:flutter/material.dart';
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

  // _exibeDataSe(FeedMODEL item) {
  //   //Exibe data, exceto para "patrocinado" e "evento"
  //   if (item.tipoFeed == TipoFeed.evento ||
  //       item.tipoFeed == TipoFeed.patrocinado) {
  //     return Container();
  //   } else {
  //     return Padding(
  //       padding: const EdgeInsets.symmetric(horizontal: 12),
  //       child: Text(
  //         'Publicado em: ' +
  //             DateFormat('dd/MM/yyyy - hh:mm').format(item.dataPublicacao),
  //         style: TextStyle(
  //             fontWeight: FontWeight.w300, color: Colors.grey, fontSize: 12),
  //       ),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
      child: Card(
        shadowColor: Colors.black26,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        elevation: 6,
        child: Container(
          child: Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 9,
                      top: 20,
                      bottom: 20,
                    ),
                    child: IconFeedType(widget.item),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${widget.item.tipoFeedAsText}',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.blueGrey[500],
                            fontSize: 16),
                      ),
                      Text(
                        '${widget.item.dataPublicacaoAsFormat()}',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.blueGrey[200],
                            fontSize: 11),
                      ),
                    ],
                  ),
                  SizedBox(width: 60),
                  Column(
                    children: [
                      Text('${widget.item.estadoFeedAsText}',style: TextStyle(color: Colors.grey[300]),),
                    ],
                  ),
                  Spacer(),
                  Icon(Icons.bookmark, color: Colors.blueGrey[300],),
                  SizedBox(width: 20),
                ],
              ),
              // IMAGEM
              InkWell(
                onTap: () {
                  Navigator.of(context).pushNamed(
                    ROTAS.DETALHE_FEED,
                    arguments: widget.item,
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Image.network(
                    widget.item.imagemPrincipal ?? Constantes.SEM_IMAGEM,
                    fit: BoxFit.fitWidth,
                    height: 200,
                    width: 370,
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes
                              : null,
                        ),
                      );
                    },
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        ROTAS.DETALHE_FEED,
                        arguments: widget.item,
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.only(left: 15, bottom: 0, right: 15, top: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.item.titulo ?? 'Sem titulo no banco de dados',
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 18,
                              color: Colors.blueGrey[700],
                            ),
                          ),
                          SizedBox(height: 10),
                          Divider(
                            color: Colors.blueGrey[400],
                            thickness: 0.2,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 20, right: 22, top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(
                          Icons.favorite,
                          color: Colors.yellow[600],
                        ),
                        Text(
                          ' 256',
                          style: TextStyle(color: Colors.blueGrey[300], fontWeight: FontWeight.w600),
                        ),
                        SizedBox(width: 20),
                        Icon(
                          Icons.remove_red_eye,
                          color: Colors.blueGrey[300],
                        ),
                        Text(
                          ' 2048',
                          style: TextStyle(
                              color: Colors.blueGrey[300],
                              fontWeight: FontWeight.w600),
                        ),
                      
                      ],
                    ),
                  ),
                ],
              ),
              // Divider(indent: 40, endIndent: 40),
            ],
          ),
        ),
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
