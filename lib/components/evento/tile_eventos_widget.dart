import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scooter_rider_brasil/models/evento_model.dart';
import 'package:scooter_rider_brasil/utils/constantes.dart';
import 'package:scooter_rider_brasil/utils/rotas.dart';


class TileEventoWidget extends StatefulWidget {
  final EventoMODEL item;
  TileEventoWidget(this.item);

  @override
  _TileEventoWidgetState createState() => _TileEventoWidgetState();
}

class _TileEventoWidgetState extends State<TileEventoWidget> {


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Column(
        children: [
          InkWell(
            onTap: () {
               Navigator.of(context).pushNamed(
                 ROTAS.DETALHE_EVENTO,
                  arguments: widget.item,
               );
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(width: 5),
                Container(
                  width: 5,
                  height: 64,
                  color: widget.item.dataEvento.isAfter(DateTime.now()) ? Colors.green : Colors.red,
                 
                ),
                SizedBox(width: 1),
                
                Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      width: 96,
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Image.network(
                          widget.item.imagemPrincipal ?? Constantes.SEM_IMAGEM,
                          fit: BoxFit.contain,
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes
                                    : null,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors:  
                          widget.item.dataEvento.isAfter(DateTime.now())  ?
                           [
                            Colors.green,
                            Colors.green[900],
                          ] : [
                            Colors.redAccent,
                            Colors.red[900],
                          ],
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),

                      padding: EdgeInsets.all(3),
                      child: Text(
                        DateFormat('dd/MM').format(widget.item.dataEvento),
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 11,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${widget.item.titulo}',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                          ),
                        ),
                        SizedBox(height: 3),
                        Text(
                          'Dia ${widget.item.dataEventoAsFormat()}',
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(7.0),
                  child: Icon(Icons.navigate_next),
                ),
              ],
            ),
          ),
          Divider(endIndent: 20, indent: 20, color: Colors.blueGrey[300],),
        ],
      ),
    );
  }
}
