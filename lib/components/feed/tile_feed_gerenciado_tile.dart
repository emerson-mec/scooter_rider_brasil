import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scooter_rider_brasil/exceptions/http_exceptions.dart';
import 'package:scooter_rider_brasil/models/feed_model.dart';
import 'package:scooter_rider_brasil/providers/feed_provider.dart';
import 'package:scooter_rider_brasil/utils/rotas.dart';

class ItemFeedGerenciado extends StatelessWidget {
  final FeedMODEL item;
  final FeedProvider itemRAW;

  ItemFeedGerenciado({Key key, this.item, this.itemRAW});
  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);

    return Column(
      children: [
        ListTile(
          onTap: () {
            Navigator.of(context).pushNamed(
              ROTAS.DETALHE_FEED,
              arguments: item,
            );
          },
          leading: Container(
            width: 60,
            child: Image.network(
              item.imagemPrincipal,
              fit: BoxFit.fitWidth,
            ),
          ),
          title: Text(
            "${item.titulo}",
            style: TextStyle(fontSize: 14),
          ),
          subtitle: Text(
            '${item.tipoFeedAsText} - Estado: ${item.estado} -\n' +
                DateFormat('dd/MM/yyyy - hh:mm').format(item.dataPublicacao),
            style: TextStyle(color: Colors.grey, fontSize: 10),
          ),
          trailing: Container(
            width: 96,
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.edit,
                    color: Colors.black54,
                  ),
                  color: Theme.of(context).primaryColor,
                  onPressed: () {
                    if (item.tipoFeed != TipoFeed.evento) {
                      Navigator.of(context).pushNamed(
                        ROTAS.FORMULARIOFEED,
                        arguments: item,
                      );
                    } else {
                      Navigator.of(context).pushNamed(
                        ROTAS.FORMULARIOEVENTO,
                        arguments: item,
                      );
                    }
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(
                          'Excluir item',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        content: Text(
                            'Tem certeza que deseja excluir "${item.titulo}?"'),
                        actions: [
                          FlatButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: Text(
                              'Excluir',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                          FlatButton(
                            child: Text('Não'),
                            onPressed: () => Navigator.of(context).pop(false),
                          ),
                        ],
                      ),
                    ).then(
                      (value) async {
                        if (value) {
                          try {
                            await itemRAW.deletar(item);
                            scaffold.showSnackBar(
                              SnackBar(
                                content: Row(
                                  children: [
                                    Text('Desfazer exclusão?'),
                                    Spacer(),
                                    FlatButton(
                                        onPressed: () {
                                          itemRAW.addFeed(FeedMODEL(
                                            titulo: item.titulo,
                                            conteudo: item.conteudo,
                                            curtidas: item.curtidas,
                                            dataPublicacao: item.dataPublicacao,
                                            favorito: false,
                                            idFeed: item.idFeed,
                                            imagemPrincipal: item.imagemPrincipal,
                                            subtitulo: item.subtitulo,
                                            tipoFeed: item.tipoFeed,
                                            estado: item.estado,
                                          ));
                                        },
                                        child: Text(
                                          'Sim',
                                          style: TextStyle(color: Colors.yellow, fontSize: 20),
                                        )),
                                  ],
                                ),
                              ),
                            );
                          } on HttpException catch (error) {
                            scaffold.showSnackBar(
                              SnackBar(
                                content: Text(error.toString()),
                              ),
                            );
                          }
                        }
                      },
                    );
                  },
                  color: Theme.of(context).errorColor,
                ),
              ],
            ),
          ),
        ),
        Divider(indent: 30, endIndent: 30),
      ],
    );
  }
}
