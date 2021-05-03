import 'package:bloc/bloc.dart';
import 'package:flutter_firebase_otp/services/_index.dart';
import 'package:meta/meta.dart';

part 'generate_otp_state.dart';

class GenerateOtpCubit extends Cubit<GenerateOtpState> {
  GenerateOtpCubit({
    required OtpServices otpService,
    required HiveServices hiveService,
  }) : super(GenerateOtpInitial()) {
    _otpService = otpService;
    _hiveService = hiveService;
  }
  late OtpServices _otpService;
  late HiveServices _hiveService;

  Future<void> generateOtp({
    required String phoneNumber,
  }) async {
    emit(GenerateOtpLoading());
    try {
      final verificationId = await _otpService.generateOtp(phoneNumber);
      _hiveService.persistVerficationId(verificationId);

      emit(GenerateOtpLoaded());
    } catch (e) {
      emit(GenerateOtpError('Phone Number Verification Failed!'));
    }
  }
}
