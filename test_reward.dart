import 'package:flutter/material.dart';
import 'appbar_draw.dart';
import 'menu_member.dart';
import 'package:firebase_admob/firebase_admob.dart';

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

  int coins=0;
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
          coins=coins+rewardAmount;
          load=false;
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
    return Scaffold(
      appBar: drawappbar(true),
      drawer: new DrawerOnly(className: Reward_Video()),
      body:
      Center(
        child: Column (
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Visibility(
                maintainSize: true,
                maintainAnimation: true,
                maintainState: true,
                visible: visible,
                child: Container(
                    child: CircularProgressIndicator()
                )
            ),
          Container(
            width: 300,
            height: 45,
            margin: const EdgeInsets.only(bottom: 20.0),
            child: RaisedButton(
              color: Colors.green,
              textColor: Colors.white,
              child: Text("SHOW VIDEO AD"),
              onPressed: () {
                setState(() {
                  visible=true;
                });
                VideoAd.load(adUnitId: RewardedVideoAd.testAdUnitId,targetingInfo: targetingInfo);
              },
            ),
          ),
            Text("YOU HAVE $coins COINS"),
          ],
        )
      ),
    );
  }
}