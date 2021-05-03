part of services;

abstract class HiveServices {
  void clearPref();

  persistVerficationId(String id);
  String? retrieveVerificationId();

  persistPhoneNumber(String number);
  String? retrievePhoneNumber();
}

class HiveServicesImp extends HiveServices {
  persistVerficationId(String id) {}
  String? retrieveVerificationId() {}
  persistPhoneNumber(String id) {}
  String? retrievePhoneNumber() {}
  void clearPref() {}
}
