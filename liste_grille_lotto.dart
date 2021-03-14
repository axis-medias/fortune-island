import 'package:flutter/material.dart';
import 'grid.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'menu_member.dart';
import 'globals.dart' as globals;
import 'lotto.dart';
import 'appbar_draw.dart';
import 'package:awesome_page_transitions/awesome_page_transitions.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

// Create a Form widget.
class Affiche_Liste_Lotto extends StatefulWidget {
  @override
  _Affiche_Liste_Lotto_State createState() {
    return _Affiche_Liste_Lotto_State();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.

class _Affiche_Liste_Lotto_State extends State<Affiche_Liste_Lotto> {
  @override

  Future<List<Lotto_grid>> ListLotto;

  Future <String> jackpot;

  Future <String> Get_Amount_Jackpot() async {
    // SERVER LOGIN API URL
    var url2 = 'https://www.fortune-island.com/app/get_jackpot_lotto.php';

    // Starting Web API Call.
    var response2 = await http.get(url2,headers: {'content-type': 'application/json','accept': 'application/json','authorization': globals.token});

    // Getting Server response into variable.

    Map<String, dynamic> jsondata2 = json.decode(response2.body);

    return jsondata2["value"];
  }

  Future <List<Lotto_grid>> Grille_display() async {
    // SERVER LOGIN API URL
    var url = 'https://www.fortune-island.com/app/display_list_lotto.php';

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

    List<Lotto_grid> Lottos = [];

    var i=0;
    if (jsondata.containsKey('lotto')) {
      for (var u in jsondata['lotto']) {
        i = i + 1;
        Lotto_grid lottos = Lotto_grid(
            u["id"], u["libelle"], u["date_fin"], u["prix_grille"]);
        Lottos.add(lottos);
      }
    }
    return Lottos;
  }

  void initState() {
    ListLotto = Grille_display();
    jackpot = Get_Amount_Jackpot();
    super.initState();
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
            drawer: new DrawerOnly(className: Affiche_Liste_Lotto()),
            body: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child:
              FutureBuilder(
                  future: Future.wait([ListLotto,jackpot]),
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
                            List<Lotto_grid> values = snapshot.data[0];
                            String Jackpot_val=snapshot.data[1];
                            if (values.isEmpty) {
                            return Container(
                            child: Center(
                            child: Text("Aucune grille de loto disponible !!!",style: TextStyle(color: Colors.white))
                            )
                            );
                            }
                            else {
                              return ListView.builder(itemCount: values.length,
                              itemBuilder: (_, index) {
                                var jac=num.parse(Jackpot_val);
                                var f = new NumberFormat.currency(locale: "fr-FR",symbol: "");
                                var jac_f=f.format(jac);
                                var parsedDate = DateTime.parse(values[index].datefin);
                                final formatter = new DateFormat('dd-MM-yyyy HH:mm');
                                var dat = formatter.format(parsedDate);
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
                                  margin: EdgeInsets.only(bottom:10,right:10,left:10),
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
                                                    text: "JACKPOT : "+jac_f+" ",
                                                    style: TextStyle(fontSize: 20,fontWeight: FontWeight.w800,color: Colors.black)
                                                ),
                                                WidgetSpan(
                                                    child: Icon(FontAwesomeIcons.solidGem,color: Colors.amber[900],size:20)
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const Divider(
                                          color: Colors.black,
                                          height: 10,
                                          thickness: 1,
                                          indent: 0,
                                          endIndent: 0,
                                        ),
                                        Container(
                                            margin : EdgeInsets.only(bottom:10),
                                            child :
                                            Text("PRIX GRILLE : "+values[index].prix+" JETONS")
                                        ),
                                        Container(
                                          margin : EdgeInsets.only(bottom:10),
                                          child :
                                          Text("TIRAGE LE : "+ dat+" ",
                                              style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: Colors.black)
                                          ),
                                        ),
                                        const Divider(
                                          color: Colors.black,
                                          height: 10,
                                          thickness: 1,
                                          indent: 0,
                                          endIndent: 0,
                                        ),
                                        double.parse(values[index].prix)<=globals.credits ?
                                        Container(
                                          height: 50,
                                          width: MediaQuery.of(context).size.width*90/100,
                                          child : RaisedButton(
                                            color: Colors.green,
                                            textColor: Colors.white,
                                            padding: EdgeInsets.fromLTRB(
                                                9, 9, 9, 9),
                                            child: Text(
                                                'JOUEZ UNE GRILLE'),
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                AwesomePageRoute(
                                                  transitionDuration: Duration(milliseconds: 600),
                                                  exitPage: widget,
                                                  enterPage: Lotto(id:values[index].id),
                                                  transition: CubeTransition(),
                                                ),
                                              );
                                            },
                                          ),
                                        )
                                        :
                                        Container(
                                            child :
                                            Text("")
                                        ),
                                      ]
                                  ),
                                ),
                              )
                            ],
                            );
                            }
                            );
                        }
                    };
                  }
                  }
              ),
            )
    )
    ]
    );
  }
}

class Lotto_grid {

  final String id;
  final String libelle;
  final String datefin;
  final String prix;

  const Lotto_grid(this.id, this.libelle, this.datefin,this.prix);

}