import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scooter_rider_brasil/providers/auth.dart';
import 'package:scooter_rider_brasil/providers/evento_provider.dart';
import 'package:scooter_rider_brasil/screens/auth-or-home_screen.dart';
import 'package:scooter_rider_brasil/screens/eventos/form_evento_screen.dart';
import 'screens/eventos/eventos_screen.dart';
import 'utils/rotas.dart';
import 'providers/feed_provider.dart';

//SCREENS
import 'screens/compara_screen.dart';
import 'screens/feed/favoritos_screen.dart';
import 'screens/eventos/detalhe_evento_screen.dart';
import 'screens/feed/detalhe_feed_screen.dart';
import 'screens/feed/form_feed_screen.dart';
import 'screens/gerenciar_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Auth()),
        ChangeNotifierProxyProvider<Auth, FeedProvider>(
          create: (_) => FeedProvider(),
          update: (ctx, Auth auth, FeedProvider feedPreview) =>
              FeedProvider(auth.token, auth.userId, feedPreview.itemFeed),
        ),
        ChangeNotifierProxyProvider<Auth, EventoProvider>(
          create: (_) => EventoProvider(),
          update: (ctx, auth, EventoProvider eventoPreview) =>
              EventoProvider(auth.token, eventoPreview.itemEvento),
        ),
      ],
      child: MaterialApp(
        title: 'Scooter Ride Brasil',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Color(0xFFffb300),
          accentColor: Colors.deepPurple,
          buttonTheme: ButtonTheme.of(context).copyWith(
            buttonColor: Colors.black,
            textTheme: ButtonTextTheme.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          //cor do menu
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
        routes: {
          ROTAS.AUTH_HOME: (context) => AuthOrHomeScreen(),
          ROTAS.COMPARA: (context) => ComparaScooter(),
          ROTAS.DETALHE_FEED: (context) => DetalheFeed(),
          ROTAS.DETALHE_EVENTO: (context) => DetalheEvento(),
          ROTAS.FAVORITOS: (context) => Favoritos(),
          ROTAS.GERENCIAR: (context) => GerenciarScreen(),
          ROTAS.FORMULARIOFEED: (context) => FormularioFeedScreen(),
          ROTAS.FORMULARIOEVENTO: (context) => FormularioEventoScreen(),
          ROTAS.EVENTOS: (context) => EventoScreen(),
        },
      ),
    );
  }
}
