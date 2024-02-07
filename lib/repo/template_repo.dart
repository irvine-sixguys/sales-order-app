import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:six_guys/domain/template.dart';

/// A provider that creates a [TemplateRepo].
///
/// should be replaced with a real implementation (main.dart)
final templateRepoProvider = Provider<TemplateRepo>((ref) => throw UnimplementedError());

class TemplateRepo {
  final SharedPreferences _prefs;

  TemplateRepo(this._prefs);

  Future<void> saveTemplateInfo(Template template) async {
    List<String> storedData = _prefs.getStringList(template.name) ?? [];
    List<Template> storedTemplates = [template];

    for (final data in storedData) {
      storedTemplates.add(Template.fromJson(jsonDecode(data)));
    }

    storedTemplates = storedTemplates.take(3).toList();

    await _prefs.setStringList(
      template.name,
      storedTemplates.map((e) => jsonEncode(e.toJson())).toList(),
    );
    await _saveTemplateName(template.name);
  }

  Future<void> _saveTemplateName(String name) async {
    List<String> storedNames = _prefs.getStringList("template_names") ?? [];
    storedNames.add(name);
    await _prefs.setStringList("template_names", storedNames);
  }

  Future<List<String>> getTemplateNames() async {
    return _prefs.getStringList("template_names") ?? [];
  }

  Future<List<Template>> getTemplateInfo(String name) async {
    List<String> storedData = _prefs.getStringList(name) ?? [];
    List<Template> storedTemplates = [];

    for (final data in storedData) {
      storedTemplates.add(Template.fromJson(jsonDecode(data)));
    }

    return storedTemplates;
  }

  Future<void> removeAllTemplates() async {
    await _prefs.remove("template_names");
    final names = await getTemplateNames();
    for (final name in names) {
      await _prefs.remove(name);
    }
  }
}
