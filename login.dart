import 'package:flutter/material.dart';
import 'signup.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:email_validator/email_validator.dart';
import 'home.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'globals.dart' as globals;
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:awesome_page_transitions/awesome_page_transitions.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

// Create a Form widget.
class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() {
    return LoginPageState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class LoginPageState extends State<LoginPage> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool isLogin = false;

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
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
        appBar: AppBar(
          title: Text(appTitle,style: TextStyle(fontFamily: 'Azonix')),
          centerTitle:true,
        ),
    backgroundColor: Colors.transparent,
    body:
          Container(
            width:MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
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
          autovalidate:true,
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(left: 24.0, right: 24.0),
            children: <Widget>[
              Icon(
                Icons.account_box,
                color: Colors.white,
                size: 120,
              ),
              SizedBox(height: 25.0),
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
                  hintStyle: TextStyle(color: Colors.grey[500],fontSize: 15),
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
              SizedBox(height: 8.0),
              TextFormField(
                autofocus: false,
                obscureText: true,
                controller: _passwordController,
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
              SizedBox(height: 24.0),
              Center(
                child: Container(
                  width:MediaQuery.of(context).size.width,
                  height:45,
                  child: RaisedButton(
                    color: Colors.green,
                    textColor: Colors.white,
                    padding: EdgeInsets.fromLTRB(9, 9, 9, 9),
                    child: Text('CONNEXION'),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)
                    ),
                    onPressed: () {
                      // Validate returns true if the form is valid, or false
                      // otherwise.
                      if (_formKey.currentState.validate()) {
                        // If the form is valid, display a Snackbar.
                        _formKey.currentState.save();
                        userLogin();
                      }
                    },
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              Center(
                child: Text("Vous n'avez pas de compte ?",style: TextStyle(color: Colors.white)),
              ),
              SizedBox(height: 10.0),
              Center(
                child: Container(
                  width:  MediaQuery.of(context).size.width,
                  height:45,
                  child: RaisedButton(
                    color: Colors.green,
                    textColor: Colors.white,
                    padding: EdgeInsets.fromLTRB(9, 9, 9, 9),
                    child: Text('CREER UN COMPTE'),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)
                    ),
                    onPressed: () {
                      // Validate returns true if the form is valid, or false
                      // otherwise.
                      Navigator.push(
                        context,
                        AwesomePageRoute(
                          transitionDuration: Duration(milliseconds: 600),
                          exitPage: widget,
                          enterPage: SignUp(),
                          transition: CubeTransition(),
                        ),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(height: 10.0),
            ],
          ),
        ),
          )
    )
    ]
      );
  }

  Future userLogin() async{
    // Showing CircularProgressIndicator.
    CircularProgressIndicator();
    // Getting value from Controller
    String email = _emailController.text;
    String password = _passwordController.text;

    // SERVER LOGIN API URL
    var url = 'https://www.fortune-island.com/app/login.php';

    // Store all data with Param Name.
    var data = {'email': email, 'password' : password};

    // Starting Web API Call.
    var response = await http.post(url, body: json.encode(data));

    // Getting Server response into variable.
    Map <String,dynamic> map = json.decode(response.body);

    print(response.body);

    // If the Response Message is Matched.
    if(map["status"] == 1)
    {
      // Hiding the CircularProgressIndicator.

      final storage = new FlutterSecureStorage();

      await storage.write(key: "i", value: map["id_membre"]);
      await storage.write(key: "e", value: email);
      await storage.write(key: "p", value: password);
      await storage.write(key: "t", value: map["jwt"]);

      globals.id_membre=map["id_membre"];
      globals.token=map["jwt"];
      globals.credits=num.parse(map["credits"]);
      globals.gems=num.parse(map["gems"]);

      OneSignal.shared.setExternalUserId(map["id_membre"]);

      AwesomeDialog(context: context,
          useRootNavigator: true,
          dialogType: DialogType.SUCCES,
          animType: AnimType.BOTTOMSLIDE,
          tittle: 'CONNEXION',
          desc: map["libelle"],
          btnOkOnPress: () {
            // Navigate to Home Screen
            Navigator.push(
                context,
              AwesomePageRoute(
                transitionDuration: Duration(milliseconds: 600),
                exitPage: widget,
                enterPage: HomePage(),
                transition: CubeTransition(),
              ),
            );
          }).show();
    }else{
      // If Email or Password did not Matched.
      // Showing Alert Dialog with Response JSON Message.

      AwesomeDialog(context: context,
          useRootNavigator: true,
          dialogType: DialogType.ERROR,
          animType: AnimType.BOTTOMSLIDE,
          tittle: 'ERREUR',
          desc: map["libelle"],
          btnOkOnPress: () {

          }).show();
    }
  }
}
