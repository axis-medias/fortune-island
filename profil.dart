import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'menu_member.dart';
import 'globals.dart' as globals;
import 'appbar_draw.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:email_validator/email_validator.dart';
import 'package:checkbox_formfield/checkbox_formfield.dart';

class Affiche_Profil extends StatefulWidget {
  @override

  _Affiche_Profil_State createState() {
    return _Affiche_Profil_State();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.

class _Affiche_Profil_State extends State<Affiche_Profil> {
  @override

  final _formKey = GlobalKey<FormState>();
  final _emailController=TextEditingController();
  final _paypalController=TextEditingController();

  Future <user> profil;
  bool coche = false;

  Future <user> Display_Profil () async {
    // SERVER LOGIN API URL
    var url = 'https://www.fortune-island.com/app/info_profil.php';

    var data = {
      'id_membre': globals.id_membre,
    };

    var data_encode = jsonEncode(data);
    // Starting Web API Call.
    var response = await http.post(url,body: data_encode,headers: {'content-type': 'application/json','accept': 'application/json','authorization': globals.token});

    // Getting Server response into variable.

    var jsondata = json.decode(response.body);

    user profile=user(jsondata["pseudo"],jsondata["email"],jsondata["newsletter"],jsondata["paypal"],jsondata["gems"],jsondata["credits"]);
    return profile;
  }

  void initState() {
    profil = Display_Profil();
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
              drawer: new DrawerOnly(className: Affiche_Profil()),
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
                  margin: const EdgeInsets.only(top: 10.0,bottom:10,right:10,left:10),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white,
                      width: 3,
                    ),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child:
                    FutureBuilder(
                        future: profil,
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
                                user values = snapshot.data;
                                if (snapshot.hasData==false) {
                                  return Container(
                                      child: Center(
                                          child: Text("Données inaccessible !!!",style: TextStyle(color: Colors.white))
                                      )
                                  );
                                }
                                else {
                                  _emailController.text=values.email;
                                  _paypalController.text=values.paypal;
                                  globals.credits=num.parse(values.credits);
                                  globals.gems=num.parse(values.gems);

                                  if (values.newsletter=="1") {
                                    coche=true;
                                  }
                                  else {
                                    coche=false;
                                  }
                                  return
                                    Form(
                                      key: _formKey,
                                      autovalidate: true,
                                      child:
                                    ListView(
                                        padding: EdgeInsets.only(left: 24.0, right: 24.0),
                                      children: <Widget>[
                                        Center(
                                          child: Container(
                                              margin: const EdgeInsets.only(top: 20.0),
                                              child: Text("VOS INFOS",textAlign: TextAlign.center,style: TextStyle(fontSize: 30.0,color: Colors.white))
                                          ),
                                        ),
                                        Padding(
                                        padding: const EdgeInsets.only(top:8.0),
                                        child:
                                        TextFormField(
                                          autofocus: true,
                                          obscureText: false,
                                          controller: _emailController,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(32.0)
                                            ),
                                            fillColor: Colors.white, filled: true,
                                            icon: Icon(Icons.email,color: Colors.white),
                                            hintText: "Entrez votre email",
                                            contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                                            hintStyle: TextStyle(color: Colors.grey[500],fontSize: 10),
                                          ),
                                          validator: (value) {
                                            if (value.isEmpty) {
                                              return 'Entrez votre email';
                                            }
                                            if (!EmailValidator.validate(value)) {
                                              return 'Email non valide';
                                            }
                                            return null;
                                          },
                                        ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(top:8.0),
                                          child:
                                          TextFormField(
                                            autofocus: true,
                                            obscureText: false,
                                            controller: _paypalController,
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(32.0)
                                              ),
                                              fillColor: Colors.white, filled: true,
                                              icon: Icon(FontAwesomeIcons.paypal,color: Colors.white),
                                              hintText: "Email PAYPAL",
                                              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                                              hintStyle: TextStyle(color: Colors.grey[500],fontSize: 10),
                                            ),
                                            validator: (value) {
                                              if (value!="") {
                                                if (!EmailValidator.validate(
                                                    value)) {
                                                  return 'Email non valide';
                                                }
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                        CheckboxListTileFormField(
                                          initialValue : coche,
                                          activeColor : Colors.white,
                                          checkColor: Colors.blueAccent,
                                          title: Text('Recevoir la newsletter', style: TextStyle(color: Colors.white)),
                                          onSaved: (bool value) {
                                            coche=value;
                                          },
                                        ),
                                        Padding(
                                        padding: const EdgeInsets.only(top:8.0),
                                        child :
                                        Center(
                                          child: Container(
                                            width:MediaQuery.of(context).size.width,
                                            height:45,
                                            child: RaisedButton(
                                              color: Colors.green,
                                              textColor: Colors.white,
                                              padding: EdgeInsets.fromLTRB(9, 9, 9, 9),
                                              child: Text('Modifier'),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(25)
                                              ),
                                              onPressed: () {
                                                // Validate returns true if the form is valid, or false
                                                // otherwise.
                                                if (_formKey.currentState.validate()) {
                                                  _formKey.currentState.save();
                                                  ModifyInfos();
                                                }
                                                else {
                                                  return null;
                                                }
                                              },
                                            ),
                                          ),
                                        ),
                                        ),//    <-- label
                                      ]
                                  )
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

  Future ModifyInfos() async{
    // Getting value from Controller
    String email = _emailController.text;
    String paypal = _paypalController.text;

    var url = 'https://www.fortune-island.com/app/modify_profil.php';
    // Store all data with Param Name.
    String etatnews="0";
    if (coche==true) {
      etatnews="1";
    }
    var data = {'id_membre':globals.id_membre,'email': email,'paypal': paypal,'news': etatnews};

    var data_encode=jsonEncode(data);

    // Starting Web API Call.
    var response = await http.post(url, body: data_encode,headers: {'content-type': 'application/json','accept': 'application/json','authorization': globals.token});

    Map <String,dynamic> map = json.decode(response.body);

    if(map["status"] == 1)
    {
      AwesomeDialog(context: context,
          useRootNavigator: true,
          dialogType: DialogType.SUCCES,
          animType: AnimType.BOTTOMSLIDE,
          tittle: 'MODIFICATION DU PROFIL',
          desc: map["libelle"],
          btnOkOnPress: () {
            setState(() {
              profil = Display_Profil();
              if (map["solde_gems"]!="" && map["solde_credits"]!="") {
                globals.gems=num.parse(map["solde_gems"]);
                globals.credits=num.parse(map["solde_credits"]);
              }
            });
          }).show();
    }else{
      // If Email or Password did not Matched.
      // Showing Alert Dialog with Response JSON Message.
      AwesomeDialog(context: context,
          useRootNavigator: true,
          dialogType: DialogType.INFO,
          animType: AnimType.BOTTOMSLIDE,
          tittle: 'INFORMATIONS INCHANGEES',
          desc: map["libelle"],
          btnOkOnPress: () {
            setState(() {
              profil = Display_Profil();
              if (map["solde_gems"]!="" && map["solde_credits"]!="") {
                globals.gems=num.parse(map["solde_gems"]);
                globals.credits=num.parse(map["solde_credits"]);
              }
            });
          }).show();
    }
  }
}

class user {

  final String pseudo;
  final String email;
  final String newsletter;
  final String paypal;
  final String gems;
  final String credits;

  const user(this.pseudo,this.email,this.newsletter,this.paypal,this.gems,this.credits);
}