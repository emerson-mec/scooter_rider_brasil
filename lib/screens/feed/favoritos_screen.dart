import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scooter_rider_brasil/components/drawer.dart';
import 'package:scooter_rider_brasil/components/item-tile_favoritos.dart';
import 'package:scooter_rider_brasil/providers/feed_provider.dart';

class Favoritos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var itemRaw = Provider.of<FeedProvider>(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        flexibleSpace: Padding(
          padding: const EdgeInsets.only(top: 35.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/logo_srb.png', scale: 20),
              SizedBox(width: 7),
              Text(
                'Favoritos',
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Bookman',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: itemRaw.itemFeedFavoritos.length,
        itemBuilder: (context, index) {
          var item = itemRaw.itemFeedFavoritos[index];
          return ItemFavoritos(item: item, itemRaw: itemRaw);
        },
      ),
       //bottomNavigationBar: MenuBottom(),

        //drawer: MeuDrawer(),

       endDrawer: MeuDrawer(),
    );
  }
}
