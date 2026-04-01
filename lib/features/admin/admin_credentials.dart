/// Admin credentials – isolated here for easy future upgrade.
class AdminCredentials {
  AdminCredentials._();

  static const String adminId = 'adminaci';
  static const String adminPassword = '93611';

  static bool verify(String id, String password) =>
      id.trim() == adminId && password.trim() == adminPassword;
}
