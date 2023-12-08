import 'package:flutter/material.dart';

class CallYatra extends StatefulWidget {
  const CallYatra({super.key});

  @override
  State<CallYatra> createState() => _CallYatraState();
}

class _CallYatraState extends State<CallYatra> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Card(
        child: Row(
          children: [
            Image.asset(
              "assets/logo.jpg",
              width: MediaQuery.of(context).size.width * 0.3,
              height: 30,
            ),
            Column(
              children: [
                Text("Need Yatra Expert's Help?"),
                Text("Are you interested in planing a Yatra"),
                Text("now? It tasks only 2 minutes !"),
                Row(
                  children: [
                    // OutlinedButton(
                    //   onPressed: () {
                    //     // Your button action goes here
                    //   },
                    //   child: const Row(
                    //     mainAxisSize: MainAxisSize.min,
                    //     children: [
                    //       Icon(
                    //         Icons.star,
                    //         color: Colors.yellow,
                    //       ),
                    //       SizedBox(width: 8),
                    //       // Add some space between icon and text
                    //       Text(
                    //         'Press Me',
                    //         style: TextStyle(
                    //           fontSize: 16,
                    //           fontWeight: FontWeight.bold,
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    OutlinedButton(
                      onPressed: () {
                        // Your button action goes here
                      },
                      style: OutlinedButton.styleFrom(
                        primary: Colors.blue, // Text color
                        side: const BorderSide(color: Colors.blue), // Border color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.star,
                            color: Colors.yellow,
                          ),
                          SizedBox(width: 8), // Add some space between icon and text
                          Text(
                            'Press Me',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
