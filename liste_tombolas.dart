import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'menu_member.dart';
import 'globals.dart' as globals;
import 'appbar_draw.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

// Create a Form widget.
class Affiche_Liste_Tombola extends StatefulWidget {
  @override
  _Affiche_Liste_Tombola_State createState() {
    return _Affiche_Liste_Tombola_State();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.

class _Affiche_Liste_Tombola_State extends State<Affiche_Liste_Tombola> {
  @override
  bool load=false;
  bool visible=false;
  String tombola_select="";
  num prix=0.00;

  Future<List<Tombola>> ListTombola;

  Future <List<Tombola>> Tombola_display() async {
    // SERVER LOGIN API URL
    var url = 'https://www.fortune-island.com/app/display_list_tombola.php';

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

    print (response.body);
    List<Tombola> Tombolas = [];
    if (jsondata.containsKey('tombola')) {
      for (var u in jsondata['tombola']) {
        Tombola tombola = Tombola(
            u["id"],
            u["libelle"],
            u["date_debut_validation"],
            u["gain"],
            u["nb_tickets_achat"],
            u["nb_tickets_total"],
            u["nb"],
            u["prix"]);
        Tombolas.add(tombola);
      }
    }
    return Tombolas;
  }

  void initState() {
    super.initState();
    ListTombola = Tombola_display();
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
            drawer: new DrawerOnly(className: Affiche_Liste_Tombola()),
            body:
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child:
              FutureBuilder(
                  future: ListTombola,
                  // ignore: missing_return
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return new Center(
                          child: new CircularProgressIndicator(),
                        );
                        break;
                      default:
                        if (snapshot.hasError) {
                          return new Center(
                            child: new Text('Error: ${snapshot.error}'),);
                        }
                        else {
                          List<Tombola> values = snapshot.data;
                          if (values.isEmpty) {
                            return Container(
                                child: Center(
                                    child: Text("Aucune tombola disponible !!!")
                                )
                            );
                          }
                          else {
                            return ListView.builder(itemCount: values.length,
                                itemBuilder: (_, index) {
                                  var mt_jackpot=num.parse(values[index].gain);
                                  var f = new NumberFormat.currency(locale: "fr-FR",symbol: "");
                                  var mt_jackpot_f=f.format(mt_jackpot);
                                  return Column(
                                      children: [
                                        Container(
                                          height: 30,
                                          width: MediaQuery.of(context).size.width*90/100,
                                          margin : EdgeInsets.only(top:20),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.blue[700],
                                                width: 2,
                                              ),
                                              borderRadius: BorderRadius.only(topLeft : Radius.circular(25),topRight: Radius.circular(25)),
                                              color: Colors.blue[700]
                                          ),
                                          child : new Text(values[index].libelle,textAlign: TextAlign.center,style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.w500,color: Colors.white),),
                                        ),
                                        Center(
                                        child : Container(
                                            height:MediaQuery.of(context).size.height/4,
                                            width: MediaQuery.of(context).size.width*90/100,
                                            margin: EdgeInsets.only(bottom:20),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.grey[500],
                                                width: 2,
                                              ),
                                              borderRadius: BorderRadius.only(bottomLeft : Radius.circular(25),bottomRight: Radius.circular(25)),
                                              color:Colors.white,
                                            ),
                                            child :
                                                Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                        Container(
                                          margin : EdgeInsets.only(bottom:10),
                                          child : RichText(
                                        text: TextSpan(
                                        children: [
                                            TextSpan(
                                            text: mt_jackpot_f,
                                            style: TextStyle(fontSize: 20,fontWeight: FontWeight.w800,color: Colors.black)
                                        ),
                                        WidgetSpan(
                                            child: Icon(FontAwesomeIcons.euroSign,color: Colors.amber[900],size:20)
                                        ),
                                      ],
                                  ),
                                  ),
                                        ),
                                  Container(
                                      margin : EdgeInsets.only(bottom:10),
                                    child :
                                      Text("Vos tickets : "+values[index].nb_tickets_membre)
                                  ),
                                                  Container(
                                                      margin : EdgeInsets.only(bottom:10),
                                                      child :
                                                      Text("Prix Ticket : "+values[index].prix+" GEMS")
                                                  ),
                                                  double.parse(values[index].prix)<=globals.credits ?
                                                  Container(
                                  child : RaisedButton(
                                  color: Colors.green,
                                  textColor: Colors.white,
                                  padding: EdgeInsets.fromLTRB(
                                  9, 9, 9, 9),
                                  child: Text(
                                  'ACHETEZ UN TICKET'),
                                  onPressed: () {
                                    prix=double.parse(values[index].prix);
                                    if (prix>globals.credits) {
                                      AwesomeDialog(context: context,
                                          useRootNavigator: true,
                                          dialogType: DialogType.ERROR,
                                          animType: AnimType.BOTTOMSLIDE,
                                          tittle: "INFORMATION",
                                          desc: "Vous ne disposez pas d'assez de GEMS !",
                                          btnOkOnPress: () {

                                          }).show();
                                    }
                                    else {
                                      tombola_select = values[index].id;
                                      setState(() {
                                        visible = true;
                                      });
                                      Valide_tombola(tombola_select,prix);
                                    }
                                  },
                                  ),
                                  )
                                  :
                                                      Container(
                                                          child :
                                                          Text("")
                                                      )
                                  ]
                                        ),
                                        ),
                                  )
                                  ]
                                  );
                                }
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

  Future Valide_tombola(String id_tombola,double prix_t) async{
    // For CircularProgressIndicator.
    bool visible = false ;
    // Showing CircularProgressIndicator.
    setState(() {
      visible = true ;
    });

    // SERVER LOGIN API URL
    var url = 'https://www.fortune-island.com/app/valide_tombola.php';

    // Store all data with Param Name.
    var data = {'id_membre':globals.id_membre, 'id_tombola':id_tombola};

    var tombola_encode=jsonEncode(data);

    // Starting Web API Call.
    var response = await http.post(url, body: tombola_encode,headers: {'content-type': 'application/json','accept': 'application/json','authorization': globals.token});

    // Getting Server response into variable.
    Map <String,dynamic> map2 = json.decode(response.body);

    setState(() {
      visible = false;
      if (map2["solde_gems"]!="" && map2["solde_credits"]!="") {
        globals.gems=num.parse(map2["solde_gems"]);
        globals.credits=num.parse(map2["solde_credits"]);
      }
      ListTombola=Tombola_display();
    });

    // If the Response Message is Matched.
    if(map2["status"] == 1)
    {
      AwesomeDialog(context: context,
          useRootNavigator: true,
          dialogType: DialogType.SUCCES,
          animType: AnimType.BOTTOMSLIDE,
          tittle: 'VALIDATION',
          desc: map2["message"],
          btnOkOnPress: () {

          }).show();

    }else{
      // Showing Alert Dialog with Response JSON Message.
      AwesomeDialog(context: context,
          useRootNavigator: true,
          dialogType: DialogType.ERROR,
          animType: AnimType.BOTTOMSLIDE,
          tittle: 'ERREUR',
          desc: map2["message"],
          btnOkOnPress: () {

          }).show();
    }
  }
                        }

class Tombola {

  final String id;
  final String libelle;
  final String datedebut;
  final String gain;
  final String nb_tickets_achat;
  final String nb_tickets_total;
  final String nb_tickets_membre;
  final String prix;

  const Tombola(this.id, this.libelle, this.datedebut,this.gain,this.nb_tickets_achat,this.nb_tickets_total,this.nb_tickets_membre,this.prix);

}