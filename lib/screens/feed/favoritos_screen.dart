import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scooter_rider_brasil/components/drawer.dart';

class Favoritos extends StatelessWidget {
  final User _user = FirebaseAuth.instance.currentUser;
  
  @override
  Widget build(BuildContext context) {
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
     // body: ListView.builder(
        //itemCount: itemRaw.itemFeedFavoritos.length,
        //itemBuilder: (context, index) {
          //var item = itemRaw.itemFeedFavoritos[index];
          //return ItemFavoritos(item: item, itemRaw: itemRaw);
        //},
      //),
       //bottomNavigationBar: MenuBottom(),

        //drawer: MeuDrawer(),

       endDrawer: MeuDrawer(_user),
    );
  }
}
