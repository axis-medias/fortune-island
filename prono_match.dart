import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'menu_member.dart';
import 'globals.dart' as globals;
import 'appbar_draw.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

// Create a Form widget.
class Prono_Match extends StatefulWidget {
  @override
  String id;
  Prono_Match({Key key, @required this.id}) : super(key: key);
  _Prono_Match_State createState() {
    return _Prono_Match_State();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.

class _Prono_Match_State extends State<Prono_Match> {
  @override

  bool load=false;
  bool visible=false;
  String prono="";

  String radioValues="";

  final myController = TextEditingController();

  Future<Match> grid;

  Future <Match> Match_Display() async {
    // SERVER LOGIN API URL
    var url = 'https://www.fortune-island.com/app/prono_match.php';

    var data = {
      'id_membre': globals.id_membre,
      'id_match': widget.id
    };

    var data_encode = jsonEncode(data);
    // Starting Web API Call.
    var response = await http.post(url,body: data_encode,headers: {'content-type': 'application/json','accept': 'application/json','authorization': globals.token});

    // Getting Server response into variable.

    var jsondata = json.decode(response.body);

    globals.gems=num.parse(jsondata['gems']);
    globals.credits=num.parse(jsondata['credits']);

    Match match;
    if (jsondata.containsKey('matchs')) {
      for (var u in jsondata['matchs']) {
        match = Match(
            u["id"], u["equipe1"], u["equipe2"], u["type_prono"], u["dated"],
            u["heured"]);
      }
    }
    return match;
  }

  void initState() {
    super.initState();
    grid = Match_Display();
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
              drawer: new DrawerOnly(className: Prono_Match(id: widget.id)),
              body:
              Center(
                  child : Column(
                      children: <Widget>[
                        Container(
                          height: MediaQuery.of(context).size.height*0.8,
                          width: MediaQuery.of(context).size.width,
                          child:
                          FutureBuilder(
                              future: grid,
                              builder: (BuildContext context, AsyncSnapshot snapshot) {
                                switch (snapshot.connectionState) {
                                  case ConnectionState.waiting: return new Center(child: new CircularProgressIndicator(),);
                                  default:
                                    if(snapshot.hasError) {
                                      return new Center(child: new Text('Error: ${snapshot.error}'),);
                                    }
                                    else {
                                      Match values = snapshot.data;
                                      if (values == null) {
                                        return Container(
                                            child: Center(
                                                child: Text("Aucun match disponible !!!",style: TextStyle(color: Colors.white))
                                            )
                                        );
                                      }
                                      else {
                                        var parsedDate = DateTime.parse(values.date_debut);
                                        final formatter = new DateFormat('dd/MM/yyyy HH:mm');
                                        var dat = formatter.format(parsedDate);
                                        return Column(
                                              children: [
                                                Container(
                                                  height: 30,
                                                  margin: EdgeInsets.only(top:10,bottom: 20),
                                                  width: MediaQuery.of(context).size.width,
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                        color: Colors.blue[700],
                                                        width: 2,
                                                      ),
                                                      color: Colors.blue[700]
                                                  ),
                                                  child : new Text(dat,textAlign: TextAlign.center,style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.w500,color: Colors.white),),
                                                ),
                                                Container(
                                                  margin: const EdgeInsets.only(bottom:20),
                                                  child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        Container(
                                                          margin: EdgeInsets.only(right:5),
                                                          child: Text(values.equipe1+" -"+values.equipe2,style: TextStyle(fontSize:10,color: Colors.white)),
                                                        ),
                                                      ]
                                                  ),
                                                ),
                                                Container(
                                                  margin: const EdgeInsets.only(bottom:20),
                                                  child : Center(
                                                  child : Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: <Widget>[
                                                  draw_grid("1", values.typeprono),
                                                  draw_grid("N", values.typeprono),
                                                  draw_grid("2", values.typeprono),
                                                ]
                                                  )
                                                ),
                                                ),
                                                Container(
                                                  margin: const EdgeInsets.only(bottom:20),
                                                  width: MediaQuery.of(context).size.width*0.5,
                                                  child:
                                                  TextFormField(
                                                    keyboardType: TextInputType.number,
                                                    inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                                                    style: TextStyle(color: Colors.white,fontSize: 10),
                                                    decoration: InputDecoration(
                                                        hintText: "Nombre de GEMS",
                                                        hintStyle: TextStyle(fontSize: 10.0, color: Colors.white),
                                                        labelText: "Votre mise :",
                                                      prefixIcon: Icon(
                                                          FontAwesomeIcons.gem,
                                                          color: Colors.white
                                                      ),
                                                        border: new UnderlineInputBorder(
                                                            borderSide: new BorderSide(
                                                                color: Colors.white
                                                            )
                                                        )
                                                    ),
                                                    autofocus: false,
                                                    obscureText: false,
                                                    controller: myController,
                                                  ),
                                                ),
                                                Container(
                                                  child: RaisedButton(
                                                    color: Colors.green,
                                                    textColor: Colors.white,
                                                    padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                                    child: Text('PARIER'),
                                                    onPressed: () {
                                                      if (radioValues=="") {
                                                        AwesomeDialog(context: context,
                                                            useRootNavigator: true,
                                                            dialogType: DialogType.WARNING,
                                                            animType: AnimType.BOTTOMSLIDE,
                                                            tittle: 'Attention',
                                                            desc: 'Merci de sélectionner un choix pour ce match !!!',
                                                            btnOkOnPress: () {}).show();
                                                      }
                                                      else {
                                                        var mise=myController.text;
                                                        if (globals.isNumeric(mise)==false) {
                                                          AwesomeDialog(context: context,
                                                              useRootNavigator: true,
                                                              dialogType: DialogType.WARNING,
                                                              animType: AnimType.BOTTOMSLIDE,
                                                              tittle: "Attention",
                                                              desc: "La mise doit être un chiffre !!!",
                                                              btnOkOnPress: () {}).show();
                                                        }
                                                        else {
                                                          double mtmise = double
                                                              .parse(mise);
                                                          if (mtmise >
                                                              globals.credits) {
                                                            AwesomeDialog(
                                                                context: context,
                                                                useRootNavigator: true,
                                                                dialogType: DialogType
                                                                    .WARNING,
                                                                animType: AnimType
                                                                    .BOTTOMSLIDE,
                                                                tittle: 'Attention',
                                                                desc: 'Votre mise est supérieur à votre solde !!!',
                                                                btnOkOnPress: () {})
                                                                .show();
                                                          }
                                                          else {
                                                            prono = radioValues;
                                                            setState(() {
                                                              visible = true;
                                                            });
                                                            Valide_Match(widget.id, prono, mtmise);
                                                          }
                                                        }
                                                        }
                                                    },
                                                  ),
                                                ),
                                              ]
                                          );
                                        }
                                      }
                                    };
                              }
                          ),
                        ),
                      ]
                  )
              )
          )
        ]
    );
  }

  Future Valide_Match(String idmatch, String prono,double mise) async {
    // SERVER LOGIN API URL
    var url = 'https://www.fortune-island.com/app/valide_match.php';

    var data = {
      'id_membre': globals.id_membre,
      'id_match': idmatch,
      'result': prono,
      'mise' : mise
    };

    var prono_encode = jsonEncode(data);
    print(prono_encode);

    // Starting Web API Call.
    var response = await http.post(url, body: prono_encode,
        headers: {
          'content-type': 'application/json',
          'accept': 'application/json',
          'authorization': globals.token
        });
    // Getting Server response into variable.
    Map <String, dynamic> map2 = json.decode(response.body);

    setState(() {
      grid=Match_Display();
      visible=true;
      if (map2["solde_gems"]!="" && map2["solde_credits"]!="") {
        globals.gems=num.parse(map2["solde_gems"]);
        globals.credits=num.parse(map2["solde_credits"]);
      }
    });

    if (map2["status"] == 1) {
      globals.credits = globals.credits-mise;
      AwesomeDialog(context: context,
          useRootNavigator: true,
          dialogType: DialogType.SUCCES,
          animType: AnimType.BOTTOMSLIDE,
          tittle: 'VALIDATION',
          desc: map2["message"],
          btnOkOnPress: () {

          }).show();
    }
    else {
      AwesomeDialog(context: context,
          useRootNavigator: true,
          dialogType: DialogType.ERROR,
          animType: AnimType.BOTTOMSLIDE,
          tittle: 'ERREUR',
          desc: map2["message"],
          btnOkOnPress: () {

          }).show();
    }
  }

  draw_grid (String choix,String type_prono) {
    if (type_prono.contains(choix)) {
      return new InkWell(
        onTap: () {
          setState(() {
            if (radioValues == choix) {
              radioValues = "";
            }
            else {
              radioValues = choix;
            }
          });
          print(radioValues);
        },
        child:
        Container(
          height: 30.0,
          width: 30.0,
          margin: EdgeInsets.only(right: 2,left: 2),
          child: new Center(
            child: new Text(choix,
                style: new TextStyle(
                    color:
                    radioValues == choix ? Colors.white : Colors.red,
                    //fontWeight: FontWeight.bold,
                    fontSize: 18.0, fontWeight: FontWeight.w900)),
          ),
          decoration: new BoxDecoration(
            color: radioValues == choix
                ? Colors.red
                : Colors.white,
            border: new Border.all(
                width: 2.0,
                color: radioValues == choix
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

}

class Match {

  final String id;
  final String equipe1;
  final String equipe2;
  final String typeprono;
  final String date_debut;
  final String heure_debut;

  const Match(this.id,this.equipe1,this.equipe2,this.typeprono,this.date_debut,this.heure_debut);

}