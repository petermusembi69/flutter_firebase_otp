part of services;

abstract class OtpServices {
  Future<UserCredential> verifyOtp(String smsCode, String verificationId);
  Future<String> generateOtp(String phoneNumber);
}

class OtpServiceImpl extends OtpServices {
  final _auth = FirebaseAuth.instance;

  generateOtp(String phoneNumber) async {
    try {
      final _completer = Completer<String>();

      await _auth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
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

  verifyOtp(String smsCode, String verificationId) async {
    try {
      final phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      final user = await _auth.signInWithCredential(phoneAuthCredential);
      return user;
    } catch (e) {
      throw Exception('Error happened');
    }
  }
}
