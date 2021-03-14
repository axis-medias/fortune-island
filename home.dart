import 'package:flutter/material.dart';
import 'package:gameapp/jouer_grattage.dart';
import 'login.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'menu_member.dart';
import 'globals.dart' as globals;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'appbar_draw.dart';
import 'liste_tombolas.dart';
import 'package:awesome_page_transitions/awesome_page_transitions.dart';
import 'liste_grille_lotto.dart';
import 'grille_lotosport.dart';
import 'liste_pronostics.dart';
import 'win_credit.dart';

class HomePage extends StatefulWidget {

  HomePage_State createState() {
    return HomePage_State();
  }

}

class HomePage_State extends State<HomePage> {
// User Logout Function.
  Future logout(BuildContext context) async {

    final storage = new FlutterSecureStorage();

    await storage.deleteAll();

    globals.id_membre="";

    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginPage())
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[
                  Colors.blue[300],Colors.blue[400]
                ],
              ),
            ),
          ),
          Scaffold(
            appBar: drawappbar(true),
            backgroundColor: Colors.transparent,
            drawer: new DrawerOnly(className: HomePage()),
            body: Center(
                child:
                Column(children: <Widget>[
                  Expanded(
                      child : ListView(
                          children : <Widget>[
                  Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      padding : EdgeInsets.only(left: 20, right:20),
                      margin: EdgeInsets.only(top:10),
                      color: Colors.blue[700],
                      child: Center(
                          child:
                          Text("GAGNEZ DES JETONS",style: TextStyle(fontSize: 13, color: Colors.white))
                      )
                  ),
                  Container(
                    margin: EdgeInsets.only(top:10),
                    child : RaisedButton(
                      color: Colors.green,
                      textColor: Colors.white,
                      padding: EdgeInsets.fromLTRB(
                          9, 9, 9, 9),
                      child: Text(
                          'CLIQUEZ ICI'),
                      onPressed: () {
                        Navigator.push(context,
                            AwesomePageRoute(
                              transitionDuration: Duration(milliseconds: 600),
                              exitPage: widget,
                              enterPage: Credit(),
                              transition: CubeTransition(),
                            )
                        );
                      },
                    ),
                  ),
                  Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      padding : EdgeInsets.only(left: 20, right:20),
                      margin: EdgeInsets.only(top:0,bottom:20),
                      color: Colors.blue[700],
                      child: Center(
                          child:
                          Text("JOUEZ VOS JETONS SUR NOS JEUX",style: TextStyle(fontSize: 13, color: Colors.white))
                      )
                  ),
                            Container(
                              height: 30,
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.only(left:20,right:20),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.blue[700],
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.only(topLeft : Radius.circular(25),topRight: Radius.circular(25)),
                                  color: Colors.blue[700]
                              ),
                              child : new Text("TOMBOLA",textAlign: TextAlign.center,style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.w500,color: Colors.white),),
                            ),
                            Container(
                                height:100,
                                width: MediaQuery.of(context).size.width,
                                margin: EdgeInsets.only(bottom:20,left:20,right:20),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey[500],
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.only(bottomLeft : Radius.circular(25),bottomRight: Radius.circular(25)),
                                  color:Colors.white,
                                ),
                                child: Column(children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(top:10),
                                  child:
                                  Text("GAGNEZ JUSQU'A 1 000 000 € !!!",textAlign: TextAlign.center,style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.w500,color: Colors.black)),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top:10),
                                    child : RaisedButton(
                                      color: Colors.green,
                                      textColor: Colors.white,
                                      padding: EdgeInsets.fromLTRB(
                                          9, 9, 9, 9),
                                      child: Text(
                                          'PARTICIPEZ'),
                                      onPressed: () {
                                        Navigator.push(context,
                                            AwesomePageRoute(
                                              transitionDuration: Duration(milliseconds: 600),
                                              exitPage: widget,
                                              enterPage: Affiche_Liste_Tombola(),
                                              transition: CubeTransition(),
                                            )
                                        );
                                      },
                                    ),
                                  )
                                  ]
                                )
                            ),
                            Container(
                              height: 30,
                              margin: EdgeInsets.only(left:20,right:20),
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.blue[700],
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.only(topLeft : Radius.circular(25),topRight: Radius.circular(25)),
                                  color: Colors.blue[700]
                              ),
                              child : new Text("LOTO",textAlign: TextAlign.center,style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.w500,color: Colors.white),),
                            ),
                            Container(
                                height: 100,
                                width: MediaQuery.of(context).size.width,
                                margin: EdgeInsets.only(bottom:20,left:20,right:20),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey[500],
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.only(bottomLeft : Radius.circular(25),bottomRight: Radius.circular(25)),
                                  color:Colors.white,
                                ),
                                child: Column(children: <Widget>[
                            Container(
                            margin: EdgeInsets.only(top:10),
                                child:
                                Text("CHOISISSEZ 5 NUMEROS SUR 49",textAlign: TextAlign.center,style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.w500,color: Colors.black)),
                              ),
                              Container(
                                margin: EdgeInsets.only(top:10),
                                child : RaisedButton(
                                  color: Colors.green,
                                  textColor: Colors.white,
                                  padding: EdgeInsets.fromLTRB(
                                      9, 9, 9, 9),
                                  child: Text(
                                      'PARTICIPEZ'),
                                  onPressed: () {
                                    Navigator.push(context,
                                        AwesomePageRoute(
                                          transitionDuration: Duration(milliseconds: 600),
                                          exitPage: widget,
                                          enterPage: Affiche_Liste_Lotto(),
                                          transition: CubeTransition(),
                                        )
                                    );
                                  },
                                ),
                              )
                            ]
                            )
                            ),
                            Container(
                              height: 30,
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.only(left:20,right:20),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.blue[700],
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.only(topLeft : Radius.circular(25),topRight: Radius.circular(25)),
                                  color: Colors.blue[700]
                              ),
                              child : new Text("PRONOSTICS SPORTIFS",textAlign: TextAlign.center,style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.w500,color: Colors.white),),
                            ),
                            Container(
                                height: 200,
                                width: MediaQuery.of(context).size.width,
                                margin: EdgeInsets.only(bottom:20, right:20, left:20),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey[500],
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.only(bottomLeft : Radius.circular(25),bottomRight: Radius.circular(25)),
                                  color:Colors.white,
                                ),
                                child: Column(children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(top:10),
                                    child:
                                    Text("GRILLE LOTOSPORT",textAlign: TextAlign.center,style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.w500,color: Colors.black)),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top:10),
                                    child : RaisedButton(
                                      color: Colors.green,
                                      textColor: Colors.white,
                                      padding: EdgeInsets.fromLTRB(
                                          9, 9, 9, 9),
                                      child: Text(
                                          'JOUEZ AU LOTOSPORT'),
                                      onPressed: () {
                                        Navigator.push(context,
                                            AwesomePageRoute(
                                              transitionDuration: Duration(milliseconds: 600),
                                              exitPage: widget,
                                              enterPage: Affiche_Liste_grille(),
                                              transition: CubeTransition(),
                                            )
                                        );
                                      },
                                    ),
                                  ),
                                  const Divider(
                                    color: Colors.black,
                                    height: 10,
                                    thickness: 1,
                                    indent: 0,
                                    endIndent: 0,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top:10),
                                    child:
                                    Text("PRONOSTIQUEZ DES MATCHS",textAlign: TextAlign.center,style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.w500,color: Colors.black)),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top:10),
                                    child : RaisedButton(
                                      color: Colors.green,
                                      textColor: Colors.white,
                                      padding: EdgeInsets.fromLTRB(
                                          9, 9, 9, 9),
                                      child: Text(
                                          'JOUEZ A LOTOMATCH'),
                                      onPressed: () {
                                        Navigator.push(context,
                                            AwesomePageRoute(
                                              transitionDuration: Duration(milliseconds: 600),
                                              exitPage: widget,
                                              enterPage: Affiche_Matchs(),
                                              transition: CubeTransition(),
                                            )
                                        );
                                      },
                                    ),
                                  ),
                                ]
                                )
                            ),
                            Container(
                              height: 30,
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.only(left:20,right:20),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.blue[700],
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.only(topLeft : Radius.circular(25),topRight: Radius.circular(25)),
                                  color: Colors.blue[700]
                              ),
                              child : new Text("TICKETS A GRATTER",textAlign: TextAlign.center,style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.w500,color: Colors.white),),
                            ),
                            Container(
                                height:100,
                                width: MediaQuery.of(context).size.width,
                                margin: EdgeInsets.only(bottom:20,left:20,right:20),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey[500],
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.only(bottomLeft : Radius.circular(25),bottomRight: Radius.circular(25)),
                                  color:Colors.white,
                                ),
                                child: Column(children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(top:10),
                                    child:
                                    Text("GRATTEZ ET GAGNEZ DES GEMS !!!",textAlign: TextAlign.center,style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.w500,color: Colors.black)),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top:10),
                                    child : RaisedButton(
                                      color: Colors.green,
                                      textColor: Colors.white,
                                      padding: EdgeInsets.fromLTRB(
                                          9, 9, 9, 9),
                                      child: Text(
                                          'PARTICIPEZ'),
                                      onPressed: () {
                                        Navigator.push(context,
                                            AwesomePageRoute(
                                              transitionDuration: Duration(milliseconds: 600),
                                              exitPage: widget,
                                              enterPage: ParamGrattage(),
                                              transition: CubeTransition(),
                                            )
                                        );
                                      },
                                    ),
                                  )
                                ]
                                )
                            ),
                          ]
                      )
                  )
                ],
                )
            )
        )
    ]
    );
  }
}