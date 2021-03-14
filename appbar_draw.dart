import 'package:flutter/material.dart';
import 'globals.dart' as globals;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

drawappbar (bool is_connect) {
  if (is_connect==true) {

    return AppBar(title: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            margin: const EdgeInsets.only(left: 20.0),
            width: 200,
            height:50,
            padding: new EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Center(
                child: RichText(
                  text: TextSpan(
                    children: [
                      WidgetSpan(
                          child: Icon(FontAwesomeIcons.gem,color: Colors.amber[200],size:20)
                      ),
                      TextSpan(
                          text: " "+globals.gems.toString(),
                          style: TextStyle(fontSize: 20,fontWeight: FontWeight.w800,color: Colors.white)
                      ),
                    ],
                  ),
                )
            )
        ),
      ],
    ),
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[
              Colors.blue[400],Colors.blue[600],Colors.blue[800]
            ],
          ),
        ),
      ),
    );
  }
}