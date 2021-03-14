import 'package:flutter/material.dart';
import 'grid.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'menu_member.dart';
import 'globals.dart' as globals;
import 'appbar_draw.dart';
import 'package:awesome_page_transitions/awesome_page_transitions.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

// Create a Form widget.
class Affiche_Liste_grille extends StatefulWidget {
  @override
  _Affiche_Liste_grille_State createState() {
    return _Affiche_Liste_grille_State();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.

class _Affiche_Liste_grille_State extends State<Affiche_Liste_grille> {
  @override

  double prix=0.00;

  Future<List<Grille>> Listgrid;

  Future<Jack> jackpot;

  Future <Jack> Get_Amount_Jackpot() async {
    // SERVER LOGIN API URL
    var url2 = 'https://www.fortune-island.com/app/get_jackpot_lottosport.php';

    // Starting Web API Call.
    var response2 = await http.get(url2,headers: {'content-type': 'application/json','accept': 'application/json','authorization': globals.token});

    // Getting Server response into variable.
    Jack jackpots;

    var jsondata2 = json.decode(response2.body);

    String jackpot7;
    String jackpot14;

    for (var u in jsondata2) {
      jackpot7=u["j7"].toString();
      jackpot14=u["j14"].toString();
    }

    jackpots=Jack(jackpot7, jackpot14);

    return jackpots;

  }

  Future <List<Grille>> Grille_display() async {
    // SERVER LOGIN API URL
    var url = 'https://www.fortune-island.com/app/display_list_grid.php';

    var data = {
      'id_membre': globals.id_membre,
    };

    var data_encode = jsonEncode(data);

    // Starting Web API Call.
    var response = await http.post(url,body: data_encode,headers: {'content-type': 'application/json','accept': 'application/json','authorization': globals.token});

    // Getting Server response into variable.

    var jsondata = json.decode(response.body);

    globals.gems=num.parse(jsondata['gems']);
    globals.credits=num.parse(jsondata['credits']);

    List<Grille> Grilles = [];
    if (jsondata.containsKey('lotosport')) {
      for (var u in jsondata['lotosport']) {
        Grille grille = Grille(
            u["id"], u["libelle"], u["date_debut_validation"],
            u["date_fin_validation"], u["prix_gem"], u["nb_match"]);
        Grilles.add(grille);
      }
    }
    return Grilles;
  }

  void initState() {
    Listgrid = Grille_display();
    jackpot = Get_Amount_Jackpot();
    super.initState();
  }

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
            drawer: new DrawerOnly(className: Affiche_Liste_grille()),
            body: Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child:
                      FutureBuilder(
                        future: Future.wait([Listgrid,jackpot]),
                        builder: (BuildContext context, AsyncSnapshot snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.waiting:
                              return new Center(
                                child: new CircularProgressIndicator(),);
                            default:
                              if (snapshot.hasError) {
                                return new Center(
                                  child: new Text('Error: ${snapshot.error}'),);
                              }
                              else {
                                List<Grille> values = snapshot.data[0];
                                if (values.isEmpty) {
                                  return Container(
                                      child: Center(
                                          child: Text(
                                              "Aucune grille disponible !!!",style: TextStyle(color:Colors.white))
                                      )
                                  );
                                }
                                else {
                                  Jack j = snapshot.data[1];
                                  return ListView.builder(
                                      itemCount: values.length,
                                      itemBuilder: (_, index) {
                                        var jac;
                                        var nb_matchs=values[index].nb_match;
                                        if (nb_matchs=="7") {
                                          jac=double.parse(j.j7);
                                        }
                                        else {
                                          jac=double.parse(j.j14);
                                        }
                                        var f = new NumberFormat.currency(locale: "fr-FR",symbol: "",decimalDigits: 3);
                                        var jac_f=f.format(jac);
                                        print(values[index].datefin);
                                        var parsedDate = DateTime.parse(values[index].datefin);
                                        final formatter = new DateFormat('dd-MM-yyyy HH:mm');
                                        var dat = formatter.format(parsedDate);
                                        return Column(
                                            children: [
                                              Container(
                                                height: 30,
                                                width: MediaQuery
                                                    .of(context)
                                                    .size
                                                    .width * 90 / 100,
                                                margin: EdgeInsets.only(
                                                    top: 20),
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: Colors.blue[700],
                                                      width: 2,
                                                    ),
                                                    borderRadius: BorderRadius
                                                        .only(topLeft: Radius
                                                        .circular(25),
                                                        topRight: Radius
                                                            .circular(25)),
                                                    color: Colors.blue[700]
                                                ),
                                                child: new Text(
                                                  values[index].libelle,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 18.0,
                                                      fontWeight: FontWeight
                                                          .w500,
                                                      color: Colors.white),),
                                              ),
                                              Center(
                                                  child: Container(
                                                    height: MediaQuery
                                                        .of(context)
                                                        .size
                                                        .height / 4,
                                                    width: MediaQuery
                                                        .of(context)
                                                        .size
                                                        .width * 90 / 100,
                                                    margin: EdgeInsets.only(
                                                        bottom: 20),
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                        color: Colors.grey[500],
                                                        width: 2,
                                                      ),
                                                      borderRadius: BorderRadius
                                                          .only(
                                                          bottomLeft: Radius
                                                              .circular(25),
                                                          bottomRight: Radius
                                                              .circular(25)),
                                                      color: Colors.white,
                                                    ),
                                                    child:
                                                    Column(
                                                        mainAxisAlignment: MainAxisAlignment
                                                            .center,
                                                        children: [
                                                          Container(
                                                            child: RichText(
                                                              text:
                                                                TextSpan(
                                                                children: [
                                                                  TextSpan(
                                                                      text: "JACKPOT : "  +jac_f+
                                                                          " ",
                                                                      style: TextStyle(
                                                                          fontSize: 15,
                                                                          fontWeight: FontWeight
                                                                              .w800,
                                                                          color: Colors
                                                                              .black)
                                                                  ),
                                                                  WidgetSpan(
                                                                      child: Icon(
                                                                          FontAwesomeIcons
                                                                              .euroSign,
                                                                          color: Colors
                                                                              .amber[900],
                                                                          size: 20)
                                                                  ),
                                                                ],
                                                              )
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
                                                              margin : EdgeInsets.only(bottom:10),
                                                              child :
                                                              Text("Prix Ticket : "+values[index].prix+" GEMS")
                                                          ),
                                                          double.parse(values[index].prix)<=globals.credits ?
                                                          Container(
                                                            height: 50,
                                                            width: MediaQuery
                                                                .of(context)
                                                                .size
                                                                .width * 90 /
                                                                100,
                                                            child: RaisedButton(
                                                              color: Colors
                                                                  .green,
                                                              textColor: Colors
                                                                  .white,
                                                              padding: EdgeInsets
                                                                  .fromLTRB(
                                                                  9, 9, 9, 9),
                                                              child: Text(
                                                                  'VALIDER LA GRILLE'),
                                                              onPressed: () {
                                                                prix=double.parse(values[index].prix);
                                                                if (prix>globals.credits) {
                                                                  AwesomeDialog(context: context,
                                                                      useRootNavigator: true,
                                                                      dialogType: DialogType.ERROR,
                                                                      animType: AnimType.BOTTOMSLIDE,
                                                                      tittle: "INFORMATION",
                                                                      desc: "Vous ne disposez pas d'assez de GEMS !",
                                                                      btnOkOnPress: () {

                                                                      }).show();
                                                                }
                                                                else {
                                                                Navigator.push(
                                                                  context,
                                                                  AwesomePageRoute(
                                                                    transitionDuration: Duration(
                                                                        milliseconds: 600),
                                                                    exitPage: widget,
                                                                    enterPage: Affiche_grille(
                                                                        id: values[index]
                                                                            .id),
                                                                    transition: CubeTransition(),
                                                                  ),
                                                                );
                                                                }
                                                              },
                                                            ),
                                                          )
                                                              :
                                                          Container(
                                                              child :
                                                              Text("")
                                                          ),
                                                          const Divider(
                                                            color: Colors.black,
                                                            height: 10,
                                                            thickness: 1,
                                                            indent: 0,
                                                            endIndent: 0,
                                                          ),
                                                          Container(
                                                            margin: EdgeInsets
                                                                .only(
                                                                bottom: 10),
                                                            height: 20,
                                                            child:
                                                            Text(
                                                                "DATE LIMITE DE VALIDATION",
                                                                style: TextStyle(
                                                                    fontWeight: FontWeight
                                                                        .w500,
                                                                    color: Colors
                                                                        .black)
                                                            ),
                                                          ),
                                                          Container(
                                                            margin: EdgeInsets
                                                                .only(
                                                                bottom: 10),
                                                            height:20,
                                                            child:
                                                            Text(dat,
                                                                style: TextStyle(
                                                                    fontWeight: FontWeight
                                                                        .w500,
                                                                    color: Colors
                                                                        .black)
                                                            ),
                                                          ),
                                                        ]
                                                    ),
                                                  )
                                              )
                                            ]
                                        );
                                      }
                                  );
                                }
                              }
                          }
                        }
                  ),
                  )
            )
    ]
    );
  }
}

class Grille {

  final String id;
  final String libelle;
  final String datedebut;
  final String datefin;
  final String prix;
  final String nb_match;

  const Grille(this.id, this.libelle, this.datedebut,this.datefin,this.prix,this.nb_match);

}

class Jack {

  final String j7;
  final String j14;

  const Jack(this.j7,this.j14);
}