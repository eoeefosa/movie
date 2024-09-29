import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:torihd/cache/setting_persistence.dart';
import 'package:torihd/provider/profile_manager.dart';

class LocalSettingPersistence extends SettingPersistence {
  final Future<SharedPreferences> instanceFuture =
      SharedPreferences.getInstance();
  final storage = const FlutterSecureStorage();

  final themekey = 'theme';
  final tokenkey = 'token';

  @override
  Future<ThemeModeType> gettheme() async {
    final prefs = await instanceFuture;
    final theme = prefs.getString(themekey) ?? 'system';

    return theme == 'system'
        ? ThemeModeType.system
        : theme == 'light'
            ? ThemeModeType.light
            : ThemeModeType.dark;
  }

  @override
  Future<String?> gettoken() async {
    String? value = await storage.read(key: tokenkey);
    return value;
  }

  @override
  Future<void> settheme(ThemeModeType theme) async {
    final prefs = await instanceFuture;

    final currenttheme = theme == ThemeModeType.system
        ? 'system'
        : theme == ThemeModeType.light
            ? 'light'
            : 'dark';

    await prefs.setString(themekey, currenttheme);
  }

  @override
  Future<void> settoken(String token) async {
    await storage.write(key: tokenkey, value: token);
  }
}
