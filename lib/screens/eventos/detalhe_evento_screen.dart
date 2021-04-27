import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:scooter_rider_brasil/components/evento/alert_inscricao_widget.dart';

import 'package:scooter_rider_brasil/models/evento_model.dart';
import 'package:scooter_rider_brasil/providers/evento_provider.dart';
import 'package:scooter_rider_brasil/utils/constantes.dart';

class DetalheEvento extends StatefulWidget {
  @override
  _DetalheEventoState createState() => _DetalheEventoState();
}

class _DetalheEventoState extends State<DetalheEvento> {
  bool mostrarCancelar = true;

  @override
  Widget build(BuildContext context) {
    final eventoModalRoute = ModalRoute.of(context).settings.arguments as EventoMODEL;
    EventoProvider eventoProvider = Provider.of<EventoProvider>(context);

    //quanto tempo falta para o evento
    Duration falta = eventoModalRoute.dataEvento.difference(DateTime.now());

   

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
              Color(0xFFf3f5f7),
              Color(0xFFd3dde7),
            ],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    //IMAGEM PRINCIPAL
                    Stack(
                      children: [
                        Container(
                          child: Image.network(
                            eventoModalRoute.imagemPrincipal ??
                                Constantes.SEM_IMAGEM,
                            fit: BoxFit.contain,
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: eventoModalRoute.dataEvento
                                        .isAfter(DateTime.now())
                                    ? [
                                        Colors.lightGreen,
                                        Colors.green[900],
                                      ]
                                    : [
                                        Colors.redAccent,
                                        Colors.red[900],
                                      ],
                              ),
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20)),
                            ),

                            padding: EdgeInsets.all(10),
                            //color: Theme.of(context).primaryColor,
                            child: Column(
                              children: [
                                Text(
                                  DateFormat('dd/MM/y')
                                      .format(eventoModalRoute.dataEvento),
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18,
                                    color: Colors.yellowAccent,
                                  ),
                                ),
                                if (eventoModalRoute.dataEvento
                                    .isAfter(DateTime.now()))
                                  Text(
                                    'a partir das: ' + DateFormat('hh:mm').format(eventoModalRoute.dataEvento),
                                    textAlign: TextAlign.end,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 15,
                                      color: Colors.white,
                                    ),
                                  ),
                                if (eventoModalRoute.dataEvento
                                    .isAfter(DateTime.now()))
                                  Container(
                                    width: 110,
                                    color: Colors.white,
                                    height: 0.5,
                                    margin: EdgeInsets.symmetric(vertical: 8),
                                  ),
                                if (eventoModalRoute.dataEvento
                                    .isAfter(DateTime.now()))
                                  Text(
                                    '${falta.inDays == 0 ? "" : "Faltam ${falta.inDays} dias"}  ${falta.inDays == 0 ? "Faltam ${falta.inHours} horas e ${falta.inMinutes.remainder(60)} min" : ""}',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(color: Colors.black54),
                                  ),

