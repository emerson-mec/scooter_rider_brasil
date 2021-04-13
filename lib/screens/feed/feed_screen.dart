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
  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    FeedProvider feedProvider = Provider.of<FeedProvider>(context);
    AuthProvider authProvider = Provider.of<AuthProvider>(context);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          actions: [Icon(Icons.menu, color: Colors.black87)],
          elevation: 10,
          flexibleSpace: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/logo_srb.png', scale: 20),
                  SizedBox(width: 7),
                  Column(
                    children: [
                      Text(
                        'Scooter Rider',
                        style: TextStyle(
                          fontSize: 22,
                          fontFamily: 'Bookman',
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'B r a s i l'.toUpperCase(),
                        style: TextStyle(
                          fontSize: 8,
                          fontFamily: 'Bookman',
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          // backgroundColor: Theme.of(context).primaryColor,
          // backgroundColor: Colors.black87,
        ),

        body: FutureBuilder(
          future: authProvider.estadoUser(),
          builder: (context, snapshot) {
             if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

            String estado =  snapshot.data;
            print(estado);

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
                      return Column(
                        children: [
                          Container(
                            color: Colors.white,
                            child: CardFeedWIDGET(feedRAW[i]),
                          ),
                          SizedBox(height: 15),
                        ],
                      );
                    },
                  );
                });
          },
        ),
        backgroundColor: Colors.grey[200],
        bottomNavigationBar: MenuBottom(),
        //drawer: MeuDrawer(),
        endDrawer: MeuDrawer(),
      ),
    );
  }
}
