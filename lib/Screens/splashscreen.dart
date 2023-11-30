import 'package:firebseauthentication/Screens/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'navigate.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SplashServices splashScreen=SplashServices(); //
  @override
  void initState() {
    super.initState();
    splashScreen.isLogin(context);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          color:Colors.black,
          child: SizedBox(
            height: 50,
            width: 50,
            child: Image.asset("assets/logo.jpg",width: 50,height: 50),
          ),
        ),
      ),
    );
  }
}
