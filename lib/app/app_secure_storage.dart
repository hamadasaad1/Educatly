import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AppSecureStorage {
  // Create an instance of FlutterSecureStorage
  final FlutterSecureStorage _secureStorage;

  AppSecureStorage(this._secureStorage);

  // This method saves any type of data securely
  Future<void> setDataToSecureStorage({
    required String key,
    required dynamic value,
  }) async {
    debugPrint('Item Saved in secure storage');

    if (value is String) {
      await _secureStorage.write(key: key, value: value); // Save string
    } else if (value is int) {
      await _secureStorage.write(
          key: key, value: value.toString()); // Save integer as string
    } else if (value is bool) {
      await _secureStorage.write(
          key: key, value: value.toString()); // Save boolean as string
    } else if (value is double) {
      await _secureStorage.write(
          key: key, value: value.toString()); // Save double as string
    } else if (value is List<String>) {
      await _secureStorage.write(
          key: key,
          value: value.join(',')); // Save list as comma-separated string
    }
  }

  // This method retrieves data from secure storage
  Future<dynamic> getDataFromSecureStorage({required String key}) async {
    String? value = await _secureStorage.read(key: key);

    return value; // You'll need to handle the type conversion at retrieval
  }

  // This method deletes data from secure storage by key
  Future<void> deleteDataFromSecureStorage({required String key}) async {
    await _secureStorage.delete(key: key);
  }

  // Clears all data from secure storage
  Future<void> clearSecureStorage() async {
    await _secureStorage.deleteAll();
  }
}
