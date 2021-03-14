import 'package:flutter/material.dart';
import 'liste_grille_lotto.dart';
import 'dart:math';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'menu_member.dart';
import 'globals.dart' as globals;
import 'package:awesome_dialog/awesome_dialog.dart';
import 'appbar_draw.dart';
import 'package:awesome_page_transitions/awesome_page_transitions.dart';

class Lotto extends StatefulWidget {
  @override
  String id;
  Lotto({Key key, @required this.id}) : super(key: key);
  _LottoState createState() => new _LottoState();
}

class _LottoState extends State<Lotto> {

  bool load=false;
  bool visible=false;

  @override
  void initState() {
    super.initState();
  }

  var i=1;
  var nb_num=49;
  var no_select=[];
  var no_a_select=5;

  List<Color> colorList = List<Color>.generate(49, (int index) => Colors.white);

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
            drawer: new DrawerOnly(className: Lotto(id: widget.id)),
            body:
                Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
            child : Center(
              child: Column(
                children: <Widget>[
                  Container(
                    width:400,
                    height:30,
                    margin: const EdgeInsets.only(top: 10.0),
                      child : new Text("Selectionnez 5 numéros",textAlign: TextAlign.center,style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.w500,color: Colors.white)),
                  ),
                  Container(
                    width:400,
                    height:270,
                    margin: const EdgeInsets.only(top: 10.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(25),
                    ),
                child: new GridView.count(
                crossAxisCount: 9,
                padding: const EdgeInsets.all(10.0),
                mainAxisSpacing: 4.0,
                crossAxisSpacing: 4.0,
                children: new List<Widget>.generate(49, (index) {
                  return new GestureDetector(
                    onTap: () {
                      setState(() {
                        if (colorList[index] == Colors.white) {
                          if (no_select.length<no_a_select) {
                            colorList[index] = Colors.redAccent;
                            no_select.add(index+1);
                          }
                          else {
                            AwesomeDialog(context: context,
                                useRootNavigator: true,
                                dialogType: DialogType.WARNING,
                                animType: AnimType.BOTTOMSLIDE,
                                tittle: 'Attention',
                                desc: 'Vous ne pouvez pas sélectionner plus de 5 numéros !!!',
                                btnOkOnPress: () {}).show();
                          }
                        }
                        else {
                          colorList[index] = Colors.white;
                          no_select.remove(index+1);
                        }
                      });
                    },
                      child: Container(
                        decoration: BoxDecoration(
                          color: colorList[index],
                          border: Border.all(color: Colors.redAccent),
                          shape: BoxShape.circle,
                        ),
                        height: 30.0,
                        width: 30.0,
                        child: Center(
                          child: new Text((index+1).toString(),
                              style: colorList[index]==Colors.white ? TextStyle(color: Colors.redAccent, fontSize: 18,fontWeight: FontWeight.w500) : TextStyle(color: Colors.white, fontSize: 18,fontWeight: FontWeight.w500),
                              textAlign: TextAlign.center),
                        ),
                      ),
                  );
                }
                ),
              ),
                  ),
                  Container(
                    width:400,
                    height:30,
                    margin: const EdgeInsets.only(top: 10),
                      child : new Text("Vos numéros",textAlign: TextAlign.center,style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.w500,color: Colors.white)),
                  ),
                  Container(
                    width:400,
                    height:90,
                    margin: const EdgeInsets.only(top: 10.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                    color: Colors.white,
                    width: 2,
                  ),
                      borderRadius: BorderRadius.circular(25),
                    ),
                  child:
                    getWidget()
                  ),
                  Container(
                    width:300,
                    height:45,
                    margin: const EdgeInsets.only(top: 20.0),
                    child:
                  RaisedButton(
                    color: Colors.green,
                    textColor: Colors.white,
                    padding: EdgeInsets.fromLTRB(9, 9, 9, 9),
                    child: Container(
                      child: Text('TIRAGE ALEATOIRE'),
                    ),
                    onPressed: () {
                      Select_numbers();
                    },
                  ),
                  ),
                  Container(
                    width:300,
                    height:45,
                    margin: const EdgeInsets.only(top: 20.0),
                    child:
                  RaisedButton(
                    color: Colors.green,
                    textColor: Colors.white,
                    padding: EdgeInsets.fromLTRB(9, 9, 9, 9),
                    child: Text('VALIDER VOTRE GRILLE'),
                    onPressed: () {
                      if (no_select.length==5) {
                        setState(() {
                          visible=true;
                        });
                        Valide_grille();
                      }
                      else {
                        AwesomeDialog(context: context,
                            useRootNavigator: true,
                            dialogType: DialogType.WARNING,
                            animType: AnimType.BOTTOMSLIDE,
                            tittle: 'Attention',
                            desc: 'Merci de sélectionner 5 numéros !',
                            btnOkOnPress: () {}).show();
                      }
                    },
                  ),
                  ),
                  ]
              )
                          ),
                ),
                    )
    ]
    );
  }

  getWidget() {
    if (no_select.length==0) {
      return Center(child:Text("Aucun numéro sélectionné",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: Colors.white)));
    }
    else {
      return GridView.count(
          crossAxisCount: 5,
          padding: const EdgeInsets.all(10.0),
          mainAxisSpacing: 4.0,
          crossAxisSpacing: 4.0,
          children: new List<Widget>.generate(no_select.length, (index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipOval(
                child: Container(
                  color: Colors.redAccent,
                  height: 30.0,
                  width: 30.0,
                  child: Center(
                    child: new Text((no_select[index].toString()),
                        style: TextStyle(color: Colors.white, fontSize: 18,fontWeight: FontWeight.w500), textAlign: TextAlign.center,),
                  ),
                ),
              ),
            );
          }
    )
      );
    }
  }

  Select_numbers() {
    setState(() {
      var j = 1;
      var num_sel;
      var pos_sel;
      no_select=[];
      colorList=[];
      colorList=List<Color>.generate(49, (int index) => Colors.white);
      var rng = new Random();
      List tab=[];
      tab = List.generate(49, (int index) => index + 1);
      while (j <= no_a_select) {
        pos_sel = rng.nextInt(tab.length-1);
        num_sel=tab[pos_sel];
        no_select.add(num_sel);
        colorList[num_sel-1] = Colors.redAccent;
        tab.remove(num_sel);
        j++;
      }
    });
  }

  Future Valide_grille() async{
    // For CircularProgressIndicator.

    // SERVER LOGIN API URL
    var url = 'https://www.fortune-island.com/app/valide_lotto.php';

    // Store all data with Param Name.
    var data = {'id_membre':globals.id_membre,'id_grille':widget.id,'result':no_select};

    var grille_encode=jsonEncode(data);

    // Starting Web API Call.
    var response = await http.post(url, body: grille_encode,headers: {'content-type': 'application/json','accept': 'application/json','Authorization': globals.token});

    print(response.body);

    // Getting Server response into variable.
    Map <String,dynamic> map2  = json.decode(response.body);

    setState(() {
      visible = false;
      if (map2["solde_gems"]!="" && map2["solde_credits"]!="") {
        globals.gems=num.parse(map2["solde_gems"]);
        globals.credits=num.parse(map2["solde_credits"]);
      }
    });
    // If the Response Message is Matched.
    if(map2["status"] == 1)
    {
      // Hiding the CircularProgressIndicator.

      AwesomeDialog(context: context,
          useRootNavigator: true,
          dialogType: DialogType.SUCCES,
          animType: AnimType.BOTTOMSLIDE,
          tittle: 'SUCCES',
          desc: map2["message"],
          btnOkOnPress: () {
            Navigator.push(
              context,
                AwesomePageRoute(
                  transitionDuration: Duration(milliseconds: 600),
                  exitPage: widget,
                  enterPage: Affiche_Liste_Lotto(),
                  transition: CubeTransition(),
                ),
            );
          }).show();
    }else{
      // Hiding the CircularProgressIndicator.

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
