import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

import 'package:garbage_collector/widgets/auth_form.dart';


class Authenticate extends StatefulWidget {

  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  final _auth = FirebaseAuth.instance;

  void _submitAuthForm(
    String email, 
    String password, 
    String username, 
    bool isLogin,
    BuildContext ctx
    ) async {
    UserCredential userCredential;
    try {
      if (isLogin) {
        userCredential = await _auth.signInWithEmailAndPassword(
          email: email, 
          password: password
        );
      }
      else {
        userCredential = await _auth.createUserWithEmailAndPassword(
          email: email, 
          password: password
        );
      }
    } catch (err) {

      var message = 'An error occured. Please check your credentials!';

      if (err.message !=null) {
        message = err.message;
      }

      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(ctx).errorColor, 
        ),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(_submitAuthForm,),
    );
  }
}