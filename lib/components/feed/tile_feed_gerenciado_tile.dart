import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:scooter_rider_brasil/models/feed_model.dart';
import 'package:scooter_rider_brasil/providers/feed_provider.dart';
import 'package:scooter_rider_brasil/utils/constantes.dart';
import 'package:scooter_rider_brasil/utils/rotas.dart';

class TileFeedGerenciado extends StatelessWidget {
  final FeedMODEL item;

  TileFeedGerenciado({Key key, this.item});

  @override
  Widget build(BuildContext context) {
    FeedProvider feedProvider = Provider.of<FeedProvider>(context);

    return Column(
      children: [
        ListTile(
          
          //NAVEGAR PARA DETALHE
          onTap: () {
            Navigator.of(context).pushNamed(
              ROTAS.DETALHE_FEED,
              arguments: item,
            );
          },
          
          //IMAGEM
          leading: Container(
            width: 60,
            child: Image.network(
              item.imagemPrincipal ?? Constantes.SEM_IMAGEM,
              fit: BoxFit.fitWidth,
            ),
          ),
          
          //TEXTOS
          title: Text(
             item.titulo ?? 'Sem titulo no banco de dados',
            style: TextStyle(fontSize: 14),
          ),
          subtitle: Text(
            '${item.tipoFeedAsText} - Estado: ${item.estadoFeedAsText} -\n' +
                DateFormat('dd/MM/yyyy - hh:mm').format(item.dataPublicacao),
            style: TextStyle(color: Colors.grey, fontSize: 10),
          ),
         
          //ICONES
          trailing: Container(
            width: 96,
            child: Row(
              children: [

                //EDITAR
                IconButton(
                  icon: Icon(
                    Icons.edit,
                    color: Colors.black54,
                  ),
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
               
                //EXCLUIR
                IconButton(
                  icon: Icon(Icons.delete),
                  color: Theme.of(context).errorColor,
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(
                          'Excluir item',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        content: Text('Tem certeza que deseja excluir "${item.titulo}?"'),
                        actions: [
                          TextButton(
                            onPressed: () {
                                feedProvider.removeFeed(item.idFeed);
                                Navigator.of(context).pop();
                            },
                            child: Text(
                              'Excluir',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                          TextButton(
                            child: Text('Não'),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ],
                      ),
                    );
                  },
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
