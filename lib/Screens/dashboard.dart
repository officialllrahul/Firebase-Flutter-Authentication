import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebseauthentication/Screens/edit_profile.dart';
import 'package:firebseauthentication/Screens/firebaseStorage.dart';
import 'package:firebseauthentication/Screens/gallery.dart';
import 'package:firebseauthentication/Screens/homescreen.dart';
import 'package:firebseauthentication/Screens/profile.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    homeScreen(),
    FirebaseStorage(),
    Gallery(),
    Profile(),
  ];

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
    Navigator.pushReplacementNamed(context, 'emailLogin');

    Fluttertoast.showToast(
        msg: "Log out",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.blueGrey,
        textColor: Colors.white,
        fontSize: 16.0
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: signOut,
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.black87,
        selectedItemColor: Colors.orange,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_fire_department),
            label: 'Storage',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.image_outlined),
            label: 'Gallery',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
