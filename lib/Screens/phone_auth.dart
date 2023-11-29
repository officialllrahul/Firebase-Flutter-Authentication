import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebseauthentication/Screens/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class PhoneAuth extends StatefulWidget {
  const PhoneAuth({Key? key}) : super(key: key);

  @override
  _PhoneAuthState createState() => _PhoneAuthState();
}

class _PhoneAuthState extends State<PhoneAuth> {
  late PhoneNumber _phoneNumber;
  late String _verificationCode;
  late String _verificationId;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Function to initiate phone authentication
  Future<void> _verifyPhoneNumber() async {
    await _auth.verifyPhoneNumber(
      phoneNumber: _phoneNumber.phoneNumber!,
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Auto-retrieve the SMS code on Android devices
        await _auth.signInWithCredential(credential);
        Fluttertoast.showToast(
            msg: "Verification completed automatically: ${_auth.currentUser!.uid}",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.blueGrey,
            textColor: Colors.white,
            fontSize: 16.0
        );
      },
      verificationFailed: (FirebaseAuthException e) {
        Fluttertoast.showToast(
            msg: "Verification failed: $e",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.blueGrey,
            textColor: Colors.white,
            fontSize: 16.0
        );
      },
      codeSent: (String verificationId, int? resendToken) {
        Fluttertoast.showToast(
            msg: "Code sent to ${_phoneNumber.phoneNumber}",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.blueGrey,
            textColor: Colors.white,
            fontSize: 16.0
        );
        // Save the verification ID
        _verificationId = verificationId;
        // Show the bottom sheet for manual verification
        _showOtpVerificationBottomSheet();
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        Fluttertoast.showToast(
            msg: "Code auto-retrieval timed out",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.blueGrey,
            textColor: Colors.white,
            fontSize: 16.0
        );
      },
    );
  }

  // Function to manually verify the SMS code
  Future<void> _verifySmsCode() async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: _verificationCode,
      );
      await _auth.signInWithCredential(credential);
      Fluttertoast.showToast(
          msg: "Verification successful: ${_auth.currentUser!.uid}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.blueGrey,
          textColor: Colors.white,
          fontSize: 16.0
      );
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const Dashboard()));
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Verification failed: $e",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.blueGrey,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }
  }

  // Function to show the OTP verification bottom sheet
  void _showOtpVerificationBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 400,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  onChanged: (value) => _verificationCode = value,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Verification Code'),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: _verifySmsCode,
                  child: const Text('Verify OTP'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _phoneNumber = PhoneNumber(isoCode: 'IN'); // Set default country code
    _verificationCode = '';
    _verificationId = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Phone Authentication'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InternationalPhoneNumberInput(
              onInputChanged: (PhoneNumber number) {
                _phoneNumber = number;
              },
              selectorConfig: const SelectorConfig(
                selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _verifyPhoneNumber,
              child: const Text('Send OTP'),
            ),
          ],
        ),
      ),
    );
  }
}
