import 'package:flutter/material.dart';
import 'package:gameapp/lot_boutique.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'menu_member.dart';
import 'globals.dart' as globals;
import 'appbar_draw.dart';
import 'package:awesome_page_transitions/awesome_page_transitions.dart';
import 'detail_commandes.dart';

// Create a Form widget.
class Affiche_Boutique extends StatefulWidget {
  @override
  _Affiche_Boutique_State createState() {
    return _Affiche_Boutique_State();
  }
}
// Create a corresponding State class.
// This class holds data related to the form.

  class _Affiche_Boutique_State extends State<Affiche_Boutique> {
  @override

  Future <List<ligne_categorie>> Liste_Lot_Display() async {
    // SERVER LOGIN API URL
    var url = 'https://www.fortune-island.com/app/voir_type_lots.php';
    // Starting Web API Call.
    var data = {
      'id_membre': globals.id_membre
    };

    var data_encode = jsonEncode(data);
    // Starting Web API Call.
    var response = await http.post(url,body: data_encode,headers: {'content-type': 'application/json','accept': 'application/json','authorization': globals.token});

    // Getting Server response into variable.

    print(json.decode(response.body));
    var jsondata = json.decode(response.body);

    globals.gems=num.parse(jsondata['gems']);
    globals.credits=num.parse(jsondata['credits']);

    List<ligne_categorie> lines = [];
    var i=0;
    if (jsondata.containsKey('typel')) {
      for (var u in jsondata['typel']) {
        i = i + 1;
        ligne_categorie line = ligne_categorie(u["id"], u["libelle"]);
        lines.add(line);
      }
    }
    return lines;
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
    drawer: new DrawerOnly(className: Affiche_Boutique()),
  body:
        FutureBuilder(
            future: Liste_Lot_Display(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              } else {
                if (snapshot.data.isEmpty) {
                  return Container(
                      child: Center(
                          child: Text(
                              "Aucun catégorie de lot pour le moment !!!", style: TextStyle(
                              color: Colors.white))
                      )
                  );
                }
                else {
                  return Center(
                      child:
                      Column(children: <Widget>[
                        Container(
                            height: 50,
                            width: MediaQuery.of(context).size.width,
                            padding : EdgeInsets.only(left: 20, right:20),
                            margin: EdgeInsets.only(top:10),
                            color: Colors.blue[700],
                            child: Center(
                                child:
                                Text("BOUTIQUE",style: TextStyle(fontSize: 13, color: Colors.white))
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
                                'VOIR VOS DEMANDES DE LOT'),
                            onPressed: () {
                              Navigator.push(context,
                                  AwesomePageRoute(
                                    transitionDuration: Duration(milliseconds: 600),
                                    exitPage: widget,
                                    enterPage: Affiche_Commandes(),
                                    transition: CubeTransition(),
                                  )
                              );
                            },
                          ),
                        ),
                        Expanded(
                      child: ListView.builder(
                          itemCount: snapshot.data.length,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (BuildContext context, int index) {
                            return new Column(
                              children: <Widget>[
                                Container(
                                  height: 30,
                                  width: MediaQuery.of(context).size.width,
                                  margin: EdgeInsets.only(left:20,right:20,top:20),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.blue[700],
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.only(topLeft : Radius.circular(25),topRight: Radius.circular(25)),
                                      color: Colors.blue[700]
                                  ),
                                  child : new Text(snapshot.data[index].libelle,textAlign: TextAlign.center,style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.w500,color: Colors.white),),
                                ),
                                Container(
                                    height:70,
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
                                        child : RaisedButton(
                                          color: Colors.green,
                                          textColor: Colors.white,
                                          padding: EdgeInsets.fromLTRB(
                                              9, 9, 9, 9),
                                          child: Text(
                                              'VOIR LES LOTS'),
                                          onPressed: () {
                                            Navigator.push(context,
                                                AwesomePageRoute(
                                                  transitionDuration: Duration(milliseconds: 600),
                                                  exitPage: widget,
                                                  enterPage: Affiche_Lots(id_type: snapshot.data[index].idc),
                                                  transition: CubeTransition(),
                                                )
                                            );
                                          },
                                        ),
                                      )
                                    ]
                                    )
                                ),
                              ],
                            );
                          }
                      )
                  )
                  ]
              )
                  );
                }
              }
            }
        )
  )
    ]
  );
  }
  }

class ligne_categorie {

  final String idc;
  final String libelle;

  const ligne_categorie(this.idc,this.libelle);

}