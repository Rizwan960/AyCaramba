class AppApi {
  static const String baseUrl = "https://mystreetsweeper.com/api/";
  static const String registerUrl = "${baseUrl}register";
  static const String loginUrl = "${baseUrl}login";
  static const String loginWithGoogleUrl = "${baseUrl}login/google";
  static const String loginWithAppleleUrl = "${baseUrl}login/apple";
  static const String logoutUrl = "${baseUrl}logout";
  static const String updateUserUrl = "${baseUrl}updateUser";
  static const String resetPasswordUrl = "${baseUrl}change/password";
  static const String forgotPasswordUrl = "${baseUrl}forgotPassword";
  static const String deleteAccount = "${baseUrl}deactivateAccount";
  static const String verifyRefralCode = "${baseUrl}add/refernece";
}
