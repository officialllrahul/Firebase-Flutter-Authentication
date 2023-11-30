import 'package:firebase_core/firebase_core.dart';
import 'package:firebseauthentication/Screens/dashboard.dart';
import 'package:firebseauthentication/Screens/login_page.dart';
import 'package:firebseauthentication/Screens/phone_auth.dart';
import 'package:firebseauthentication/Screens/reset_password.dart';
import 'package:firebseauthentication/Screens/signup_page.dart';
import 'package:firebseauthentication/Screens/splashscreen.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      routes: {
        'emailLogin':(context)=>EmailLogin(),
        'emailSignup':(context)=>EmailSignUp(),
        'phoneAuth':(context)=>PhoneAuth(),
        'dashboard':(context)=>Dashboard(),
        'resetPassword':(context)=>ResetPassword(),
      },
    );
  }
}
