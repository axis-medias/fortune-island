import 'package:flutter/material.dart';
import 'appbar_draw.dart';
import 'menu_member.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'globals.dart' as globals;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:awesome_dialog/awesome_dialog.dart';

const testDevices = "Your_DEVICE_ID";

class Reward_Video extends StatefulWidget {
  @override
  Reward_Video_State createState() {
    return Reward_Video_State();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.

class Reward_Video_State extends State<Reward_Video> {

  static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(testDevices: testDevices!=null ? <String> ['tessDevices'] : null,keywords: <String> ['game','bet'],nonPersonalizedAds: true);

  RewardedVideoAd VideoAd = RewardedVideoAd.instance;
  bool load=false;
  bool visible=false;

  @override
  void initState() {
    super.initState();
    //FirebaseAdMob.instance.initialize(appId: "ca-app-pub-8677431175756102~8892789953");
    FirebaseAdMob.instance.initialize(appId: FirebaseAdMob.testAppId);

    VideoAd.listener=(RewardedVideoAdEvent event,{String rewardType, int rewardAmount}) {
      print('REWARDED VIDEO ADS $event');
      if (event == RewardedVideoAdEvent.rewarded) {
        setState(() {
          load=false;
          Valide_Reward_Video();
        });
      }
      if (event == RewardedVideoAdEvent.loaded) {
        print('VIDEO LOADED !!!');
        load=true;
        visible=false;
        VideoAd.show();
      }
    };
  }

  Widget build(BuildContext context) {
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
    drawer: new DrawerOnly(className: Reward_Video()),
      body:
      Center(
          child: Column (
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                width: 300,
                height: 45,
                margin: const EdgeInsets.only(bottom: 20.0),
                child: RaisedButton(
                  color: Colors.green,
                  textColor: Colors.white,
                  child: Text("VOIR UNE VIDEO"),
                  onPressed: () {
                    setState(() {
                      visible=true;
                    });
                    VideoAd.load(adUnitId: RewardedVideoAd.testAdUnitId,targetingInfo: targetingInfo);
                  },
                ),
              ),
            ],
          )
      ),
    )
    ]
      );
  }

  Future Valide_Reward_Video() async{
    // For CircularProgressIndicator.
    bool visible = false ;
    // Showing CircularProgressIndicator.
    setState(() {
      visible = true ;
    });

    // SERVER LOGIN API URL
    var url = 'https://www.fortune-island.com/app/rvpay.php';

    // Store all data with Param Name.
    var data = {'id_membre':globals.id_membre};

    var tombola_encode=jsonEncode(data);

    // Starting Web API Call.
    var response = await http.post(url, body: tombola_encode,headers: {'content-type': 'application/json','accept': 'application/json','authorization': globals.token});

    // Getting Server response into variable.
    Map <String,dynamic> map2 = json.decode(response.body);

    print(response.body);

    if (map2["solde_gems"]!="" && map2["solde_credits"]!="") {
      setState(() {
        globals.gems=num.parse(map2["solde_gems"]);
        globals.credits=num.parse(map2["solde_credits"]);
      });
    }

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