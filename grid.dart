import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'menu_member.dart';
import 'globals.dart' as globals;
import 'grille_lotosport.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'appbar_draw.dart';
import 'package:awesome_page_transitions/awesome_page_transitions.dart';

// Create a Form widget.
class Affiche_grille extends StatefulWidget {
  @override
  String id;

  Affiche_grille({Key key, @required this.id}) : super(key: key);

  _Affiche_grille_State createState() {
    return _Affiche_grille_State();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.

class _Affiche_grille_State extends State<Affiche_grille> {
  @override

  bool load=false;
  bool visible=false;
  var concatenate='';

  final _formKey = GlobalKey<FormState>();
  List<String> radioValues = [];
  Future<List<Match>> grid;
  List<Match> values;

  Future <List<Match>> Grille_display() async {
    // SERVER LOGIN API URL
    var url = 'https://www.fortune-island.com/app/display_grid.php';

    // Store all data with Param Name.
    var data = {'id_grille': widget.id,'id_membre':globals.id_membre};

    // Starting Web API Call.
    var response = await http.post(url, body: json.encode(data),headers: {'content-type': 'application/json','accept': 'application/json','authorization': globals.token});

    // Getting Server response into variable.

    var jsondata = json.decode(response.body);

    globals.gems=num.parse(jsondata['gems']);
    globals.credits=num.parse(jsondata['credits']);

    List<Match> Matchs = [];
    if (jsondata.containsKey('lotosport')) {
      for (var u in jsondata['lotosport']) {
        Match match = Match(u["equipe1"], u["equipe2"], u["type_prono"]);
        Matchs.add(match);
        radioValues.add("");
      }
    }
    return Matchs;
  }

  void initState() {
    super.initState();
    grid = Grille_display();
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
        drawer: new DrawerOnly(className: Affiche_grille(id: widget.id)),
        body:
            Center(
            child: Column (
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height*0.8,
          width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.only(top: 10.0,bottom:10,right:10,left:10),
        decoration: BoxDecoration(
        border: Border.all(
        color: Colors.redAccent,
        width: 2,
        ),
        borderRadius: BorderRadius.circular(25),
        ),
          child:
            FutureBuilder(
              future: grid,
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
                    values = snapshot.data;
                    return
                      Form(
                        key: _formKey,
                        child: ListView(
                          children: <Widget>[
                            Center(
                              child: Container(
                                margin: const EdgeInsets.only(top: 20.0),
                                child: Text("GRILLE LOTOSPORT "+values.length.toString(),textAlign: TextAlign.center,style: TextStyle(fontSize: 30.0,color: Colors.white))
                              ),
                            ),
                            DataTable(
                              columnSpacing: 0,
                              dataRowHeight: 50,
                              columns: [
                                DataColumn(
                                  label: Text(""),
                                  numeric: false,
                                  tooltip: "",
                                ),
                                DataColumn(
                                  label: Text(""),
                                  numeric: false,
                                  tooltip: "",
                                ),
                                DataColumn(
                                  label: Text(""),
                                  numeric: false,
                                  tooltip: "",
                                ),
                                DataColumn(
                                  label: Text(""),
                                  numeric: false,
                                  tooltip: "",
                                ),
                                DataColumn(
                                  label: Text(""),
                                  numeric: false,
                                  tooltip: "",
                                ),
                              ],
                              rows:
                              List.generate(values.length, (index) {
                                return DataRow(
                                    cells: [
                                      DataCell(
                                        Text(values[index].equipe1.toString(),style: TextStyle(fontSize: 12.0,fontWeight: FontWeight.w900,color: Colors.white)),
                                      ),
                                      DataCell(
                                        draw_grid("1",index,values[index].typeprono),
                                      ),
                                      DataCell(
                                        draw_grid("N",index,values[index].typeprono),
                                      ),
                                      DataCell(
                                        draw_grid("2",index,values[index].typeprono),
                                      ),
                                      DataCell (
                                          Text(values[index].equipe2.toString(),style: TextStyle(fontSize: 12.0,fontWeight: FontWeight.w900,color: Colors.white)),
                                      ),
                                    ]
                                );
                              }).toList(),
                            ),
                            Center(
                              child: Container(
                                margin: const EdgeInsets.only(top: 20.0,bottom:10,right:10,left:10),
                                child: RaisedButton(
                                color: Colors.green,
                                textColor: Colors.white,
                                padding: EdgeInsets.fromLTRB(9, 9, 9, 9),
                                child: Text('VALIDER VOTRE GRILLE'),
                                onPressed: () {
                                  radioValues.forEach((item) {
                                    if (item.trim() != "") {
                                      concatenate = concatenate + item;
                                    }
                                  });
                                  if (concatenate.length<values.length) {
                                    AwesomeDialog(context: context,
                                        useRootNavigator: true,
                                        dialogType: DialogType.WARNING,
                                        animType: AnimType.BOTTOMSLIDE,
                                        tittle: 'Attention',
                                        desc: 'Vous devez sélectionner un choix pour tous les matchs !!!',
                                        btnOkOnPress: () {}).show();
                                  }
                                  else {
                                    setState(() {
                                      visible=true;
                                    });
                                    Valide_grille();
                                  }
                                },
                              ),
                            ),
                            ),
                          ],
                        )
                    );
                  };
              };
                },
            ),
        ),
      ]
    )
            )
    )
    ]
    );
  }

  draw_grid (String choix, int index,String type_prono) {
    if (type_prono.contains(choix)) {
      return new InkWell(
        onTap: () {
          setState(() {
            if (radioValues[index] == choix) {
              radioValues[index] = "";
            }
            else {
              radioValues[index] = choix;
            }
          });
          print(radioValues);
        },
        child:
        Container(
          height: 40.0,
          width: 40.0,
          child: new Center(
            child: new Text(choix,
                style: new TextStyle(
                    color:
                    radioValues[index] == choix ? Colors.white : Colors.red,
                    //fontWeight: FontWeight.bold,
                    fontSize: 18.0, fontWeight: FontWeight.w900)),
          ),
          decoration: new BoxDecoration(
            color: radioValues[index] == choix
                ? Colors.red
                : Colors.white,
            border: new Border.all(
                width: 2.0,
                color: radioValues[index] == choix
                    ? Colors.red
                    : Colors.red),
            borderRadius: const BorderRadius.all(const Radius.circular(5)),
          ),
        ),
      );
  }
    else {
      return Text("");
    }
  }

  Future Valide_grille() async{
    // For CircularProgressIndicator.
    bool visible = false ;
    // Showing CircularProgressIndicator.
    setState(() {
      visible = true ;
    });

    // SERVER LOGIN API URL
    var url = 'https://www.fortune-island.com/app/valide_grid.php';

        var id_grille = widget.id;

        // Store all data with Param Name.
        var data = {
          'id_membre': globals.id_membre,
          'id_grille': id_grille,
          'result': concatenate
        };

        var grille_encode = jsonEncode(data);

        // Starting Web API Call.
        var response = await http.post(url, body: grille_encode,
            headers: {
              'content-type': 'application/json',
              'accept': 'application/json',
              'authorization': globals.token
            });

        print(response.body);
        // Getting Server response into variable.
        Map <String, dynamic> map2 = json.decode(response.body);

        if (map2["solde_gems"]!="" && map2["solde_credits"]!="") {
          setState(() {
            globals.gems=num.parse(map2["solde_gems"]);
            globals.credits=num.parse(map2["solde_credits"]);
          });
        }

        // If the Response Message is Matched.
        if (map2["status"] == 1) {
              AwesomeDialog(context: context,
                  useRootNavigator: true,
                  dialogType: DialogType.SUCCES,
                  animType: AnimType.BOTTOMSLIDE,
                  tittle: 'VALIDATION',
                  desc: map2["message"],
                  btnOkOnPress: () {
                    Navigator.push(
                      context,
                      AwesomePageRoute(
                        transitionDuration: Duration(milliseconds: 600),
                        exitPage: widget,
                        enterPage: Affiche_Liste_grille(),
                        transition: CubeTransition(),
                      ),
                    );
                  }).show();
          // Hiding the CircularProgressIndicator.
          setState(() {
            visible = false;
          });
        } else {
          // Hiding the CircularProgressIndicator.
          setState(() {
            visible = false;
          });

          // Showing Alert Dialog with Response JSON Message.
          AwesomeDialog(context: context,
              useRootNavigator: true,
              dialogType: DialogType.ERROR,
              animType: AnimType.BOTTOMSLIDE,
              tittle: 'ERREUR',
              desc: map2["message"],
              btnOkOnPress: () {
                Navigator.of(context).pop();
              }).show();
        }
  }
  }

class Match {

  final String equipe1;
  final String equipe2;
  final String typeprono;

  const Match(this.equipe1, this.equipe2, this.typeprono);

}