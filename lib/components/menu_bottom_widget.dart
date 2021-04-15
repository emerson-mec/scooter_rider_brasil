import 'package:flutter/material.dart';
import 'package:scooter_rider_brasil/utils/rotas.dart';

class MenuBottom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // Expanded(
          //   child: IconButton(
          //     icon: Icon(
          //       FontAwesomeIcons.newspaper,
          //       color: Colors.blueGrey[800],
          //     ),
          //     onPressed: () => Navigator.of(context).popAndPushNamed('/'),
          //   ),
          // ),
          Expanded(
            child: IconButton(
              icon: Icon(Icons.compare_arrows_outlined,
                  color: Colors.blueGrey[800]),
              onPressed: () => Navigator.of(context).pushNamed('/compara'),
            ),
          ),
          Expanded(
            child: IconButton(
              icon: Icon(
                Icons.create_rounded,
                color: Colors.yellow[800],
              ),
              onPressed: () => Navigator.of(context).pushNamed(ROTAS.EVENTOS),
            ),
          ),
          // Expanded(
          //   child: IconButton(
          //     //icon: Icon(FontAwesomeIcons.bookmark, color: Colors.white),
          //     icon: Icon(Icons.star_border, color: Colors.blueGrey[800]),
          //     onPressed: () => Navigator.of(context).pushNamed(ROTAS.FAVORITOS),
          //   ),
          // ),
          // 
          
          //  Expanded(
          //   child: IconButton(
          //     icon:
          //         Icon(Icons.person, 
          //         size: 30, color: Colors.blueGrey[800]),
          //     onPressed: () {
          //        Navigator.of(context).pushNamed(ROTAS.PERFIL);
          //       Scaffold.of(context).openDrawer();
          //     },
          //   ),
          // ), 
          
          Expanded(
            child: IconButton(
              icon:
                  Icon(Icons.more_horiz, size: 30, color: Colors.blueGrey[800]),
              onPressed: () {
               
                Scaffold.of(context).openEndDrawer();
              },
            ),
          ),
         
        ],
      ),
    );
  }
}
