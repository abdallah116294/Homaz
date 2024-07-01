import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static SharedPreferences? _prefs;

  // static const _storage = FlutterSecureStorage();
  static const _locale = 'locale';
  static const _tokenKey = 'token';
  static const _idKey = 'id';
  static const _ifFirstTimeKey = 'IfFirstTime';
  static const _ifRemember = 'ifRemember';
  static const _ifSocial = 'IfSocial';
  static const _ifGoogle = 'IfGoogle';
  static const _ifApple = 'IfApple';
  static const _latKey = 'lat';
  static const _longKey = 'long';
  static const _countryKey = 'country';
  static const _countryImgKey = 'countryImg';
  static const _theme = 'isDarkMode';
  static const _iPAddressKey = 'iPAddress';
  static const _deviceNameKey = 'deviceName';
  static const _deviceUuidKey = 'deviceUuid';

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<bool> saveIfNotFirstTime() async {
    try {
      return await _prefs?.setBool(_ifFirstTimeKey, false) ?? false;
    } catch (e) {
      return false;
    }
  }

  static bool getIfFirstTime() {
    try {
      return _prefs?.getBool(_ifFirstTimeKey) ?? true;
    } catch (e) {
      return true;
    }
  }

  static Future<bool> saveIfSocial() async {
    try {
      return await _prefs?.setBool(_ifSocial, true) ?? false;
    } catch (e) {
      return false;
    }
  }

  static bool getIfSocial() {
    try {
      return _prefs?.getBool(_ifSocial) ?? false;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> removeIfSocial() async {
    try {
      return await _prefs?.remove(_ifSocial) ?? false;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> saveTheme(bool isDarkMode) async {
    try {
      return await _prefs?.setBool(_theme, isDarkMode) ?? false;
    } catch (e) {
      return false;
    }
  }

  static bool getTheme() {
    try {
      return _prefs?.getBool(_theme) ?? true;
    } catch (e) {
      return true;
    }
  }

  static Future<bool?> saveIfRemember() async {
    try {
      return await _prefs?.setBool(_ifRemember, true);
    } catch (e) {
      return false;
    }
  }

  static bool getIfRemember() {
    try {
      return _prefs?.getBool(_ifRemember) ?? false;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> saveToken(String token) async {
    try {
      return await _prefs?.setString(_tokenKey, token) ?? false;
    } catch (e) {
      return false;
    }
  }

  static String getToken() {
    try {
      return _prefs?.getString(_tokenKey) ?? "";
    } catch (e) {
      return "";
    }
  }

  static Future<bool> removeToken() async {
    try {
      return await _prefs?.remove(_tokenKey) ?? false;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> saveId(String id) async {
    try {
      return await _prefs?.setString(_idKey, id) ?? false;
    } catch (e) {
      return false;
    }
  }

  static String getId() {
    try {
      return _prefs?.getString(_idKey) ?? "";
    } catch (e) {
      return "";
    }
  }

  static void saveLang(String languageCode) {
    _prefs?.setString(_locale, languageCode);
  }

  static String getLang() {
    final cachedLanguageCode = _prefs?.getString(_locale);
    if (cachedLanguageCode != null) {
      return cachedLanguageCode;
    } else {
      return "ar";
    }
  }

  static Future<bool> saveLat(String lat) async {
    try {
      return await _prefs?.setString(_latKey, lat) ?? false;
    } catch (e) {
      return false;
    }
  }

  static String getLat() {
    try {
      return _prefs?.getString(_latKey) ?? "";
    } catch (e) {
      return "";
    }
  }

  static Future<bool> saveLong(String long) async {
    try {
      return await _prefs?.setString(_longKey, long) ?? false;
    } catch (e) {
      return false;
    }
  }

  static String getLong() {
    try {
      return _prefs?.getString(_longKey) ?? "";
    } catch (e) {
      return "";
    }
  }

  static Future<bool> saveCountry(String country) async {
    try {
      return await _prefs?.setString(_countryKey, country) ?? false;
    } catch (e) {
      return false;
    }
  }

  static String getCountry() {
    try {
      return _prefs?.getString(_countryKey) ?? "";
    } catch (e) {
      return "";
    }
  }

  static Future<bool> saveCountryImg(String countryImg) async {
    try {
      return await _prefs?.setString(_countryImgKey, countryImg) ?? false;
    } catch (e) {
      return false;
    }
  }

  static String getCountryImg() {
    try {
      return _prefs?.getString(_countryImgKey) ?? "";
    } catch (e) {
      return "";
    }
  }

  static Future<bool> saveIPAddress(String iPAddress) async {
    try {
      return await _prefs?.setString(_iPAddressKey, iPAddress) ?? false;
    } catch (e) {
      return false;
    }
  }

  static String getIPAddress() {
    try {
      return _prefs?.getString(_iPAddressKey) ?? "";
    } catch (e) {
      return "";
    }
  }

  static Future<bool> saveDeviceName(String deviceName) async {
    try {
      return await _prefs?.setString(_deviceNameKey, deviceName) ?? false;
    } catch (e) {
      return false;
    }
  }

  static String getDeviceName() {
    try {
      return _prefs?.getString(_deviceNameKey) ?? "";
    } catch (e) {
      return "";
    }
  }

  static Future<bool> saveDeviceUuid(String deviceUuid) async {
    try {
      return await _prefs?.setString(_deviceUuidKey, deviceUuid) ?? false;
    } catch (e) {
      return false;
    }
  }

  static String getDeviceUuid() {
    try {
      return _prefs?.getString(_deviceUuidKey) ?? "";
    } catch (e) {
      return "";
    }
  }

  static Future<bool> clear() async {
    try {
      return await _prefs?.clear() ?? false;
    } catch (e) {
      return false;
    }
  }
}
