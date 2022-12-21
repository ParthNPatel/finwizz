import 'package:get_storage/get_storage.dart';

class GetStorageServices {
  static GetStorage getStorage = GetStorage();

  static setUserName({required String username}) {
    getStorage.write('username', username);
  }

  static getUserName() {
    return getStorage.read('username');
  }

  static setUserLoggedIn() {
    getStorage.write('isUserLoggedIn', true);
  }

  static getUserLoggedInStatus() {
    return getStorage.read('isUserLoggedIn');
  }

  /// Set FCM
  static setFcm(String fcm) async {
    await getStorage.write('fcm', fcm);
  }

  static getFcm() {
    return getStorage.read('fcm');
  }

  /// Set Barrier Token

  static setBarrierToken(token) async {
    await getStorage.write('barrierToken', token);
  }

  static getBarrierToken() {
    return getStorage.read('barrierToken');
  }

  /// user uid
  static setToken(String userUid) {
    getStorage.write('token', userUid);
  }

  static getToken() {
    return getStorage.read('token');
  }

  /// profile image
  static setProfileImageValue(String LoginValue) {
    getStorage.write('setProfileImage', LoginValue);
  }

  static getProfileImageValue() {
    return getStorage.read('setProfileImage');
  }

  /// name image
  static setNameValue(String LoginValue) {
    getStorage.write('setNameValue', LoginValue);
  }

  static getNameValue() {
    return getStorage.read('setNameValue');
  }

  /// full name
  static setFullNameValue(String LoginValue) {
    getStorage.write('setFullNameValue', LoginValue);
  }

  static getFullNameValue() {
    return getStorage.read('setFullNameValue');
  }

  /// email
  static setEmail(String LoginValue) {
    getStorage.write('setEmailValue', LoginValue);
  }

  static getEmail() {
    return getStorage.read('setEmailValue');
  }

  /// mobile
  static setMobile(String LoginValue) {
    getStorage.write('setMobile', LoginValue);
  }

  static getMobile() {
    return getStorage.read('setMobile');
  }

  /// is Email or phone
  static setIsEmailOrPhone(bool LoginValue) {
    getStorage.write('setIsEmailOrPhone', LoginValue);
  }

  static getIsEmailOrPhone() {
    return getStorage.read('setIsEmailOrPhone');
  }

  static setNewsAlerts(bool newsAlerts) {
    getStorage.write('setNewsAlerts', newsAlerts);
  }

  static getNewsAlerts() {
    return getStorage.read('setNewsAlerts');
  }

  static setPortfolioAlerts(bool portfolioAlerts) {
    getStorage.write('setPortfolioAlerts', portfolioAlerts);
  }

  static getPortfolioAlerts() {
    return getStorage.read('setPortfolioAlerts');
  }

  static setReferralCode(String referralCode) {
    getStorage.write('referralCode', referralCode);
  }

  static getReferralCode() {
    return getStorage.read('referralCode');
  }

  static setReferralCount(int referralCount) {
    getStorage.write('referralCount', referralCount);
  }

  static getReferralCount() {
    return getStorage.read('referralCount');
  }

  static logOut() {
    getStorage.remove('barrierToken');
    getStorage.remove('referralCode');
    getStorage.remove('referralCount');
    getStorage.remove('setIsEmailOrPhone');
    getStorage.remove('setMobile');
    getStorage.remove('setEmailValue');
    getStorage.remove('setNameValue');
    getStorage.remove('setProfileImage');
    getStorage.remove('username');
    getStorage.remove('isUserLoggedIn');
    getStorage.remove('setFullNameValue');
    getStorage.remove('setNewsAlerts');
    getStorage.remove('setPortfolioAlerts');
  }
}
