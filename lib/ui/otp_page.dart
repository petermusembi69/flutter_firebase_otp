import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_firebase_otp/ui/home_page.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OtpPage extends StatefulWidget {
  OtpPage({phoneNumber, Key? key}) : super(key: key);

  @override
  _OtpPageState createState() => _OtpPageState();
}

final _auth = FirebaseAuth.instance;

class _OtpPageState extends State<OtpPage> {
  TextEditingController pinController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        PinCodeTextField(
          controller: pinController,
          isCupertino: true,
          hideCharacter: false,
          highlight: true,
          highlightColor: Colors.blue,
          defaultBorderColor: Colors.black,
          hasTextBorderColor: Colors.black,
          maxLength: 6,
          onTextChanged: (text) {},
          onDone: (text) {
            print('DONE $text');
          },
          pinBoxHeight: 130,
          pinBoxWidth: 100,
          hasUnderline: false,
          wrapAlignment: WrapAlignment.spaceEvenly,
          pinTextStyle: const TextStyle(fontSize: 45),
          pinTextAnimatedSwitcherDuration: const Duration(milliseconds: 300),
          highlightAnimation: true,
          highlightAnimationBeginColor: Colors.black,
          highlightAnimationEndColor: Colors.white12,
          keyboardType: TextInputType.number,
          pinBoxRadius: 5,
        ),
        SizedBox(
          height: 10,
        ),
        MaterialButton(
          onPressed: () {
            pinController.text.length == 6 ? verifyOtp : null;
          },
          color: pinController.text.length == 6 ? Colors.grey : Colors.blue,
          minWidth: double.infinity,
          height: 90,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          child: Text(
            'Submit',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  Future<void> verifyOtp(String smsCode, String verificationId) async {
    try {
      final phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      final user = await _auth.signInWithCredential(phoneAuthCredential);
      if (user.credential!.token != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Invalid Sms Code'),
          ),
        );
      }
    } catch (e) {
      throw Exception('Error happened');
    }
  }

  Future<String> generateOtp(String contact) async {
    try {
      final _completer = Completer<String>();

      await _auth.verifyPhoneNumber(
          phoneNumber: contact,
          codeAutoRetrievalTimeout: (String verId) {},
          codeSent: (String verificationId, [int? forceCodeResend]) {
            _completer.complete(verificationId);
          },
          timeout: const Duration(seconds: 60),
          verificationCompleted: (PhoneAuthCredential phoneAuthCredential) {
            if (Platform.isAndroid && phoneAuthCredential.smsCode != null) {
              verifyOtp(phoneAuthCredential.smsCode!,
                  phoneAuthCredential.verificationId!);
            }
          },
          verificationFailed: (FirebaseAuthException e) {
            if (e.code == 'invalid-phone-number') {
              throw Exception('The provided phone number is not valid');
            } else {
              throw Exception('Exception occured');
            }
          });

      return _completer.future;
    } catch (e) {
      throw Exception('Verfication Error');
    }
  }
}
