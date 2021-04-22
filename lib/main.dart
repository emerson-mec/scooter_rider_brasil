import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scooter_rider_brasil/providers/auth_provider.dart';
import 'package:scooter_rider_brasil/providers/clube_provider.dart';
import 'package:scooter_rider_brasil/providers/evento_provider.dart';
import 'package:scooter_rider_brasil/providers/feed_provider.dart';
import 'package:scooter_rider_brasil/screens/authScreen.dart';
import 'package:scooter_rider_brasil/screens/eventos/form_evento_screen.dart';
import 'package:scooter_rider_brasil/screens/perfil/perfil_screen.dart';
import 'utils/rotas.dart';

//SCREENS
import 'screens/compara_screen.dart';
import 'screens/feed/favoritos_screen.dart';
import 'screens/eventos/detalhe_evento_screen.dart';
import 'screens/feed/detalheFeed_screen.dart';
import 'screens/feed/form_feed_screen.dart';
import 'screens/gerenciar_screen.dart';
import 'screens/eventos/eventos_screen.dart';
import 'screens/feed/feed_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => EventoProvider()),
        ChangeNotifierProvider(create: (_) => FeedProvider()),
        ChangeNotifierProvider(create: (_) => ClubeProvider()),
      ],
      child: MaterialApp(
        title: 'Scooter Rider Brasil',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          accentColor: Colors.yellow[800],
          buttonTheme: ButtonTheme.of(context).copyWith(
            textTheme: ButtonTextTheme.primary,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          ),
          primaryColor: Colors.blueGrey[200],
          
          //COR DO APP BAR
          appBarTheme: AppBarTheme().copyWith(color: Colors.white),
          fontFamily: 'Bookman', //fonte padrão
          textTheme: ThemeData().textTheme.copyWith(
                bodyText1: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontFamily: 'Raleway',
                ),
                headline1: TextStyle(
                  // ------------ FONTE PARA OS TITULOS
                  color: Colors.black87,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Bookman',
                ),
                headline2: TextStyle(
                  // ------------ FONTE PARA OS SUB-TITULOS
                  color: Colors.black38,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Raleway',
                ),
              ),
        ),
        home: StreamBuilder(
            stream: FirebaseAuth.instance.onAuthStateChanged,
            builder: (ctx, userSnapshot) {
              if (userSnapshot.hasData) {
                return FeedScreen();
              } else {
                return AuthScreen();
              }
            },
          ),
        routes: {
          //   ROTAS.AUTH_HOME: (context) => AuthOrHomeScreen(),
          ROTAS.COMPARA: (context) => ComparaScooter(),
          ROTAS.DETALHE_FEED: (context) => DetalheFeedSCREEN(),
          ROTAS.DETALHE_EVENTO: (context) => DetalheEvento(),
          ROTAS.FAVORITOS: (context) => Favoritos(),
          ROTAS.GERENCIAR: (context) => GerenciarScreen(),
          ROTAS.FORMULARIOFEED: (context) => FormularioFeedScreen(),
          ROTAS.FORMULARIOEVENTO: (context) => FormularioEventoScreen(),
          ROTAS.EVENTOS: (context) => EventoScreen(),
          ROTAS.PERFIL: (context) => PerfilScreen(),
        },
      ),
    );
  }
}
