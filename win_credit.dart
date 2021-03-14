import 'dart:ui';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'menu_member.dart';
import 'globals.dart' as globals;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'appbar_draw.dart';
import 'package:awesome_page_transitions/awesome_page_transitions.dart';
import 'reward_vid.dart';

class Credit extends StatefulWidget {

  Credit_State createState() {
    return Credit_State();
  }

}

class Credit_State extends State<Credit> {

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
        drawer: new DrawerOnly(className: Credit()),
        body: Center(
            child: Column(children: <Widget>[
              Container(
                  height: 25,
                  width: MediaQuery.of(context).size.width,
                  padding : EdgeInsets.only(left: 20, right:20),
                  margin: EdgeInsets.only(top:0,bottom:0),
                  color: Colors.blue[700],
                  child: Center(
                      child:
                      Text("1 - Gagnez des Jetons grâce à nos sponsors",style: TextStyle(fontSize: 10, color: Colors.white))
                  )
              ),
              Container(
                  height: 25,
                  width: MediaQuery.of(context).size.width,
                  padding : EdgeInsets.only(left: 20, right:20),
                  margin: EdgeInsets.only(top:0,bottom:20),
                  color: Colors.blue[700],
                  child: Center(
                      child:
                      Text("2 - Jouez vos Jetons et gagnez des GEMS échangeable contre des cadeaux et du cash",style: TextStyle(fontSize: 10, color: Colors.white))
                  )
              ),
              Expanded(
                  child : ListView(
                      children : <Widget>[
                        Container(
                          height: 30,
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.only(left:20,right:20),
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.blue[700],
                                width: 2,
                              ),
                              borderRadius: BorderRadius.only(topLeft : Radius.circular(25),topRight: Radius.circular(25)),
                              color: Colors.blue[700]
                          ),
                          child : new Text("VIDEO SPONSOR",textAlign: TextAlign.center,style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.w500,color: Colors.white),),
                        ),
                        Container(
                            height:100,
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
                                      'VOIR NOS SPONSORS'),
                                  onPressed: () {
                                    Navigator.push(context,
                                        AwesomePageRoute(
                                          transitionDuration: Duration(milliseconds: 600),
                                          exitPage: Credit(),
                                          enterPage: Reward_Video(),
                                          transition: CubeTransition(),
                                        )
                                    );
                                  },
                                ),
                              )
                            ]
                            )
                        ),
                            ]
                            )
                        ),
                            ]
                            )
                        ),
                  )
    ]
    );
  }
}