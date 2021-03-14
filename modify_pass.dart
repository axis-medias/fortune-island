import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'menu_member.dart';
import 'globals.dart' as globals;
import 'appbar_draw.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Modifier_Passe extends StatefulWidget {
  @override

  _Modifier_Passe_State createState() {
    return _Modifier_Passe_State();
  }
}

class _Modifier_Passe_State extends State<Modifier_Passe> {
  @override
  final _formKey = GlobalKey<FormState>();
  final _ancPassController=TextEditingController();
  final _newPassController=TextEditingController();
  final _newPass2Controller=TextEditingController();

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
    drawer: new DrawerOnly(className: Modifier_Passe()),
    body:
    Container(
    height: MediaQuery.of(context).size.height,
    width: MediaQuery.of(context).size.width,
    margin: const EdgeInsets.only(top: 10.0,bottom:10,right:10,left:10),
    decoration: BoxDecoration(
    border: Border.all(
    color: Colors.white,
    width: 3,
    ),
    borderRadius: BorderRadius.circular(25),
    ),
    child:
    Form(
    key: _formKey,
    autovalidate: true,
    child: ListView(
    shrinkWrap: true,
    padding: EdgeInsets.only(left: 24.0, right: 24.0),
    children: <Widget>[
    Container(
    padding: EdgeInsets.all(10.0),
    child:
    Center(
    child:
    Text("CHANGER VOTRE MOT DE PASSE",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500,color: Colors.white)),
    ),
    ),
    Padding(
    padding: const EdgeInsets.only(top:12.0),
    child:
    TextFormField(
    autofocus: true,
      obscureText: true,
      controller: _ancPassController,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
        fillColor: Colors.white, filled: true,
        icon: Icon(Icons.lock,color: Colors.white),
        hintText: "Entrez votre mot de Passe",
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        hintStyle: TextStyle(color: Colors.grey[500],fontSize: 15),
      ),
      validator: (value) {
        if (value.isEmpty) {
          return 'Entrez votre mot de passe';
        }
        if (value.length<8) {
          return '8 caractères minimum';
        }
        return null;
      },
    ),
    ),
    Padding(
    padding: const EdgeInsets.only(top:12.0),
    child:
    TextFormField(
    autofocus: false,
      obscureText: true,
      controller: _newPassController,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
        fillColor: Colors.white, filled: true,
        icon: Icon(Icons.lock,color: Colors.white),
        hintText: "Entrez votre nouveau mot de Passe",
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        hintStyle: TextStyle(color: Colors.grey[500],fontSize: 15),
      ),
      validator: (value) {
        if (value.isEmpty) {
          return "Entrez votre nouveau mot de passe";
        }
        if (value.length<8) {
          return "8 caractères minimum";
        }
        if (value == _ancPassController.text) {
          return "Votre nouveau mot de passe doit être différent de l'ancien";
        }
        return null;
      },
    ),
    ),
      Padding(
        padding: const EdgeInsets.only(top:12.0),
        child:
        TextFormField(
          autofocus: false,
          obscureText: true,
          controller: _newPass2Controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
            fillColor: Colors.white, filled: true,
            icon: Icon(Icons.lock,color: Colors.white),
            hintText: "Confirmation de votre nouveau mot de Passe",
            contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            hintStyle: TextStyle(color: Colors.grey[500],fontSize: 15),
          ),
          validator: (value) {
            if (value.isEmpty) {
              return 'Confirmez votre nouveau mot de passe';
            }
            if (value.length<8) {
              return '8 caractères minimum';
            }
            if(value != _newPassController.text) {
              return 'Les mots de passe ne sont pas identiques !';
            }
            return null;
          },
        ),
      ),
    SizedBox(height: 24.0),
    Center(
    child: Container(
    width:MediaQuery.of(context).size.width,
    height:45,
    child: RaisedButton(
    color: Colors.green,
    textColor: Colors.white,
    padding: EdgeInsets.fromLTRB(9, 9, 9, 9),
    child: Text('MODIFIER LE MOT DE PASSE'),
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(25)
    ),
    onPressed: () {
    // Validate returns true if the form is valid, or false
    // otherwise.
    if (_formKey.currentState.validate()) {
    change_Pass();
    }
    else {
    return null;
    }
    },
    ),
    ),
    ),
    SizedBox(height: 10.0),
    ],
    ),
    )
    )
    )
    ]
    );
  }

  Future change_Pass() async {
    String ancpass=_ancPassController.text;
    String newpass=_newPassController.text;
    String confirmpass=_newPass2Controller.text;

    if (newpass==confirmpass) {
      if (newpass!=ancpass) {
        var url = 'https://www.fortune-island.com/app/modify_pass.php';
        var data = {
          'id_membre': globals.id_membre,
          'ancpass': ancpass,
          'newpass': newpass
        };

        var data_encode = jsonEncode(data);
        print(data_encode);
        // Starting Web API Call.
        var response = await http.post(url, body: data_encode,
            headers: {
              'content-type': 'application/json',
              'accept': 'application/json',
              'authorization': globals.token
            });
        print(response.body);
        Map <String, dynamic> map = json.decode(response.body);
        if (map["status"] == 1) {
          AwesomeDialog(context: context,
              useRootNavigator: true,
              dialogType: DialogType.SUCCES,
              animType: AnimType.BOTTOMSLIDE,
              tittle: 'MODIFICATION DU MOT DE PASSE',
              desc: map["libelle"],
              btnOkOnPress: () {
                setState(() {
                  if (map["gems"]!="" && map["credits"]!="") {
                    globals.gems=num.parse(map["gems"]);
                    globals.credits=num.parse(map["credits"]);
                  }
                });
              }).show();
        }
        else {
          AwesomeDialog(context: context,
              useRootNavigator: true,
              dialogType: DialogType.ERROR,
              animType: AnimType.BOTTOMSLIDE,
              tittle: 'ERREUR',
              desc: map["libelle"],
              btnOkOnPress: () {
                setState(() {
                  if (map["gems"]!="" && map["credits"]!="") {
                    globals.gems=num.parse(map["gems"]);
                    globals.credits=num.parse(map["credits"]);
                  }
                });
              }).show();
        }
      }
      else {
        AwesomeDialog(context: context,
            useRootNavigator: true,
            dialogType: DialogType.INFO,
            animType: AnimType.BOTTOMSLIDE,
            tittle: 'ERREUR',
            desc: "Les mots de passe sont identique !",
            btnOkOnPress: () {

            }).show();
      }
    }
    else {
      AwesomeDialog(context: context,
          useRootNavigator: true,
          dialogType: DialogType.INFO,
          animType: AnimType.BOTTOMSLIDE,
          tittle: 'ERREUR',
          desc: "La confirmation de mot de passe n'est pas identique !",
          btnOkOnPress: () {

          }).show();
    }
  }
}