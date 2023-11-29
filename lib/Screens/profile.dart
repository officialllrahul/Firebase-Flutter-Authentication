import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebseauthentication/Screens/edit_profile.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  User ? _user;
  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((event) {
      setState(() {
        _user= event;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              if (_user != null && _user!.photoURL != null)
                Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage(_user!.photoURL!),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              SizedBox(height: 15,),
              if (_user != null && _user!.email != null)
                Text(_user!.email!),

              Container(
                margin: EdgeInsets.all(10),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,MaterialPageRoute(builder: (context)=>EditProfile()));
                  },
                  child: Text("Edit Profile"),

                ),
              )
            ],
          ),

        ),
      ),
    );
  }
}
