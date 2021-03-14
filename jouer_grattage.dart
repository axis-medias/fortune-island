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

class ParamGrattage extends StatefulWidget {
  ParamGrattageState createState() {
    return ParamGrattageState();
  }
}

class ParamGrattageState extends State<ParamGrattage> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();
  final _miseController = TextEditingController();
  final _probController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final appTitle = 'FORTUNE ISLAND';

    return
      Stack(
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
                drawer: new DrawerOnly(className: ParamGrattage()),
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
                    child: Form(
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
                              Text("PARAMETRER VOTRE TICKET DE GRATTAGE",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500,color: Colors.white)),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top:12.0),
                            child:
                            TextFormField(
                              autofocus: true,
                              controller: _miseController,
                              keyboardType: TextInputType.number, // Only numbers can be entered
                              inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                              decoration: InputDecoration(
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(25.0)),
                                fillColor: Colors.white, filled: true,
                                icon: Icon(FontAwesomeIcons.coins,color: Colors.white),
                                hintText: "Votre mise",
                                contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                                hintStyle: TextStyle(color: Colors.grey[400]),
                              ),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Entrez votre mise';
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top:12.0),
                            child:
                            TextFormField(
                              autofocus: true,
                              controller: _probController,
                              keyboardType: TextInputType.number, // Only numbers can be entered
                              inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                              decoration: InputDecoration(
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(25.0)),
                                fillColor: Colors.white, filled: true,
                                icon: Icon(Icons.casino,color: Colors.white),
                                hintText: "Votre chance de gain (1 à 99)",
                                contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                                hintStyle: TextStyle(color: Colors.grey[400]),
                              ),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Entrez votre chance de gain';
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
                                child: Text('GRATTEZ'),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25)
                                ),
                                onPressed: () {
                                  // Validate returns true if the form is valid, or false
                                  // otherwise.
                                  if (_formKey.currentState.validate()) {
                                    ValideParam();
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
    // Build a Form widget using the _formKey created above.
  }

  Future ValideParam() async{
    // For CircularProgressIndicator.
    bool visible = false ;
    // Showing CircularProgressIndicator.
    setState(() {
      visible = true ;
    });

    // Getting value from Controller
    double mise = double.parse(_miseController.text);

    if (mise<0) {
      AwesomeDialog(context: context,
          useRootNavigator: true,
          dialogType: DialogType.ERROR,
          animType: AnimType.BOTTOMSLIDE,
          tittle: 'ERREUR',
          desc: 'La mise doit être supérieur à 0 !',
          btnOkOnPress: () {
          Navigator.of(context).pop();
          }).show();
    }
    double prob = double.parse(_probController.text);
    if (prob<1 || prob>99) {
      AwesomeDialog(context: context,
          useRootNavigator: true,
          dialogType: DialogType.ERROR,
          animType: AnimType.BOTTOMSLIDE,
          tittle: 'ERREUR',
          desc: 'La chance de gain doit être comprise entre 1 et 99 !',
          btnOkOnPress: () {
          Navigator.of(context).pop();
          }).show();
    }
    var url = 'https://www.fortune-island.com/app/get_ticket.php';
    // Store all data with Param Name.
    var data = {'id_membre':globals.id_membre,'mise': mise,'prob': prob};

    var ticket_encode=jsonEncode(data);

    // Starting Web API Call.
    var response = await http.post(url, body: ticket_encode,headers: {'content-type': 'application/json','accept': 'application/json','authorization': globals.token});
    print(response.body);
    // Getting Server response into variable.
    Map <String,dynamic> map = json.decode(response.body);

    if (map["status"]==1) {

      var gain = map["gain"];
      var id_ticket = map["id"];

      Navigator.push(
        context,
        AwesomePageRoute(
          transitionDuration: Duration(milliseconds: 600),
          exitPage: widget,
          enterPage: Affiche_Ticket_Grattage(id_ticket:id_ticket,gain:gain),
          transition: CubeTransition(),
        ),
      );
    }
    else {
      AwesomeDialog(context: context,
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
                enterPage: ParamGrattage(),
                transition: CubeTransition(),
              ),
            );
          }).show();
    }
  }
}