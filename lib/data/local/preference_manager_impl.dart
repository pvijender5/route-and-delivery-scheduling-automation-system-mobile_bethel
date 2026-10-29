/// `PreferenceManagerImpl` is a concrete implementation of the `PreferenceManager`
/// interface. It uses `SharedPreferences` to manage local key-value storage.
/// This class provides asynchronous methods to store, retrieve, and remove
/// preferences for various data types such as `String`, `int`, `double`, `bool`,
/// and `List<String>`.

import 'package:bethel_farm/data/local/preference_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferenceManagerImpl implements PreferenceManager {
  final _preference = SharedPreferences.getInstance();

  /// Retrieves a `String` value from preferences, or returns the default value if not found.
  @override
  Future<String> getString(String key, {String defaultValue = ""}) async {
    var preference = await _preference;
    return preference.getString(key) ?? defaultValue;
  }

  /// Stores a `String` value in preferences for the given key.
  @override
  Future<bool> setString(String key, String value) async {
    var preference = await _preference;
    return preference.setString(key, value);
  }

  /// Retrieves an `int` value from preferences, or returns the default value if not found.
  @override
  Future<int> getInt(String key, {int defaultValue = 0}) async {
    var preference = await _preference;
    return preference.getInt(key) ?? defaultValue;
  }

  /// Stores an `int` value in preferences for the given key.
  @override
  Future<bool> setInt(String key, int value) async {
    var preference = await _preference;
    return preference.setInt(key, value);
  }

  /// Retrieves a `double` value from preferences, or returns the default value if not found.
  @override
  Future<double> getDouble(String key, {double defaultValue = 0.0}) async {
    var preference = await _preference;
    return preference.getDouble(key) ?? defaultValue;
  }

  /// Stores a `double` value in preferences for the given key.
  @override
  Future<bool> setDouble(String key, double value) async {
    var preference = await _preference;
    return preference.setDouble(key, value);
  }

  /// Retrieves a `bool` value from preferences, or returns the default value if not found.
  @override
  Future<bool> getBool(String key, {bool defaultValue = false}) async {
    var preference = await _preference;
    return preference.getBool(key) ?? defaultValue;
  }

  /// Stores a `bool` value in preferences for the given key.
  @override
  Future<bool> setBool(String key, bool value) async {
    var preference = await _preference;
    return preference.setBool(key, value);
  }

  /// Retrieves a `List<String>` value from preferences, or returns the default value if not found.
  @override
  Future<List<String>> getStringList(String key, {List<String> defaultValue = const []}) async {
    var preference = await _preference;
    return preference.getStringList(key) ?? defaultValue;
  }

  /// Stores a `List<String>` value in preferences for the given key.
  @override
  Future<bool> setStringList(String key, List<String> value) async {
    var preference = await _preference;
    return preference.setStringList(key, value);
  }

  /// Removes a preference entry for the given key.
  @override
  Future<bool> remove(String key) async {
    var preference = await _preference;
    return preference.remove(key);
  }

  /// Clears all stored preferences.
  @override
  Future<bool> clear() async {
    var preference = await _preference;
    return preference.clear();
  }
}
