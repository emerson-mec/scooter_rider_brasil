import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scooter_rider_brasil/components/auth_card.dart';
import 'package:scooter_rider_brasil/providers/auth.dart';

class AuthScrenn extends StatefulWidget {
  @override
  _AuthScrennState createState() => _AuthScrennState();
}

class _AuthScrennState extends State<AuthScrenn> {
  bool showLogo = true;
  @override
  Widget build(BuildContext context) {
    
    void _handleSubmit(Auth authData) {
      if (authData.isLogin) {
        //  print('Está no login');
      } else {
        //  print('Está no cadastro');

      }
    }
   
    void _mostraLogo(booleano) {
      setState(() {
        showLogo = !showLogo;
      });
    }

      

    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: Theme.of(context).primaryColor,
          ),
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                colorFilter: ColorFilter.mode(
                  Color.fromRGBO(255, 255, 255, 0.7),
                  BlendMode.modulate,
                ),
                alignment: Alignment.bottomCenter,
                fit: BoxFit.fill,
                image: AssetImage('assets/image/background.jpg'),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 20),
            width: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * .07),
                 if(showLogo) Container(
                    height: MediaQuery.of(context).size.width*0.22,
                    child: Image.asset('assets/logo_srb2.png'),
                  ),
                 if(showLogo) Text(
                    'Scooter Rider',
                    style: GoogleFonts.blackOpsOne(
                      textStyle: TextStyle(
                          color: Colors.black87,
                          letterSpacing: .5,
                          fontSize: MediaQuery.of(context).size.width*0.1,
                        ),
                    ),
                  ),
                  if(showLogo)  SizedBox(height: 40),
                  if(!showLogo) Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: Text('Criar conta',style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
                  ),
                  AuthForm(_handleSubmit, _mostraLogo),
                  SizedBox(height: 300),
                  AuthCard(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
