import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:scooter_rider_brasil/models/evento_model.dart';
import 'package:scooter_rider_brasil/providers/auth.dart';
import 'package:scooter_rider_brasil/providers/evento_provider.dart';
import 'package:scooter_rider_brasil/components/evento/alert_inscricao_widget.dart';
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
    EventoProvider itemRaw = Provider.of<EventoProvider>(context);
    Auth auth = Provider.of<Auth>(context);
    //TAMANHOS
    var appBar = AppBar().preferredSize;
    var size = MediaQuery.of(context).size;
    //pega o tamanho vertical da tela e desconta a appBar mais o Pad do statusBar(relogio)
    var height = (size.height - appBar.height) - MediaQuery.of(context).padding.top;

   //quanto tempo falta para o evento 
   var falta = eventoModalRoute.dataEvento.difference(DateTime.now());
  
       
    return Scaffold(
       appBar: AppBar(
        //actions: [Icon(Icons.menu, color: Theme.of(context).primaryColor)],
        elevation: 1,
        flexibleSpace: Center(
          child: Column(
            children: [
                  SizedBox(height: 34),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/logo_srb.png', scale: 20),
                  SizedBox(width: 7),
                  Text(
                    'Inscrições',
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Bookman',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
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
                  Column(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12,vertical: 18),
                        child: Text(
                          eventoModalRoute.titulo,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            color: Colors.blueGrey[800],
                          ),
                        ),
                      ),
                      Stack(
                        children: [
                          Container(
                            child: Image.network(
                              eventoModalRoute.imagemPrincipal,
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
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(20)),
                              ),

                              padding: EdgeInsets.all(10),
                              //color: Theme.of(context).primaryColor,
                              child: Column(
                                children: [
                                  Text(
                                    DateFormat('dd/MM/y').format(eventoModalRoute.dataEvento),
                                    textAlign: TextAlign.end,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 18,
                                      color: Colors.yellowAccent,
                                    ),
                                  ),
                                  if(eventoModalRoute.dataEvento.isAfter(DateTime.now()))
                                  Text('a partir das: '+
                                    DateFormat('hh:mm').format(eventoModalRoute.dataEvento),
                                    textAlign: TextAlign.end,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 15,
                                      color: Colors.white,
                                    ),
                                  ),
                                  if(eventoModalRoute.dataEvento.isAfter(DateTime.now()))
                                  Container(width: 110,color: Colors.white,height: 0.5, margin: EdgeInsets.symmetric(vertical: 8),),
                                  if(eventoModalRoute.dataEvento.isAfter(DateTime.now()))
                                  Text(
                                    '${falta.inDays == 0 ? "" : "Faltam ${falta.inDays} dias"}  ${falta.inDays == 0 ? "Faltam ${falta.inHours} horas e ${falta.inMinutes.remainder(60)} min" : ""}',  
                                    textAlign: TextAlign.start,style: TextStyle(color: Colors.black54),
                                  ),
                                  
                                  //Text('Faltam ${falta.inDays} dias ${falta.inDays == 0 ? "e ${falta.inHours} horas" : ""}',style: TextStyle(color: Colors.white54),),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Text(
                        eventoModalRoute.subtitulo,
                        style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 16,
                            color: Colors.grey),
                      ),
                      Divider(endIndent: 20, indent: 20),
                      SizedBox(height: 10),
                      Text('Detalhe'.toUpperCase(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                            color: Colors.amber,
                          )),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Column(
                          children: [
                            SizedBox(height: 15),
                            Text(
                              eventoModalRoute.conteudo,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 13,
                                color: Colors.blueGrey[800],
                              ),
                            ),
                            Divider(height: 40),
                          ],
                        ),
                      ),

                      Text(
                        'Lista de presença'.toUpperCase(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          color: Colors.amber
                        ),
                      ),
                      SizedBox(height: 15),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 5),
                        color: Colors.blueGrey[800],
                        height: height / 2,
                        child: FutureBuilder(
                          initialData: Text(
                            'Carregando',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          future: Provider.of<EventoProvider>(context,
                                  listen: false)
                              .loadInscritos(eventoModalRoute.id),
                          builder: (context, snapshot) {
                            if (snapshot.error != null) {
                              return Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CircularProgressIndicator(),
                                      SizedBox(height: 20),
                                      Container(
                                        color: Colors.white10,
                                        child: FlatButton.icon(
                                          onPressed: (){
                                            itemRaw.loadInscritos(eventoModalRoute.id);
                                          },
                                          icon: Icon(Icons.refresh),
                                          label: Text('Tentar novamente', style: TextStyle(
                                                color: Colors.white,
                                          ),),
                                        ),
                                      ),
                                      SizedBox(height: 20),
                                      Text(
                                        'Verifique sua internet e atualize a página.',
                                        style: TextStyle(
                                              color: Colors.white,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ));
                            } else {
                              return Consumer<EventoProvider>(
                                builder: (context, evento, _) {
                                  return ListView.builder(
                                      itemCount: evento.listInscritos.length,
                                      itemBuilder: (context, i) {
                                        return Container(
                                          width: size.width,
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Container(
                                                    child: Text(
                                                    evento.listInscritos[i].email,
                                                    style: TextStyle(
                                                    fontSize: size.width * 0.04,
                                                    color: Colors.white,
                                                    ),
                                                  ),
                                                  ),
                                                  Container(
                                                    width: size.width * 0.30,
                                                    child: Text(
                                                      evento
                                                      .listInscritos[i].vaiComo,
                                                      style: TextStyle(
                                                        fontSize: size.width * 0.04,
                                                        color: Colors.white,
                                                      ),
                                                      textAlign: TextAlign.right,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Divider(
                                                color: Colors.white24,
                                              ),
                                            ],
                                          ),
                                        );
                                      });
                                },
                              );
                            }
                          },
                        ),
                      ),
                      SizedBox(height: 30),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Container(
            color: Colors.blueGrey[50],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FlatButton(
                  child: eventoModalRoute.dataEvento.isAfter(DateTime.now())
                      ? Text('   Inscreve-me   ',
                          style: TextStyle(color: Colors.white))
                      : Text('Fim das incrições',
                          style: TextStyle(color: Colors.red)),
                  onPressed: eventoModalRoute.dataEvento.isAfter(DateTime.now())
                      ? () {
                          setState(() {
                            mostrarCancelar = true;
                          });
                          //itemRaw.addInscrito(eventoModalRoute, auth);
                          return showDialog(
                            context: context,
                            child: AlertInscricaoWidget(
                              auth: auth,
                              eventoModalRoute: eventoModalRoute,
                            ),
                          );
                        }
                      : null,
                  color: Colors.lightGreen,
                  
                ),
      //////////////////////////////////////////////////////////////////////////////////
                if (mostrarCancelar)
                  eventoModalRoute.dataEvento.isAfter(DateTime.now())
                      ? Container(
                          margin: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0.13),
                          child: FlatButton(
                            onPressed: () {
                           
    
                              itemRaw.removerInscricao(eventoModalRoute, auth).then((_) {
                                setState(() {
                                  mostrarCancelar = false;
                                });
                              });
                            },
                            color: Colors.redAccent,
                            child: Text('Cancelar inscrição',
                                style: TextStyle(color: Colors.white)),
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
