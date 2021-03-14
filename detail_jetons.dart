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
class Affiche_Jetons extends StatefulWidget {
  @override

  _Affiche_Jetons_State createState() {
    return _Affiche_Jetons_State();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.

class _Affiche_Jetons_State extends State<Affiche_Jetons> {
  @override

  Future<List<ligne_jeton>> solde;

  Future <List<ligne_jeton>> Liste_Solde_Display() async {
    // SERVER LOGIN API URL
    var url = 'https://www.fortune-island.com/app/detail_credits.php';

    var data = {
      'id_membre': globals.id_membre,
    };

    var data_encode = jsonEncode(data);
    // Starting Web API Call.
    var response = await http.post(url,body: data_encode,headers: {'content-type': 'application/json','accept': 'application/json','authorization': globals.token});

    // Getting Server response into variable.

    print(json.decode(response.body));
    var jsondata = json.decode(response.body);

    globals.gems=num.parse(jsondata['gems']);
    globals.credits=num.parse(jsondata['credits']);

    List<ligne_jeton> lines = [];
    var i=0;
    if (jsondata.containsKey('listec')) {
      for (var u in jsondata['listec']) {
        i = i + 1;
        ligne_jeton line = ligne_jeton(
            u["dates"], u["heure"], u["credits"], u["type"]);
        lines.add(line);
      }
    }
    return lines;
  }

  void initState() {
    solde = Liste_Solde_Display();
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
              drawer: new DrawerOnly(className: Affiche_Jetons()),
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
                      future: solde,
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
                              List<ligne_jeton> values = snapshot.data;
                              if (values.isEmpty) {
                                return Container(
                                    child: Center(
                                        child: Text("Aucun jeton pour le moment !!!",style: TextStyle(color: Colors.white))
                                    )
                                );
                              }
                              else {
                                return ListView(
                                    children: <Widget>[
                                      Center(
                                        child: Container(
                                            margin: const EdgeInsets.only(top: 20.0),
                                            child: Text("DETAIL DE VOS JETONS",textAlign: TextAlign.center,style: TextStyle(fontSize: 30.0,color: Colors.white))
                                        ),
                                      ),
                                      DataTable(
                                        columnSpacing: 0,
                                        dataRowHeight: 50,
                                        columns: [
                                          DataColumn(
                                            label: Text("DATE",textAlign: TextAlign.center,style: TextStyle(color: Colors.white)),
                                            numeric: false,
                                            tooltip: "",
                                          ),
                                          DataColumn(
                                            label: Text("JETONS",textAlign: TextAlign.center,style: TextStyle(color: Colors.white)),
                                            numeric: false,
                                            tooltip: "",
                                          ),
                                          DataColumn(
                                            label: Text("TYPE",textAlign: TextAlign.center,style: TextStyle(color: Colors.white)),
                                            numeric: false,
                                            tooltip: "",
                                          ),
                                        ],
                                        rows: List.generate(values.length, (index) {
                                          var parsedDate = DateTime.parse(values[index].date);
                                          final formatter = new DateFormat('dd/MM/yyyy HH:mm');
                                          var dat = formatter.format(parsedDate);
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
                                                              text: values[index].nb_jeton.toString()+" ",
                                                              style: TextStyle(fontSize: 12,fontWeight: FontWeight.w800,color: Colors.white)
                                                          ),
                                                          WidgetSpan(
                                                              child: Icon(FontAwesomeIcons.coins,color: Colors.amber[200],size:15)
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                ),
                                                DataCell(
                                                  Text(values[index].type.toString(),style: TextStyle(fontSize: 12.0,fontWeight: FontWeight.w900,color: Colors.white)),
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

class ligne_jeton {

  final String date;
  final String heure;
  final String nb_jeton;
  final String type;

  const ligne_jeton (this.date,this.heure,this.nb_jeton, this.type);

}