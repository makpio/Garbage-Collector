import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:garbage_collector/screens/edit_profile_screen.dart';
import 'package:latlong/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'edit_item_screen.dart';

class ProfileScreen extends StatelessWidget {
  final user;
  final userId;

  ProfileScreen({
    Key key,
    @required this.user,
    @required this.userId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FirebaseAuth.instance.currentUser.uid == userId
          ? AppBar(
              centerTitle: true,
              title: Text(
                'My profile',
                textAlign: TextAlign.center,
              ),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.edit_outlined),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditUserScreen(
                          user: user,
                          userId: userId,
                        ),
                      ),
                    );
                  },
                )
              ],
            )
          : AppBar(
              centerTitle: true,
              title: Text(
                'User profile',
                textAlign: TextAlign.center,
              ),
            ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Column(
              children: <Widget>[
                user['imageUrl'] != null
                    ? Container(
                        width: 500.0,
                        height: 500.0,
                        decoration: BoxDecoration(
                            //border: Border.all(width: 5, color: Colors.white),
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              fit: BoxFit.fill,
                              image: NetworkImage(user['imageUrl']),
                              alignment: Alignment.center,
                            )))
                    : Container(
                        width: 500.0,
                        height: 500.0,
                        child: Text(
                          'No image selected',
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        alignment: Alignment.center,
                      ),
                SizedBox(
                  height: 10,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(children: [
                        SizedBox(width: 5),
                        Icon(
                          Icons.face_outlined,
                          color: Colors.blue,
                        ),
                        SizedBox(width: 20),
                        Text(
                          ' Name ',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ]),
                      Spacer(),
                      Flexible(
                        child: Text(
                          user['username'],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: 5),
                    ]),
                SizedBox(
                  height: 50,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(children: [
                        SizedBox(width: 5),
                        Icon(
                          Icons.mail_outline,
                          color: Colors.blue,
                        ),
                        SizedBox(width: 20),
                        Text(
                          'E-mail  ',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ]),
                      Spacer(),
                      Flexible(
                        child: Text(
                          user['email'],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: 5),
                    ]),
                SizedBox(
                  height: 50,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(children: [
                        SizedBox(width: 5),
                        Icon(
                          Icons.phone_android_outlined,
                          color: Colors.blue,
                        ),
                        SizedBox(width: 20),
                        Text(
                          'Phone  ',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ]),
                      Spacer(),
                      Flexible(
                        child: Text(
                          user['phoneNo'].toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: 5),
                    ]),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
