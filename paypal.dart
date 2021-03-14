import 'package:flutter/material.dart';
import 'globals.dart' as globals;
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'scratch.dart';
import 'appbar_draw.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:awesome_page_transitions/awesome_page_transitions.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'menu_member.dart';

class Affiche_Paypal extends StatefulWidget {
  num nbg;

  Affiche_Paypal({Key key, @required this.nbg}) : super(key: key);

  Affiche_PaypalState createState() {
    return Affiche_PaypalState();
  }
}

class Affiche_PaypalState extends State<Affiche_Paypal> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();
  final _montantController = TextEditingController();
  final _montanteur = TextEditingController();
  bool init = false;

  Future<String> val_gems;
  num min_euro=0;
  num calc=0;

  Future<String> Get_Value_GEMS() async {
    // SERVER LOGIN API URL
    var url2 = 'https://www.fortune-island.com/app/get_value_gems.php';

    // Starting Web API Call.
    var response2 = await http.get(url2, headers: {
      'content-type': 'application/json',
      'accept': 'application/json',
      'authorization': globals.token
    });

    // Getting Server response into variable.

    Map<String, dynamic> jsondata2 = json.decode(response2.body);

    print(jsondata2["value"]);
    return jsondata2["value"];
  }

  void initState() {
    val_gems = Get_Value_GEMS();
    init=true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appTitle = 'FORTUNE ISLAND';

    return Stack(children: <Widget>[
      Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[Colors.blue[300], Colors.blue[400]],
          ),
        ),
      ),
      Scaffold(
          appBar: drawappbar(true),
          backgroundColor: Colors.transparent,
          drawer: new DrawerOnly(className: Affiche_Paypal(nbg: widget.nbg)),
          body: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(
                  top: 10.0, bottom: 10, right: 10, left: 10),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white,
                  width: 3,
                ),
                borderRadius: BorderRadius.circular(25),
              ),
              child: FutureBuilder(
                  future: val_gems,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return new Center(
                          child: new CircularProgressIndicator(),
                        );
                      default:
                        if (snapshot.hasError) {
                          return new Center(
                            child: new Text('Error: ${snapshot.error}'),
                          );
                        } else {
                          String gem_val = snapshot.data;
                          min_euro = num.parse(gem_val)*widget.nbg;
                          if (init==true) {
                            _montantController.text=widget.nbg.toStringAsFixed(2);
                            _montanteur.text=min_euro.toStringAsFixed(2);
                            init=false;
                          }
                          if (gem_val.isEmpty) {
                            return Container(
                                child: Center(
                                    child: Text("Problème de connexion !!!",
                                        style:
                                            TextStyle(color: Colors.white))));
                          } else {
                            return Form(
                              key: _formKey,
                              autovalidate: true,
                              child: ListView(
                                shrinkWrap: true,
                                padding:
                                    EdgeInsets.only(left: 24.0, right: 24.0),
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.all(10.0),
                                    child: Center(
                                      child: Text("DEMANDE DE PAIEMENT PAYPAL",
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white)),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 12.0),
                                    child: TextFormField(
                                      autofocus: true,
                                      controller: _montantController,
                                      keyboardType: TextInputType.number,
                                      // Only numbers can be entered
                                      inputFormatters: [
                                        WhitelistingTextInputFormatter
                                            .digitsOnly
                                      ],
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(25.0)),
                                        fillColor: Colors.white,
                                        filled: true,
                                        icon: Icon(FontAwesomeIcons.solidGem,
                                            color: Colors.white),
                                        hintText: "Votre montant en GEMS",
                                        contentPadding: EdgeInsets.fromLTRB(
                                            20.0, 10.0, 20.0, 10.0),
                                        hintStyle:
                                            TextStyle(color: Colors.grey[400]),
                                      ),
                                      onChanged: (String value) {
                                        setState(() {
                                          if (value=="") {
                                            calc=0;
                                          }
                                          else {
                                            calc = num.parse(value) *
                                                num.parse(gem_val);
                                          }
                                          _montanteur.text=calc.toString();
                                        });
                                      },
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Entrez le nombre de GEMS à échanger !';
                                        }
                                        if (num.parse(value) < widget.nbg) {
                                          return 'Un minimum de ' +
                                              widget.nbg.toString() +
                                              ' GEMS est requis !';
                                        }
                                        if (num.parse(value)>globals.gems) {
                                          return "Vous ne disposez pas d'assez de GEMS";
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 12.0),
                                    child: TextFormField(
                                      controller: _montanteur,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(25.0)),
                                        fillColor: Colors.white,
                                        filled: true,
                                        icon: Icon(Icons.euro_symbol,
                                            color: Colors.white),
                                        contentPadding: EdgeInsets.fromLTRB(
                                            20.0, 10.0, 20.0, 10.0),
                                        hintStyle:
                                            TextStyle(color: Colors.grey[400]),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 24.0),
                                  Center(
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: 45,
                                      child: RaisedButton(
                                        color: Colors.green,
                                        textColor: Colors.white,
                                        padding:
                                            EdgeInsets.fromLTRB(9, 9, 9, 9),
                                        child: Text('DEMANDER LE PAIEMENT'),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(25)),
                                        onPressed: () {
                                          // Validate returns true if the form is valid, or false
                                          // otherwise.
                                          if (_formKey.currentState
                                              .validate()) {
                                            Valide_Paypal();
                                          } else {
                                            return null;
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10.0),
                                ],
                              ),
                            );
                          }
                        }
                    }
                  })))
    ]);
    // Build a Form widget using the _formKey created above.
  }

  Future Valide_Paypal() async {
    // For CircularProgressIndicator.
    bool visible = false;
    // Showing CircularProgressIndicator.
    setState(() {
      visible = true;
    });

    // Getting value from Controller
    double mt = double.parse(_montantController.text);

    if (mt < 0) {
      AwesomeDialog(
          context: context,
          useRootNavigator: true,
          dialogType: DialogType.ERROR,
          animType: AnimType.BOTTOMSLIDE,
          tittle: 'ERREUR',
          desc: 'Le nombre de GEMS doit être supérieur à 0 !',
          btnOkOnPress: () {
            Navigator.of(context).pop();
          }).show();
    }

    var url = 'https://www.fortune-island.com/app/request_paypal.php';
    // Store all data with Param Name.
    var data = {'id_membre': globals.id_membre, 'montant': mt};

    var requete_encode = jsonEncode(data);

    // Starting Web API Call.
    var response = await http.post(url, body: requete_encode, headers: {
      'content-type': 'application/json',
      'accept': 'application/json',
      'authorization': globals.token
    });
    print(response.body);
    // Getting Server response into variable.
    Map<String, dynamic> map = json.decode(response.body);

    if (map["solde_gems"]!="" && map["solde_credits"]!="") {
      setState(() {
        globals.gems=num.parse(map["solde_gems"]);
        globals.credits=num.parse(map["solde_credits"]);
      });
    }

    if (map["status"] == 1) {
      AwesomeDialog(
          context: context,
          useRootNavigator: true,
          dialogType: DialogType.SUCCES,
          animType: AnimType.BOTTOMSLIDE,
          tittle: 'DEMANDE DE PAIEMENT PAYPAL',
          desc: map["libelle"],
          btnOkOnPress: () {
            Navigator.push(
              context,
              AwesomePageRoute(
                transitionDuration: Duration(milliseconds: 600),
                exitPage: widget,
                enterPage: Affiche_Paypal(nbg: widget.nbg),
                transition: CubeTransition(),
              ),
            );
          }).show();

    } else {
      AwesomeDialog(
          context: context,
          useRootNavigator: true,
          dialogType: DialogType.ERROR,
          animType: AnimType.BOTTOMSLIDE,
          tittle: 'ERREUR',
          desc: map["libelle"],
          btnOkOnPress: () {
            Navigator.push(
              context,
              AwesomePageRoute(
                transitionDuration: Duration(milliseconds: 600),
                exitPage: widget,
                enterPage: Affiche_Paypal(nbg: widget.nbg),
                transition: CubeTransition(),
              ),
            );
          }).show();
    }
  }
}
