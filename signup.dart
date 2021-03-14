import 'package:flutter/material.dart';
import 'package:gameapp/login.dart';
import 'globals.dart' as globals;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:awesome_page_transitions/awesome_page_transitions.dart';

class SignUp extends StatefulWidget {
  SignUpState createState() {
    return SignUpState();
  }
}

class SignUpState extends State<SignUp> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();
  final _pseudoController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _password2Controller = TextEditingController();
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
        appBar: AppBar(
          title: Text(appTitle,style: TextStyle(fontFamily: 'Azonix')),
        ),
        backgroundColor: Colors.transparent,
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
              Text("CREER UN COMPTE",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500,color: Colors.white)),
              ),
              ),
              Padding(
                padding: const EdgeInsets.only(top:12.0),
                child:
                TextFormField(
                  autofocus: true,
                  controller: _pseudoController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(25.0)),
                    fillColor: Colors.white, filled: true,
                    icon: Icon(Icons.perm_identity,color: Colors.white),
                    hintText: "Votre pseudo",
                    contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                    hintStyle: TextStyle(color: Colors.grey[400]),
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Entrez votre pseudo';
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
                controller: _usernameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(25.0)),
                  fillColor: Colors.white, filled: true,
                  icon: Icon(Icons.email,color: Colors.white),
                  hintText: "Votre email",
                  contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  hintStyle: TextStyle(color: Colors.grey[400]),
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Entrez votre email';
                  }
                  return null;
                },
              ),
            ),
              SizedBox(height: 8.0),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(25.0)),
                  fillColor: Colors.white, filled: true,
                  icon: Icon(Icons.lock,color: Colors.white),
                  hintText: "Votre mot de passe",
                  contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  hintStyle: TextStyle(color: Colors.grey[400]),
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Entrez votre mot de passe';
                  }
                  return null;
                },
              ),
              SizedBox(height: 8.0),
              TextFormField(
                controller: _password2Controller,
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(25.0)),
                  fillColor: Colors.white, filled: true,
                  icon: Icon(Icons.lock,color: Colors.white),
                  hintText: "Confirmation de mot de passe",
                  contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  hintStyle: TextStyle(color: Colors.grey[400]),
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Entrez la confirmation de votre mot de passe';
                  }
                  if(value != _passwordController.text) {
                    return 'Les mots de passe ne sont pas identiques !';
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
                  child: Text('CREER UN COMPTE'),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)
                  ),
                  onPressed: () {
                    // Validate returns true if the form is valid, or false
                    // otherwise.
                    if (_formKey.currentState.validate()) {
                      // If the form is valid, display a Snackbar.
                      _formKey.currentState.save();
                      userSignUp();
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

  Future userSignUp() async{
    // For CircularProgressIndicator.
    bool visible = false ;
    // Showing CircularProgressIndicator.
    setState(() {
      visible = true ;
    });

    // Getting value from Controller
    String pseudo = _pseudoController.text;
    String email = _usernameController.text;
    String password = _passwordController.text;
    String password2 = _password2Controller.text;

    // SERVER LOGIN API URL
    var url = 'https://www.fortune-island.com/app/signup.php';

    // Store all data with Param Name.
    var data = {'pseudo': pseudo, 'email': email, 'password' : password};

    // Starting Web API Call.
    var response = await http.post(url, body: json.encode(data));

    // Getting Server response into variable.
    Map <String,dynamic> map = json.decode(response.body);

    // If the Response Message is Matched.
    if(map["status"] == '1')
    {
    // Hiding the CircularProgressIndicator.
      setState(() {
        visible = false;
      });

        AwesomeDialog(context: context,
        useRootNavigator: true,
        dialogType: DialogType.SUCCES,
        animType: AnimType.BOTTOMSLIDE,
        tittle: 'INSCRIPTION',
        desc: map['libelle'],
        btnOkOnPress: () {
          // Navigate to Home Screen
          Navigator.push(
              context,
            AwesomePageRoute(
              transitionDuration: Duration(milliseconds: 600),
              exitPage: widget,
              enterPage: LoginPage(),
              transition: CubeTransition(),
            ),
          );
        }).show();

    }else{

      // If Email or Password did not Matched.
      // Hiding the CircularProgressIndicator.
      setState(() {
        visible = false;
      });

      // Showing Alert Dialog with Response JSON Message.
      AwesomeDialog(context: context,
          useRootNavigator: true,
          dialogType: DialogType.ERROR,
          animType: AnimType.BOTTOMSLIDE,
          tittle: 'INSCRIPTION',
          desc: map['libelle'],
          btnOkOnPress: () {}).show();
    }
  }
}