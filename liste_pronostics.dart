import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'menu_member.dart';
import 'globals.dart' as globals;
import 'appbar_draw.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:intl/intl.dart';
import 'prono_match.dart';
import 'package:awesome_page_transitions/awesome_page_transitions.dart';

// Create a Form widget.
class Affiche_Matchs extends StatefulWidget {
  @override

  _Affiche_Matchs_State createState() {
    return _Affiche_Matchs_State();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.

class _Affiche_Matchs_State extends State<Affiche_Matchs> {
  @override

  bool load=false;
  bool visible=false;
  String idmatch="";
  String prono="";

  List<String> radioValues = [];
  Future<List<Match>> grid;

  Future <List<Match>> Liste_Match_Display() async {
    // SERVER LOGIN API URL
    var url = 'https://www.fortune-island.com/app/display_matchs.php';

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

    List<Match> Matchs = [];
    var i=0;
    if (jsondata.containsKey('matchs')) {
      for (var u in jsondata['matchs']) {
        i = i + 1;
        Match match = Match(
            u["id"], u["equipe1"], u["equipe2"], u["dated"], u["heured"]);
        Matchs.add(match);
        radioValues.add("");
      }
    }
    return Matchs;
  }

  void initState() {
    super.initState();
    grid = Liste_Match_Display();
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
        drawer: new DrawerOnly(className: Affiche_Matchs()),
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
          List<Match> values = snapshot.data;
          if (values.isEmpty) {
          return Container(
          child: Center(
          child: Text("Aucun match disponible !!!",style: TextStyle(color: Colors.white))
          )
          );
          }
          else {
            Match lastitem;
            lastitem=values[0];
            int i=0;
            return ListView.builder(itemCount: values.length,itemBuilder: (_,index) {
                          bool header = lastitem.date_debut !=
                              values[index].date_debut;
                          lastitem = values[index];
                          var parsedDate = DateTime.parse(values[index].date_debut);
                          final formatter = new DateFormat('dd/MM/yyyy');
                          var dat = formatter.format(parsedDate);
                          return Column(
                            children: [
                              (header || index == 0)
                                  ?
                          Container(
                            height: 30,
                            margin: EdgeInsets.only(top:5),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.blue[700],
                                  width: 2,
                                ),
                                color: Colors.blue[700]
                            ),
                            child : new Text(dat,textAlign: TextAlign.center,style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.w500,color: Colors.white),),
                          )// here// display header
                                  :
                                  Container(),
                                  Container(
                                  margin: EdgeInsets.only(top:10,bottom:10),
                                  child: Center(
                                  child: Text(values[index].heure_debut,style: TextStyle(color: Colors.white)),
                                  ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(bottom:10),
                                    child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      child: Text(values[index].equipe1+" - "+values[index].equipe2,style: TextStyle(fontSize:10,color: Colors.white)),
                                    ),
                            ]
                  ),
                                  ),
                              Container(
                                  margin: const EdgeInsets.only(left:5,bottom:5),
                                  child: RaisedButton(
                                    color: Colors.green,
                                    textColor: Colors.white,
                                    padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                    child: Text('PARIER'),
                                    onPressed: () {
                                        idmatch=values[index].id;
                                        print(idmatch);
                                        setState(() {
                                        visible=true;
                                        });
                                        Navigator.push(context,
                                            AwesomePageRoute(
                                              transitionDuration: Duration(milliseconds: 600),
                                              exitPage: widget,
                                              enterPage: Prono_Match(id: idmatch),
                                              transition: CubeTransition(),
                                            )
                                        );
                                    },
                                  ),
                                ),
                              index!=values.length ?
                              const Divider(
                                color: Colors.white,
                                height: 5,
                                thickness: 1,
                                indent: 0,
                                endIndent: 0,
                              )
                              :
                              Container()
                  ]
                          );
                        }
                );
          }
          };
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

}

class Match {

  final String id;
  final String equipe1;
  final String equipe2;
  final String date_debut;
  final String heure_debut;

  const Match(this.id,this.equipe1, this.equipe2,this.date_debut,this.heure_debut);

}