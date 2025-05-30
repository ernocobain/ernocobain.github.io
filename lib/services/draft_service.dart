import 'package:shared_preferences/shared_preferences.dart';

class DraftService {
  static const _titleKey = 'draft_title';
  static const _contentKey = 'draft_content';

  static Future<void> saveDraft({
    required String title,
    required String content,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_titleKey, title);
    await prefs.setString(_contentKey, content);
  }

  static Future<Map<String, String>> loadDraft() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'title': prefs.getString(_titleKey) ?? '',
      'content': prefs.getString(_contentKey) ?? '',
    };
  }

  static Future<void> clearDraft() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_titleKey);
    await prefs.remove(_contentKey);
  }
}
