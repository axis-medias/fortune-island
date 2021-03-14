import 'package:flutter/material.dart';
import 'package:gameapp/jouer_grattage.dart';
import 'grille_lotosport.dart';
import 'liste_tombolas.dart';
import 'login.dart';
import 'home.dart';
import 'liste_grille_lotto.dart';
import 'liste_pronostics.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'globals.dart' as globals;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'boutique.dart';
import 'detail_solde.dart';
import 'detail_jetons.dart';
import 'parrainage.dart';
import 'profil.dart';
import 'win_credit.dart';
import 'modify_pass.dart';
import 'package:awesome_page_transitions/awesome_page_transitions.dart';

class DrawerOnly extends StatefulWidget {
  final Widget className;
  DrawerOnly({this.className});
  @override
  DrawerOnly_State createState() => DrawerOnly_State();
}

class DrawerOnly_State extends State<DrawerOnly> {
  @override
  Widget build (BuildContext ctxt) {
    num gems_f=globals.gems;
    num credits_f=globals.credits;

    return new Drawer(
        child: new ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            new DrawerHeader(
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(5),
                    child: Icon(
                        FontAwesomeIcons.userAlt,
                        size: 50,
                        color: Colors.white
                    ),
                  ),
                  Container(
                      width: 200,
                      height:30,
                      margin : EdgeInsets.only(bottom:15),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Center(
                          child: RichText(
                            text: TextSpan(
                              children: [
                                WidgetSpan(
                                    child: Icon(FontAwesomeIcons.coins,color: Colors.amber[200],size: 20)
                                ),
                                TextSpan(
                                    text: " "+credits_f.toString(),
                                    style: TextStyle(fontSize: 20,fontWeight: FontWeight.w800,color: Colors.white)
                                ),
                              ],
                            ),
                          )
                      )
                  ),
                  Container(
                      width: 200,
                      height:30,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Center(
                          child: RichText(
                            text: TextSpan(
                              children: [
                                WidgetSpan(
                                    child: Icon(FontAwesomeIcons.solidGem,color: Colors.amber[200],size: 20)
                                ),
                                TextSpan(
                                    text: " "+gems_f.toString(),
                                    style: TextStyle(fontSize: 20,fontWeight: FontWeight.w800,color: Colors.white)
                                ),
                              ],
                            ),
                          )
                      )
                  ),
                  ],
              ),
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: <Color>[
                      Colors.blue[400],Colors.blue[600],Colors.blue[800]
                    ],
                  ),
                  color: Colors.lightBlue,
                  borderRadius: new BorderRadius.only(
                  bottomLeft:  const  Radius.circular(25.0),
                  bottomRight: const  Radius.circular(25.0)
                  )
              ),
            ),
            new ListTile(
              leading: new Icon(FontAwesomeIcons.home),
              title: new Text("ACCUEIL"),
              onTap: () {
                Navigator.pop(ctxt);
                Navigator.push(ctxt,
                    AwesomePageRoute(
                      transitionDuration: Duration(milliseconds: 600),
                      exitPage: widget.className,
                      enterPage: HomePage(),
                      transition: CubeTransition(),
                    )
                );
              },
            ),
            new ExpansionTile(
            leading: new Icon(FontAwesomeIcons.userCircle),
            title: Text("PROFIL"),
            children: <Widget>[
              new ListTile(
                leading: new Icon(FontAwesomeIcons.info),
                title: new Text("VOS INFOS"),
                onTap: () {
                  Navigator.pop(ctxt);
                  Navigator.push(ctxt,
                      AwesomePageRoute(
                        transitionDuration: Duration(milliseconds: 600),
                        exitPage: widget.className,
                        enterPage: Affiche_Profil(),
                        transition: CubeTransition(),
                      )
                  );
                },
              ),
              new ListTile(
                leading: new Icon(FontAwesomeIcons.userSecret),
                title: new Text("MOT DE PASSE"),
                onTap: () {
                  Navigator.pop(ctxt);
                  Navigator.push(ctxt,
                      AwesomePageRoute(
                        transitionDuration: Duration(milliseconds: 600),
                        exitPage: widget.className,
                        enterPage: Modifier_Passe(),
                        transition: CubeTransition(),
                      )
                  );
                },
              ),
              new ListTile(
                leading: new Icon(FontAwesomeIcons.users),
                title: new Text("PARRAINAGE"),
                onTap: () {
                  Navigator.pop(ctxt);
                  Navigator.push(ctxt,
                      AwesomePageRoute(
                        transitionDuration: Duration(milliseconds: 600),
                        exitPage: widget.className,
                        enterPage: Affiche_Parrainage(),
                        transition: CubeTransition(),
                      )
                  );
                },
              ),
              new ListTile(
                leading: new Icon(FontAwesomeIcons.coins),
                title: new Text("VOS JETONS"),
                onTap: () {
                  Navigator.pop(ctxt);
                  Navigator.push(ctxt,
                      AwesomePageRoute(
                        transitionDuration: Duration(milliseconds: 600),
                        exitPage: widget.className,
                        enterPage: Affiche_Jetons(),
                        transition: CubeTransition(),
                      )
                  );
                },
              ),
            new ListTile(
              leading: new Icon(FontAwesomeIcons.gem),
              title: new Text("VOS GEMS"),
              onTap: () {
                Navigator.pop(ctxt);
                Navigator.push(ctxt,
                    AwesomePageRoute(
                      transitionDuration: Duration(milliseconds: 600),
                      exitPage: widget.className,
                      enterPage: Affiche_Solde(),
                      transition: CubeTransition(),
                    )
                );
              },
            ),
            ]
            ),
            new ListTile(
              leading: new Icon(FontAwesomeIcons.coins),
              title: new Text("GAGNEZ DES JETONS"),
              onTap: () {
                Navigator.pop(ctxt);
                Navigator.push(ctxt,
                    AwesomePageRoute(
                      transitionDuration: Duration(milliseconds: 600),
                      exitPage: widget.className,
                      enterPage: Credit(),
                      transition: CubeTransition(),
                    )
                );
              },
            ),
            new ExpansionTile(
              leading: new Icon(FontAwesomeIcons.play),
              title: Text("NOS JEUX"),
              children: <Widget>[
                new ListTile(
                  title: new Text("LOTOSPORT"),
                  onTap: () {
                    Navigator.pop(ctxt);
                    Navigator.push(ctxt,
                        AwesomePageRoute(
                          transitionDuration: Duration(milliseconds: 600),
                          exitPage: widget.className,
                          enterPage: Affiche_Liste_grille(),
                          transition: CubeTransition(),
                        )
                    );
                  },
                ),
                new ListTile(
                  title: new Text("PRONOSTICS"),
                  onTap: () {
                    Navigator.pop(ctxt);
                    Navigator.push(ctxt,
                        AwesomePageRoute(
                          transitionDuration: Duration(milliseconds: 600),
                          exitPage: widget.className,
                          enterPage: Affiche_Matchs(),
                          transition: CubeTransition(),
                        )
                    );
                  }
                ),
                new ListTile(
                  title: new Text("LOTERIE"),
                  onTap: () {
                    Navigator.pop(ctxt);
                    Navigator.push(ctxt,
                        AwesomePageRoute(
                          transitionDuration: Duration(milliseconds: 600),
                          exitPage: widget.className,
                          enterPage: Affiche_Liste_Lotto(),
                          transition: CubeTransition(),
                        )
                    );
                  },
                ),
                new ListTile(
                  title: new Text("TOMBOLA"),
                  onTap: () {
                    Navigator.pop(ctxt);
                    Navigator.push(ctxt,
                        AwesomePageRoute(
                          transitionDuration: Duration(milliseconds: 600),
                          exitPage: widget.className,
                          enterPage: Affiche_Liste_Tombola(),
                          transition: CubeTransition(),
                        )
                    );
                  },
                ),
                new ListTile(
                  title: new Text("TICKET A GRATTER"),
                  onTap:() {
                    Navigator.pop(ctxt);
                    Navigator.push(ctxt,
                        AwesomePageRoute(
                          transitionDuration: Duration(milliseconds: 600),
                          exitPage: widget.className,
                          enterPage: ParamGrattage(),
                          transition: CubeTransition(),
                        )
                    );
                  }
                )
              ],
            ),
            new ListTile(
              leading: new Icon(FontAwesomeIcons.store),
              title: new Text("BOUTIQUE"),
              onTap: () {
                Navigator.pop(ctxt);
                Navigator.push(ctxt,
                    AwesomePageRoute(
                      transitionDuration: Duration(milliseconds: 600),
                      exitPage: widget.className,
                      enterPage: Affiche_Boutique(),
                      transition: CubeTransition(),
                    )
                );
              },
            ),
            new ListTile(
              leading: new Icon(FontAwesomeIcons.signOutAlt),
              title: new Text("DECONNEXION"),
              onTap: () async {
                final storage = new FlutterSecureStorage();

                await storage.deleteAll();

                globals.id_membre="";
                globals.token="";
                globals.credits=0;
                globals.gems=0;

                Navigator.pop(ctxt);
                Navigator.push(ctxt,
                    AwesomePageRoute(
                      transitionDuration: Duration(milliseconds: 600),
                      exitPage: widget.className,
                      enterPage: LoginPage(),
                      transition: CubeTransition(),
                    )
                );
              },
            ),
          ],
        )
    );
  }
}