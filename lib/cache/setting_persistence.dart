import 'package:torihd/provider/profile_manager.dart';

abstract class SettingPersistence {
  Future<String?> gettoken();
  Future<void> settoken(String token);
  Future<ThemeModeType> gettheme();
  Future<void> settheme(ThemeModeType theme);
}
