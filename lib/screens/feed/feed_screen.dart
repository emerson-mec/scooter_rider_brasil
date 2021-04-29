import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scooter_rider_brasil/components/drawer.dart';
import 'package:scooter_rider_brasil/models/feed_model.dart';
import 'package:scooter_rider_brasil/providers/auth_provider.dart';
import 'package:scooter_rider_brasil/providers/feed_provider.dart';
//SCREENS
import '../../components/feed/card_feed_widget.dart';
import '../../components/menu_bottom_widget.dart';

class FeedScreen extends StatefulWidget {
  final User _user;
  FeedScreen(this._user);

  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {


  @override
  Widget build(BuildContext context) {
    FeedProvider feedProvider = Provider.of<FeedProvider>(context);
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
     
    return Scaffold(
      appBar: AppBar(
        actions: [Icon(Icons.menu, color: Colors.white), ],
        elevation: 5,
        backgroundColor: Colors.white,
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
        child: StreamBuilder(
          stream: authProvider.userColecao(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            //snapshot.data.clear();
            final String estado = snapshot.data['estado'];

            return StreamBuilder(
              stream: feedProvider.loadFeed('EstadosFeed.$estado'),
              builder: (ctx, AsyncSnapshot<List<FeedMODEL>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                List<FeedMODEL> feedRAW = snapshot.data;

                return ListView.builder(
                  itemCount: feedRAW.length,
                  reverse: false,
                  itemBuilder: (context, i) {
                    return CardFeedWIDGET(feedRAW[i]);
                  },
                );
              },
            );
          },
        ),
      ),
      backgroundColor: Colors.grey[200],
      bottomNavigationBar: MenuBottom(widget._user),
      //drawer: MeuDrawer(),
      endDrawer: MeuDrawer(widget._user),
    );
  }
}
