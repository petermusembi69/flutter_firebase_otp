part of utils;


GetIt locator = GetIt.instance;

void setUpServiceLocator() {
  // Services
  locator
    ..registerSingleton<HiveServices>(
      HiveServicesImp(),
    )
    ..registerSingleton<OtpServices>(
       OtpServiceImpl(),
    )
    ..registerSingleton<GenerateOtpCubit>(
       GenerateOtpCubit(
        otpService: locator(),
        hiveService: locator(),
      ),
    )
    ..registerSingleton<VerifyOtpCubit>(
      VerifyOtpCubit(
        otpServices: locator(),
        hiveServices: locator(),
      ),
    );
}
