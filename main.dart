import 'dart:ui';
import 'package:flutter/material.dart';
import 'login.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'home.dart';
import 'globals.dart' as globals;
import 'package:awesome_page_transitions/awesome_page_transitions.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override

  MyApp_State createState() {
    return MyApp_State();
  }
}

class MyApp_State extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }


  final appTitle = 'FORTUNE ISLAND';

  String mail='';
  String pass='';

  Future<void> initPlatformState() async {
    if (!mounted) return;

    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

    var settings = {
      OSiOSSettings.autoPrompt: false,
      OSiOSSettings.promptBeforeOpeningPushUrl: true
    };


    // NOTE: Replace with your own app ID from https://www.onesignal.com
    await OneSignal.shared.init("6387f006-d4a7-42a8-ac8d-50e5a2b70fc9", iOSSettings: settings);

    OneSignal.shared.setInFocusDisplayType(OSNotificationDisplayType.notification);
    OneSignal.shared.getPermissionSubscriptionState().then((response) {
      globals.OneSignal_ID = response.subscriptionStatus.userId.toString();
      print("ONESIGNAL USER_ID : "+globals.OneSignal_ID);
    });
  }

  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'FORTUNE ISLAND',
        theme: ThemeData(
            primarySwatch: Colors.blue,
            inputDecorationTheme: const InputDecorationTheme(
              labelStyle: TextStyle(color: Colors.white),
              hintStyle: TextStyle(color: Colors.white),
            ),
            fontFamily: 'PoetsenOne',
            scaffoldBackgroundColor: const Color(0xFFEFEFEF)
        ),
        home: Builder(
            builder: (context) => Stack(
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
                    appBar: new AppBar(
                      title: new Text("FORTUNE ISLAND",style: TextStyle(fontFamily: 'Azonix')),
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
                    ),
                    backgroundColor: Colors.transparent,
                    body:
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            margin : const EdgeInsets.only(bottom:20),
                            child: Icon(FontAwesomeIcons.solidGem,color: Colors.amber[200],size:70),
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom:30),
                            child : Text("FORTUNE ISLAND",style: TextStyle(color: Colors.white,fontSize: 30,fontWeight: FontWeight.w600,fontFamily: 'Azonix')),
                          ),
                          Container(
                            margin : const EdgeInsets.only(bottom:30),
                            child: Text('JEU 100 % GRATUIT 100 % GAGNANT',style: TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.w500)),
                          ),
                          Container(
                            margin : const EdgeInsets.only(bottom:30),
                            child: Text("GAGNEZ DES CADEAUX ET DU CASH !!!",style: TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.w500)),
                          ),
                          RaisedButton(
                            textColor: Colors.white,
                            color: Colors.green,
                            child :  Text("COMMENCER",style: TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.w500)),
                            onPressed: () async {
                              bool islog = await isconnect();
                              if (islog==false) {
                                Navigator.push(
                                  context,
                                  AwesomePageRoute(
                                    transitionDuration: Duration(milliseconds: 1000),
                                    exitPage: widget,
                                    enterPage: LoginPage(),
                                    transition: RotateUpTransition(),
                                  ),
                                );
                              }
                              else {
                                Navigator.push(
                                  context,
                                  AwesomePageRoute(
                                    transitionDuration: Duration(milliseconds: 1000),
                                    exitPage: widget,
                                    enterPage: HomePage(),
                                    transition: RotateUpTransition(),
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  )
                ]
            )
        )
    );
  }

  Future <bool> isconnect() async {
    // Create storage

    final storage = new FlutterSecureStorage();

// Read value

    mail = await storage.read(key: "e");
    pass = await storage.read(key: "p");

    if (mail!=null && pass!=null) {

      var url = 'https://www.fortune-island.com/app/login.php';

      // Store all data with Param Name.
      var data = {'email': mail, 'password': pass};

      // Starting Web API Call.
      var response = await http.post(url, body: json.encode(data),headers: {'content-type': 'application/json','accept': 'application/json'});

      print(json.decode(response.body));
      // Getting Server response into variable.

      Map <String,dynamic> map = json.decode(response.body);

      // If the Response Message is Matched.
      if (map["status"] == 1) {
        // l'email et le mot de passe sont correct
        final storage = new FlutterSecureStorage();

        await storage.write(key: "i", value: map["id_membre"]);
        await storage.write(key: "e", value: mail);
        await storage.write(key: "p", value: pass);
        await storage.write(key: "t", value: map["jwt"]);

        globals.id_membre=map["id_membre"];
        globals.token=map["jwt"];
        globals.credits=num.parse(map["credits"]);
        globals.gems=num.parse(map["gems"]);

        OneSignal.shared.setExternalUserId(map["id_membre"]);
        return true;
      }
      else {
        // l'email et mot de passe stocké ne permettent pas de se connecter
        // rediriger vers la fenêtre de login
        return false;
      }
    }
    else {
      // email et password n'existe pas
      return false;
    }
  }
}
