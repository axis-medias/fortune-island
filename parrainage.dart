import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'menu_member.dart';
import 'globals.dart' as globals;
import 'appbar_draw.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Create a Form widget.
class Affiche_Parrainage extends StatefulWidget {
  @override

  _Affiche_Parrainage_State createState() {
    return _Affiche_Parrainage_State();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.

class _Affiche_Parrainage_State extends State<Affiche_Parrainage> {
  @override


  void initState() {
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
              drawer: new DrawerOnly(className: Affiche_Parrainage()),
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
                  Column(children: <Widget>[
                  Center(
                    child: Container(
                        margin: const EdgeInsets.only(top: 20.0),
                        child: Text("LIEN DE PARRAINAGE",textAlign: TextAlign.center,style: TextStyle(fontSize: 30.0,color: Colors.white))
                    ),
                  ),
                    Center(
                      child: Container(
                          margin: const EdgeInsets.only(top: 20.0),
                          child: Text("Recevez 10 % des gains de vos filleuls à vie !",textAlign: TextAlign.center,style: TextStyle(fontSize: 15.0,color: Colors.white))
                      ),
                    ),
                    Center(
                  child:
                      Container(
                      margin: const EdgeInsets.only(top: 20.0),
                      child :
                    TextFormField(
                      readOnly: true,
                      initialValue: 'https://www.fortune-island.com/?ref='+globals.id_membre,
                      obscureText: false,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: '',
                      ),
                    )
                      )
                    ),
                ]
              )
          )
          )
        ]
    );
  }
}