import 'package:flutter/material.dart';
import 'menu_member.dart';
import 'appbar_draw.dart';

class Affiche_Gains extends StatefulWidget {
  @override
  Affiche_Gains_State createState() {
    return Affiche_Gains_State();
  }
}

class Affiche_Gains_State extends State<Affiche_Gains> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: drawappbar(true),
        drawer: new DrawerOnly(className: Affiche_Gains()),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
        )
    );
  }
}