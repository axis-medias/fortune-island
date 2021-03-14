import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'menu_member.dart';
import 'globals.dart' as globals;
import 'appbar_draw.dart';
import 'package:awesome_page_transitions/awesome_page_transitions.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'paypal.dart';

// Create a Form widget.
class Affiche_Lots extends StatefulWidget {
  @override

  var id_type;

  Affiche_Lots({Key key, @required this.id_type}) : super(key: key);
  _Affiche_Lots_State createState() {
    return _Affiche_Lots_State();
  }
}
// Create a corresponding State class.
// This class holds data related to the form.

class _Affiche_Lots_State extends State<Affiche_Lots> {
  @override

  Future <List<ligne_lot>> Liste_Lot_Display() async {
    // SERVER LOGIN API URL
    var url = 'https://www.fortune-island.com/app/voir_lots.php';

    var data = {
      'id_membre': globals.id_membre,
      'id_type': widget.id_type,
    };

    var data_encode = jsonEncode(data);
    // Starting Web API Call.
    var response = await http.post(url,body: data_encode,headers: {'content-type': 'application/json','accept': 'application/json','authorization': globals.token});

    // Getting Server response into variable.

    print(json.decode(response.body));
    var jsondata = json.decode(response.body);

    globals.gems=num.parse(jsondata['gems']);
    globals.credits=num.parse(jsondata['credits']);

    List<ligne_lot> lines = [];
    var i=0;
    if (jsondata.containsKey('lots')) {
      for (var u in jsondata['lots']) {
        i = i + 1;
        ligne_lot line = ligne_lot(
            u["id"], u["libelle_lot"], u["visuel_lot"], u["cash"], u["type"],
            u["nbgems"]);
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
              drawer: new DrawerOnly(className: Affiche_Lots(id_type: widget.id_type)),
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
                                    "Aucun lot pour le moment !!!", style: TextStyle(
                                    color: Colors.white))
                            )
                        );
                      }
                      else {
                        return Container(
                            child: ListView.builder(
                                itemCount: snapshot.data.length,
                                scrollDirection: Axis.vertical,
                                itemBuilder: (BuildContext context, int index) {
                                  return Column(
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
                                        child : new Text(snapshot.data[index].libelle_lot,textAlign: TextAlign.center,style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.w500,color: Colors.white),),
                                      ),
                                  Container(
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
                                    SizedBox(height: 10.0),
                                      Image.network(snapshot.data[index].visuel_lot),
                                      SizedBox(height: 10.0),
                                    Center(
                                        child: RichText(
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                  text: "PRIX EN GEMS MINIMUM : "+snapshot.data[index].nbgems+" ",
                                                  style: TextStyle(fontSize: 15,fontWeight: FontWeight.w800,color: Colors.black)
                                              ),
                                              WidgetSpan(
                                                  child: Icon(FontAwesomeIcons.solidGem,color: Colors.blue[800],size: 15)
                                              ),
                                            ],
                                          ),
                                        )
                                    ),
                                    SizedBox(height: 10.0),
                                    creer_widget(num.parse(snapshot.data[index].nbgems),num.parse(snapshot.data[index].id_lot)),
                                    ],
                                  )
                                  )
                                  ]
                                  );
                                }
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

  creer_widget(num nb_gems,num id_lot) {

    print(globals.gems.toString());
    if (nb_gems<=globals.gems) {
      if (id_lot==1) {
        return RaisedButton(
          color: Colors.green,
          textColor: Colors.white,
          padding: EdgeInsets.fromLTRB(
              9, 9, 9, 9),
          child: Text(
              'COMMANDEZ CE LOT'),
          onPressed: () {
            Navigator.push(context,
                AwesomePageRoute(
                  transitionDuration: Duration(milliseconds: 600),
                  exitPage: widget,
                  enterPage: Affiche_Paypal(nbg: nb_gems),
                  transition: CubeTransition(),
                )
            );
          },
        );
      }
    }
    else {
      return Text("Vous ne disposez pas d'assez de GEMS !",style: TextStyle(color: Colors.black));
    }
  }
}

class ligne_lot {

  final String id_lot;
  final String libelle_lot;
  final String visuel_lot;
  final String cash;
  final String type;
  final String nbgems;

  const ligne_lot(this.id_lot,this.libelle_lot,this.visuel_lot,this.cash,this.type,this.nbgems);

}