import 'package:bloc/bloc.dart';
import 'package:flutter_firebase_otp/services/_index.dart';
import 'package:meta/meta.dart';

part 'verify_otp_state.dart';

class VerifyOtpCubit extends Cubit<VerifyOtpState> {
  VerifyOtpCubit({
    required OtpServices otpServices,
    required HiveServices hiveServices,
  }) : super(VerifyOtpInitial()) {
    _otpServices = otpServices;
    _hiveServices = hiveServices;
  }
  late OtpServices _otpServices;
  late HiveServices _hiveServices;

  Future<void> verifyOtp({
    required String smsCode,
  }) async {
    emit(VerifyOtpLoading());
    try {
      final _result = await _otpServices.verifyOtp(
          smsCode, _hiveServices.retrieveVerificationId()!);
      if (_result.user?.uid != null) {
        emit(VerifyOtpLoaded());
      } else {
        emit(VerifyOtpError('Invalid SMS code!'));
      }
    } catch (e) {
      emit(VerifyOtpError('Verification Failed!'));
    }
  }
}
