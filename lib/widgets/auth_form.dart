import 'package:flutter/material.dart';


class AuthenticationForm extends StatefulWidget {
  @override
  _AuthenticationFormState createState() => _AuthenticationFormState();
}

class _AuthenticationFormState extends State<AuthenticationForm> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(20), 
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Form(child: Column(mainAxisSize: MainAxisSize.min,
             children: <Widget>[
               TextFormField(
                 keyboardType: TextInputType.emailAddress,
                 decoration: InputDecoration(
                   labelText: 'Email address',
                 ),
               ),
               TextFormField(
                 decoration: InputDecoration(
                   labelText: 'Username',
                 )
               ),
               TextFormField(
                 decoration: InputDecoration(
                   labelText: 'Password'),
                 obscureText: true,
               ),
               SizedBox(height: 12,),
               ElevatedButton(child: Text('Login'), onPressed: () {},),
               TextButton(child: Text('Create new account'), onPressed: () {},)
               ],
            ))
          ),
        ),
      ),
    );

      
  }
}