                                //Text('Faltam ${falta.inDays} dias ${falta.inDays == 0 ? "e ${falta.inHours} horas" : ""}',style: TextStyle(color: Colors.white54),),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    Container(
                      alignment: Alignment.centerLeft,
                      width: double.infinity,
                      height: 40,
                      color: Colors.blue[400],
                      child: Text(
                        '   Evento',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                        ),
                      ),
                    ),

                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 30),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //TITULO
                          Text(
                            '${eventoModalRoute.titulo}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                              color: Colors.blueGrey[800],
                            ),
                          ),

                          //SUBTITULO
                          Text(
                            '${eventoModalRoute.subtitulo}',
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 15,
                              color: Colors.blue[400],
                              fontStyle: FontStyle.italic,
                            ),
                          ),

                          Divider(
                            endIndent: 20,
                            indent: 20,
                            color: Colors.blueGrey[300],
                            height: 40,
                          ),

                          Row(
                            children: [
                              Image.network( 'https://avatars.githubusercontent.com/u/57400937?v=4',scale: 15.0),
                              Text(' By Emerson Oliveira', style: TextStyle(
                                  color: Colors.blue[800],
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),

                          //DETALHE
                          Column(
                            children: [
                              SizedBox(height: 15),
                              Text(
                                '${eventoModalRoute.conteudo}',
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 15,
                                  color: Colors.blueGrey[400],
                                ),
                              ),
                            ],
                          ),

                          Divider(
                            endIndent: 20,
                            indent: 20,
                            color: Colors.blueGrey[300],
                            height: 60,
                          ),
                          //LISTA DE PRESENÇA TITULO
                          Text(
                            'Lista de presença'.toUpperCase(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                              color: Colors.blueGrey[800],
                            ),
                          ),
                          SizedBox(height: 15),

                          //INSCRITOS NA LISTA DE PRESENÇA
                          Container(
                            color: Colors.blueGrey[100],
                            height: 250,
                            child: StreamBuilder(
                              initialData: Text('Carregando'),
                              stream: FirebaseFirestore.instance.collection('evento').doc(eventoModalRoute.id).snapshots(),
                              builder: (BuildContext context, AsyncSnapshot snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        CircularProgressIndicator(),
                                        SizedBox(height: 10),
                                        Text('Carregando...'),
                                      ],
                                    ),
                                  );
                                }

                                //print(snapshot.data['inscritos']['m2p0BmXZUoSRVOnxRa2Vwgoy3v82'] != true);

                                List snap =snapshot.data['inscritos'].values.toList();

                                return Column(
                                  children: [
                                    Container(
                                      color: Colors.blueGrey[500],
                                      padding: EdgeInsets.all(8),
                                      child: Row(
                                        children: [
                                          Expanded(flex: 11, child: Text(' Nome',style: TextStyle(color: Colors.white))),
                                          Container(width: 51, child: Text('Com\ngarupa?',textAlign: TextAlign.center,style: TextStyle(color: Colors.white))),
                                          VerticalDivider(),
                                          Container(width: 59, child: Text('Convidou\nalguém?',textAlign: TextAlign.center, style: TextStyle(color: Colors.white))),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      height: 173,
                                      child: ListView.builder(
                                        itemCount: snap.length,
                                        itemBuilder: (context, i) {
                                         String urlAvatar = snap[i]['urlAvatar'];

                                          return Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 2,right: 8,bottom: 5,top: 5),
                                                    child: CircleAvatar(
                                                      backgroundColor: Colors.grey,
                                                      maxRadius: 13,
                                                      backgroundImage: urlAvatar != null ? NetworkImage(urlAvatar) : AssetImage(Constantes.SEM_AVATAR),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 11,
                                                      child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(snap[i]['nome'] ?? '', style: TextStyle(color:Colors.blueGrey[800],fontWeight: FontWeight.w500),),
                                                        Text(snap[i]['pontoEncontro'] ?? '', style: TextStyle(color:Colors.grey[500],fontWeight: FontWeight.w400),),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(width: 60, child: 
                                                    Text(snap[i]['garupa'].toString().contains('true') ? '   Sim' : '   Não',
                                                   style: TextStyle(color:Colors.blueGrey[700],),)),

                                                  Container(width: 60, child: 
                                                    Text(snap[i]['amigo'].toString().contains('true') ? '     Sim' : '     Não',
                                                  style: TextStyle(color:Colors.blueGrey[700]),)),
                                                ],
                                              ),
                                              Divider(height: 8,color: Colors.black45),
                                            ],
                                          );
                                        },
                                      ),
                                    ),
                                    Container(child: Text('${snap.length} inscritos',style: TextStyle(color: Colors.blueGrey[300]))),
                                  ],
                                );
                              },
                            ),
                          ),
                          SizedBox(height: 50),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),

            //BOTÕES DE INSCRIÇÃO
            Container(
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      color: eventoModalRoute.dataEvento.isAfter(DateTime.now())
                          ? Colors.lightGreen
                          : Colors.redAccent,
                      child: TextButton(
                        child: eventoModalRoute.dataEvento.isAfter(DateTime.now())
                                ? Text('Inscreve-me',style: TextStyle(color: Colors.white))
                                : Text('Fim das incrições', style: TextStyle(color: Colors.white)),
                        
                        onPressed: eventoModalRoute.dataEvento .isAfter(DateTime.now()) ? () async {
                              
                                showDialog(
                                  context: context, 
                                  builder: (context) => AlertInscricao(eventoModalRoute: eventoModalRoute, eventoProvider: eventoProvider),
                                );
                               

                                
                              }
                            : null,
                      ),
                    ),
                  ),
                  //////////////////////////////////////////////////////////////////////////////////
                  if (mostrarCancelar)
                    eventoModalRoute.dataEvento.isAfter(DateTime.now())
                        ? Expanded(
                            child: Container(
                              color: Colors.redAccent,
                              child: TextButton(
                                onPressed: () {
                                  eventoProvider.removerInscricao(eventoModalRoute.id);
                                },
                                child: Text('Cancelar inscrição', style: TextStyle(color: Colors.white)),
                              ),
                            ),
                          )
                        : Text(''),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}








 