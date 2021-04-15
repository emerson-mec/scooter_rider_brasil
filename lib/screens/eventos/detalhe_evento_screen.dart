import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:scooter_rider_brasil/models/evento_model.dart';
import 'package:scooter_rider_brasil/providers/evento_provider.dart';
import 'package:scooter_rider_brasil/utils/constantes.dart';
//SCREENS

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

    //TAMANHOS
    var appBar = AppBar().preferredSize;
    var size = MediaQuery.of(context).size;
    //pega o tamanho vertical da tela e desconta a appBar mais o Pad do statusBar(relogio)
    var height = (size.height - appBar.height) - MediaQuery.of(context).padding.top;

    //quanto tempo falta para o evento
    Duration falta = eventoModalRoute.dataEvento.difference(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        //actions: [Icon(Icons.menu, color: Theme.of(context).primaryColor)],
        elevation: 10,
        flexibleSpace: Center(
          child: Column(
            children: [
              SafeArea(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 55),
                    Image.asset('assets/logo_srb.png', scale: 18),
                    SizedBox(width: 7),
                    Text(
                      'Evento',
                      style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'Bookman',
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
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
                                  'a partir das: ' +
                                      DateFormat('hh:mm').format(
                                          eventoModalRoute.dataEvento),
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
                  
                  //TITULO
                  Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 18),
                  child: Text(
                      '${eventoModalRoute.titulo}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        color: Colors.amber,
                      ),
                    ),
                  ),
                  
                  //SUBTITULO
                  Text(
                    '${eventoModalRoute.subtitulo}',
                    style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 16,
                        color: Colors.grey),
                  ),
                  Divider(endIndent: 20, indent: 20),
                  SizedBox(height: 10),

                  //DETALHE 1
                  Text('Detalhe'.toUpperCase(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: Colors.amber,
                      ),
                  ),
                  
                  //DETALHE 2
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Column(
                      children: [
                        SizedBox(height: 15),
                        Text(
                          '${eventoModalRoute.conteudo}',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                        ),
                        Divider(height: 40),
                      ],
                    ),
                  ),
                  
                  //LISTA DE PRESENÇA TITULO
                  Text(
                    'Lista de presença'.toUpperCase(),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: Colors.amber),
                  ),
                  SizedBox(height: 15),
                  
                  //INSCRITOS NA LISTA DE PRESENÇA
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    color: Colors.black45,
                    height: height / 2,
                    child: StreamBuilder(
                      initialData: Text('Carregando'),
                      stream: Firestore.instance.collection('evento').document(eventoModalRoute.id).snapshots(),
                      builder: (BuildContext context,  AsyncSnapshot snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircularProgressIndicator(),
                                  SizedBox(height: 10),
                                  Text('Carregando...'),
                                ],
                              ));
                        }

                        List snap = snapshot.data['inscritos'].values.toList();
                        
                        return ListView.builder(
                          itemCount: snap.length,
                          itemBuilder: (context, i) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(snap[i]['nome']),
                                Divider(height: 8, color: Colors.white60,),
                              ],
                            );
                          },
                        );

                      },
                    ),
                  ),
                  SizedBox(height: 30),
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
                    color: Colors.lightGreen,
                    child: TextButton(
                      child: eventoModalRoute.dataEvento.isAfter(DateTime.now())
                          ? Text('Inscreve-me',
                              style: TextStyle(color: Colors.white))
                          : Text('Fim das incrições',
                              style: TextStyle(color: Colors.red)),
                      onPressed:
                          eventoModalRoute.dataEvento.isAfter(DateTime.now())
                              ? () async {
                                  eventoProvider.inscreverSe(eventoModalRoute.id);

                                  setState(() {
                                    mostrarCancelar = true;
                                  });
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
                              child: Text('Cancelar inscrição',
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ),
                        )
                      : Text(''),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
