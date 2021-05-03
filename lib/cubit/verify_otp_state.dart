part of 'verify_otp_cubit.dart';

@immutable
abstract class VerifyOtpState {}

class VerifyOtpInitial extends VerifyOtpState {
  VerifyOtpInitial();
}

class VerifyOtpLoading extends VerifyOtpState {
  VerifyOtpLoading();
}

class VerifyOtpLoaded extends VerifyOtpState {
  VerifyOtpLoaded();
}

class VerifyOtpError extends VerifyOtpState {
  final String error;
  VerifyOtpError(this.error);
}
