import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'menu_member.dart';
import 'globals.dart' as globals;
import 'appbar_draw.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

// Create a Form widget.
class Affiche_Commandes extends StatefulWidget {
  @override

  _Affiche_Commandes_State createState() {
    return _Affiche_Commandes_State();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.

class _Affiche_Commandes_State extends State<Affiche_Commandes> {
  @override

  Future<List<ligne_commande>> commandes;

  Future <List<ligne_commande>> Liste_Commandes_Display() async {
    // SERVER LOGIN API URL
    var url = 'https://www.fortune-island.com/app/detail_commandes.php';

    var data = {
      'id_membre': globals.id_membre,
    };

    var data_encode = jsonEncode(data);
    // Starting Web API Call.
    var response = await http.post(url,body: data_encode,headers: {'content-type': 'application/json','accept': 'application/json','authorization': globals.token});

    // Getting Server response into variable.

    print(response.body);
    var jsondata = json.decode(response.body);

    globals.gems=num.parse(jsondata['gems']);
    globals.credits=num.parse(jsondata['credits']);

    List<ligne_commande> lines = [];
    var i=0;
    if (jsondata.containsKey('commandes')) {
      for (var u in jsondata['commandes']) {
        i = i + 1;
        ligne_commande line = ligne_commande(
            u["dateheure"], u["gems"], u["valeur_euro"], u["libelle_lot"],
            u["etat"], u["date_heure_val"]);
        lines.add(line);
      }
    }
    return lines;
  }

  void initState() {
    commandes = Liste_Commandes_Display();
    super.initState();
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
              drawer: new DrawerOnly(className: Affiche_Commandes()),
              body:
              Container(
                  height: MediaQuery
                      .of(context)
                      .size
                      .height,
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  child:
                  FutureBuilder(
                      future: commandes,
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
                              List<ligne_commande> values = snapshot.data;
                              if (values.isEmpty) {
                                return Container(
                                    child: Center(
                                        child: Text("Aucune commande de lot  pour le moment !!!",style: TextStyle(color: Colors.white))
                                    )
                                );
                              }
                              else {
                                return ListView(
                                    children: <Widget>[
                                      Center(
                                        child: Container(
                                            margin: const EdgeInsets.only(top: 20.0),
                                            child: Text("DETAIL DE VOS COMMANDES",textAlign: TextAlign.center,style: TextStyle(fontSize: 30.0,color: Colors.white))
                                        ),
                                      ),
                                      DataTable(
                                        columnSpacing: 30,
                                        dataRowHeight: 50,
                                        columns: [
                                          DataColumn(
                                            label: Text("DATE",textAlign: TextAlign.center,style: TextStyle(color: Colors.white)),
                                            numeric: false,
                                            tooltip: "",
                                          ),
                                          DataColumn(
                                            label: Text("EUROS",textAlign: TextAlign.center,style: TextStyle(color: Colors.white)),
                                            numeric: false,
                                            tooltip: "",
                                          ),
                                          DataColumn(
                                            label: Text("LIBELLE",textAlign: TextAlign.center,style: TextStyle(color: Colors.white)),
                                            numeric: false,
                                            tooltip: "",
                                          ),
                                          DataColumn(
                                            label: Text("ETAT",textAlign: TextAlign.center,style: TextStyle(color: Colors.white)),
                                            numeric: false,
                                            tooltip: "",
                                          ),
                                          DataColumn(
                                            label: Text("VALIDATION",textAlign: TextAlign.center,style: TextStyle(color: Colors.white)),
                                            numeric: false,
                                            tooltip: "",
                                          ),
                                        ],
                                        rows: List.generate(values.length, (index) {
                                          var parsedDate = DateTime.parse(values[index].date);
                                          final formatter = new DateFormat('dd/MM/yyyy HH:mm');
                                          var dat = formatter.format(parsedDate);
                                          var datv="";
                                          if (values[index].datev!="") {
                                          var parsedDatev = DateTime.parse(values[index].datev);
                                          var datv = formatter.format(parsedDatev);
                                          }
                                          return DataRow(
                                              cells: [
                                                DataCell(
                                                  Text(dat,style: TextStyle(fontSize: 12.0,fontWeight: FontWeight.w900,color:Colors.white)),
                                                ),
                                                DataCell(
                                                    RichText(
                                                      text: TextSpan(
                                                        children: [
                                                          TextSpan(
                                                              text: values[index].cash.toString()+" ",
                                                              style: TextStyle(fontSize: 12,fontWeight: FontWeight.w800,color: Colors.white)
                                                          ),
                                                          WidgetSpan(
                                                              child: Icon(FontAwesomeIcons.euroSign,color: Colors.amber[200],size:15)
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                ),
                                                DataCell(
                                                  Text(values[index].libelle.toString(),style: TextStyle(fontSize: 12.0,fontWeight: FontWeight.w900,color: Colors.white)),
                                                ),
                                                DataCell(
                                                  Text(values[index].etat.toString(),style: TextStyle(fontSize: 12.0,fontWeight: FontWeight.w900,color: Colors.white)),
                                                ),
                                                DataCell(
                                                  Text(datv,style: TextStyle(fontSize: 12.0,fontWeight: FontWeight.w900,color:Colors.white)),
                                                ),
                                              ]
                                          );
                                        }).toList(),
                                      )
                                    ]
                                );
                              }
                            }
                        }
                      }
                  )
              )
          )
        ]
    );
  }
}

class ligne_commande {

  final String date;
  final String gems;
  final String cash;
  final String libelle;
  final String etat;
  final String datev;

  const ligne_commande(this.date,this.gems,this.cash,this.libelle,this.etat,this.datev);

}