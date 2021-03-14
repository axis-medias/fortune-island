import 'package:flutter/material.dart';
import 'package:gameapp/jouer_grattage.dart';
import 'menu_member.dart';
import 'package:scratcher/scratcher.dart';
import 'globals.dart' as globals;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'appbar_draw.dart';
import 'package:awesome_page_transitions/awesome_page_transitions.dart';

class Affiche_Ticket_Grattage extends StatefulWidget {
  @override
  var id_ticket;
  var gain;

  Affiche_Ticket_Grattage({Key key, @required this.id_ticket,this.gain}) : super(key: key);
  _Affiche_Ticket_Grattage_State createState() {
    return _Affiche_Ticket_Grattage_State();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.

class _Affiche_Ticket_Grattage_State extends State<Affiche_Ticket_Grattage> {
  @override

  bool load=false;
  bool visible=false;

  void initState() {
    super.initState();
    Verify_Ticket();
  }

  bool vis=false;

  Future Verify_Ticket() async {
    // SERVER LOGIN API URL
    var url = 'https://www.fortune-island.com/app/verify_ticket.php';

    // Store all data with Param Name.
    var data = {'id_membre':globals.id_membre,'id_ticket': widget.id_ticket,'gain':widget.gain};

    var ticket_encode=jsonEncode(data);

    // Starting Web API Call.
    var response = await http.post(url, body: ticket_encode,headers: {'content-type': 'application/json','accept': 'application/json','authorization': globals.token});

    // Getting Server response into variable.
    Map <String,dynamic> map = json.decode(response.body);

    if (map["status"]==0) {

    }
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
          drawer: new DrawerOnly(className: Affiche_Ticket_Grattage(id_ticket: widget.id_ticket)),
            body:
                Container(
            child :
            Center(
                          child:
                          Column(
                              children: <Widget>[
                                Container(
                                  width: 400,
                                  height: 30,
                                  margin: const EdgeInsets.only(top: 10.0),
                                  child: new Text("Grattez votre ticket",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 30.0,color:Colors.white)),
                                ),
                                Container(
                                    padding: const EdgeInsets.all(30.0),
                                    child:
                                    Scratcher(
                                        accuracy: ScratchAccuracy.medium,
                                        brushSize: 35,
                                        color: Colors.lightBlueAccent,
                                        threshold: 80,
                                        onThreshold: () {
                                          setState(() {
                                            vis = true;
                                          });
                                        },
                                        child:
                                        Container(
                                            width: 300,
                                            height: 300,
                                            color: Colors.white,
                                            alignment: Alignment.center,
                                            child:
                                                Center(
                                                  child:
                                            Text(widget.gain.toString() + " GEMS",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 50,
                                                  color: Colors.indigoAccent),
                                                textAlign: TextAlign.center
                                            )
                                                )
                                        )
                                    )
                                ),
                                Visibility(
                                    maintainSize: true,
                                    maintainAnimation: true,
                                    maintainState: true,
                                    visible: visible,
                                    child: Container(
                                        child: CircularProgressIndicator()
                                    )
                                ),
                                Visibility(
                                  visible: vis,
                                  child: Container(
                                    width: 300,
                                    height: 45,
                                    margin: const EdgeInsets.only(top: 20.0),
                                    child:
                                    RaisedButton(
                                      color: Colors.green,
                                      textColor: Colors.white,
                                      padding: EdgeInsets.fromLTRB(9, 9, 9, 9),
                                      child: Text('VALIDER VOTRE TICKET'),
                                      onPressed: () {
                                        setState(() {
                                          visible=true;
                                        });
                                        if (widget.gain.toString()!="0") {
                                          AwesomeDialog(context: context,
                                              useRootNavigator: true,
                                              dialogType: DialogType.INFO,
                                              animType: AnimType.BOTTOMSLIDE,
                                              tittle: 'INFO',
                                              desc: 'Bravo Vous avez gagne ' +
                                                  widget.gain.toString() +
                                                  ' GEMS !',
                                              btnOkOnPress: () {
                                                Navigator.push(
                                                  context,
                                                  AwesomePageRoute(
                                                    transitionDuration: Duration(
                                                        milliseconds: 600),
                                                    exitPage: widget,
                                                    enterPage: ParamGrattage(),
                                                    transition: CubeTransition(),
                                                  ),
                                                );
                                              }).show();
                                        }
                                        else {
                                          AwesomeDialog(context: context,
                                              useRootNavigator: true,
                                              dialogType: DialogType.INFO,
                                              animType: AnimType.BOTTOMSLIDE,
                                              tittle: 'INFO',
                                              desc: 'Vous avez perdu !',
                                              btnOkOnPress: () {
                                                Navigator.push(
                                                  context,
                                                  AwesomePageRoute(
                                                    transitionDuration: Duration(
                                                        milliseconds: 600),
                                                    exitPage: widget,
                                                    enterPage: ParamGrattage(),
                                                    transition: CubeTransition(),
                                                  ),
                                                );
                                              }).show();
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ]
                          )
                        )
    )
    )
    ]
    );
  }
  }