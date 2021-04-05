import 'package:flutter/material.dart';


class AuthenticationForm extends StatefulWidget {
  @override
  _AuthenticationFormState createState() => _AuthenticationFormState();
}

class _AuthenticationFormState extends State<AuthenticationForm> {
  final _formKey = GlobalKey<FormState>();

  var _isLogin = true;
  var _userEmail = '';
  var _userPassword = '';
  var _userName = '';

  void _trySubmit() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState.save();
      print(_userEmail);
      print(_userName);
      print(_userPassword);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(20), 
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey, 
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    key: ValueKey('userEmail'),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Email address can not be empty.';
                      }
                      else if(!value.contains('@')) {
                        return 'Please enter a valid email address.';
                      }
                      return null;

                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email address',
                    ),
                    onSaved: (value) {
                      _userEmail = value;
                    },
                  ),
                  TextFormField(
                    key: ValueKey('userName'),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Username can not be empty.';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Username',
                    ),
                    onSaved: (value) {
                      _userName = value;
                    },
                  ),
                  TextFormField(
                    key: ValueKey('userPassword'),
                    validator: (value) {
                      if (value.isEmpty || value.length < 8) {
                        return 'Password must be at least 8 characters long.';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Password'),
                    obscureText: true,
                    onSaved: (value) {
                      _userPassword = value;
                    },
                  ),
                  SizedBox(height: 12,),
                  ElevatedButton(
                    child: Text(_isLogin ? 'Log in' : 'Sign up'), 
                    onPressed: _trySubmit
                  ),
                  TextButton(
                    child: Text(_isLogin ? 'Create new account' : 'I already have an account'), 
                    onPressed: () {
                      setState(() {
                        _isLogin = !_isLogin;
                      });
                    },
                  )
                ],
              )
            )
          ),
        ),
      ),
    );
  }
}