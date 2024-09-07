import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  final SharedPreferences _sharedPreferences;

  AppPreferences(this._sharedPreferences);

  //this method to save any type data in shared
  Future<bool> setDataToSharedPref({
    required String key,
    required dynamic value,
  }) async {
    print('Item Saved in shared pref ');
    if (value is String) {
      return await _sharedPreferences.setString(key, value);
    } //when data string
    if (value is int)
      return await _sharedPreferences.setInt(key, value); //when data integer
    if (value is bool) {
      return await _sharedPreferences.setBool(key, value);
    } //when data boolean
    if (value is List) {
      return await _sharedPreferences.setStringList(key, value as List<String>);
    } //when data boolean

    return await _sharedPreferences.setDouble(key, value); //when data Double
  }

  //get dynamic data from shared
  Future<dynamic> getDataToSharedPref({
    required String key,
  }) async {
    return _sharedPreferences.get(key);
  }

  //this to remove from shared by key
  Future<bool> deleteDataToSharedPref({
    required String key,
  }) {
    return _sharedPreferences.remove(key);
  }

  //clears all data from shared preferences
  Future<bool> clearDataFromSharedPref() {
    return _sharedPreferences.clear();
  }
}
