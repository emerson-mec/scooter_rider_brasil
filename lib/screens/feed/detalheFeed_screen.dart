import 'package:flutter/material.dart';
import 'package:scooter_rider_brasil/utils/constantes.dart';
//SCREENS
import '../../models/feed_model.dart';

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

    // _exibeDataSe(FeedMODEL item) {
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

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black54),
        elevation: 5,
        title: Image.asset('assets/logo_srb3.png', scale: 3.2),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.red,
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              Color(0xFFd3dde7),
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              //IMAGEM
              Container(
                width: MediaQuery.of(context).size.width / 0.9,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: NetworkImage(
                        item.imagemPrincipal ?? Constantes.SEM_IMAGEM),
                  ),
                ),
                child: Image.network(
                    item.imagemPrincipal ?? Constantes.SEM_IMAGEM),
              ),
              //  TIPO FEED
              Container(
                alignment: Alignment.centerLeft,
                width: double.infinity,
                height: 40,
                color: item.tipoFeedAsText == 'Notícia'
                    ? Colors.brown[400]
                    : item.tipoFeedAsText == 'Dica'
                        ? Colors.green[300]
                        : item.tipoFeedAsText == 'Review'
                            ? Colors.red[300]
                            : item.tipoFeedAsText == 'Patrocínado'
                                ? Colors.pinkAccent[100]
                                : Colors.red,
                child: Text(
                  '   ${item.tipoFeedAsText}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                  ),
                ),
              ),
              SizedBox(height: 2),

              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  children: [
                    //CURTIDAS E DATA
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Publicado: ${item.dataPublicacaoAsFormat()}',
                          style: TextStyle(color: Colors.blueGrey[300]),
                        ),
                        Container(
                          child: Row(
                            children: [
                              Icon(
                                Icons.favorite,
                                color: Colors.yellow[700],
                              ),
                              Text(
                                ' 256',
                                style: TextStyle(
                                    color: Colors.blueGrey[300],
                                    fontWeight: FontWeight.w600),
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
                        )
                      ],
                    ),
                    Divider(height: 50, color: Colors.blueGrey),

                    //TITULO
                    Text(
                      '${item.titulo}' ?? 'sem título',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        color: Colors.blueGrey[800],
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      '${item.subtitulo}',
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 15,
                        color: Colors.blue[500],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    SizedBox(height: 20),

                    Row(
                      children: [
                        Image.network(
                          'https://avatars.githubusercontent.com/u/57400937?v=4',
                          scale: 15.0,
                        ),
                        Text(
                          ' By ${item.autor}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w300,
                          ),
                        )
                      ],
                    ),

                    SizedBox(height: 20),

                    Column(
                      children: [
                        SizedBox(height: 15),
                        Text(
                          '${item.conteudo}',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 15,
                            color: Colors.blueGrey[500],
                          ),
                        ),
                      ],
                    ),

                    Divider(height: 80, color: Colors.blueGrey),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
