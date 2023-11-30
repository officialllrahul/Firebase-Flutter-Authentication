import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebseauthentication/Screens/dashboard.dart';
import 'package:firebseauthentication/Screens/login_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SplashServices{
  void isLogin(BuildContext context)
  {
    final auth=FirebaseAuth.instance;
    final user=auth.currentUser;
    if(user!=null){
      Timer(Duration(seconds: 3),(){
        Navigator.pushReplacement(
            context, MaterialPageRoute(
            builder: (context) => Dashboard()
        )
        );
      }
      );
    }

    else{
      Timer(Duration(seconds: 3),(){
        Navigator.pushReplacement(
            context, MaterialPageRoute(
            builder: (context) => EmailLogin()
        )
        );
      }
      );
    }
  }
}