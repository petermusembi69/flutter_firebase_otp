part of 'generate_otp_cubit.dart';

@immutable
abstract class GenerateOtpState {}

class GenerateOtpInitial extends GenerateOtpState {
  GenerateOtpInitial();
}

class GenerateOtpLoading extends GenerateOtpState {
  GenerateOtpLoading();
}

class GenerateOtpLoaded extends GenerateOtpState {
  GenerateOtpLoaded();
}

class GenerateOtpError extends GenerateOtpState {
  final String error;
  GenerateOtpError(this.error);
}
