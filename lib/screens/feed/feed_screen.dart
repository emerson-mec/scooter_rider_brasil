import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scooter_rider_brasil/components/drawer.dart';
//SCREENS
import '../../components/feed/card_feed_widget.dart';
import '../../components/menu_bottom_widget.dart';
import '../../providers/feed_provider.dart';

class FeedScreen extends StatefulWidget {
  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {

  bool _isLoading = true;

  Future<void> _refreshProducts(BuildContext context) {
    return Provider.of<FeedProvider>(context, listen: false).loadFeed();
  }

  @override
  void initState() {
    super.initState();
    // Carregar os produtos
    Provider.of<FeedProvider>(context, listen: false).loadFeed().then((_) {
        setState(() {
        _isLoading = false; //use o CircularProgressIndicator no body
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    FeedProvider cardRaw = Provider.of<FeedProvider>(context);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          actions: [Icon(Icons.menu, color: Colors.white)],
          elevation: 1,
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
                            fontSize: 20,
                            fontFamily: 'Bookman',
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'B r a s i l'.toUpperCase(),
                        style: TextStyle(
                          fontSize: 8,
                          fontFamily: 'Bookman',
                          color: Colors.yellow[800],
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
          backgroundColor: Colors.white,
        ),
       
        body: _isLoading ? Center(child: RefreshProgressIndicator()) : RefreshIndicator(
          onRefresh: () => _refreshProducts(context),
          child: ListView.builder(
            itemCount: cardRaw.itemCount(),
            reverse: false,
            itemBuilder: (context, index) {
              return CardFeed(cardRaw.itemFeed[index]);
            },
          ),
        ),
        bottomNavigationBar: MenuBottom(),
        //drawer: MeuDrawer(),
        endDrawer: MeuDrawer(),
      ),
    );
  }
}
