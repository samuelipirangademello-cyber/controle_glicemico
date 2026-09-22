import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../data/sample_records.dart';
import '../models/glycemia_record.dart';
import 'glycemia_repository.dart';

class LocalGlycemiaRepository implements GlycemiaRepository {
  static const _storageKey = 'glycemia_records_v1';
  SharedPreferences? _preferences;

  Future<SharedPreferences> get _prefs async {
    return _preferences ??= await SharedPreferences.getInstance();
  }

  @override
  Future<List<GlycemiaRecord>> getRecords() async {
    final prefs = await _prefs;
    final raw = prefs.getString(_storageKey);

    if (raw == null) {
      final seeded = List<GlycemiaRecord>.of(sampleRecords);
      await _save(prefs, seeded);
      return seeded;
    }

    final decoded = jsonDecode(raw);
    if (decoded is! List) {
      final seeded = List<GlycemiaRecord>.of(sampleRecords);
      await _save(prefs, seeded);
      return seeded;
    }

    final records = decoded
        .whereType<Map<String, dynamic>>()
        .map(_fromJson)
        .toList()
      ..sort((a, b) => a.dateTime.compareTo(b.dateTime));

    return records;
  }

  @override
  Future<void> addRecord(GlycemiaRecord record) async {
    final prefs = await _prefs;
    final records = await getRecords();
    records.add(record);
    records.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    await _save(prefs, records);
  }

  Future<void> _save(
    SharedPreferences prefs,
    List<GlycemiaRecord> records,
  ) async {
    final encoded = jsonEncode(
      records.map(_toJson).toList(),
    );
    await prefs.setString(_storageKey, encoded);
  }

  Map<String, dynamic> _toJson(GlycemiaRecord record) {
    return {
      'dateTime': record.dateTime.toIso8601String(),
      'glycemia': record.glycemia,
      'shift': record.shift,
      'status': record.status,
    };
  }

  GlycemiaRecord _fromJson(Map<String, dynamic> json) {
    return GlycemiaRecord(
      dateTime: DateTime.parse(json['dateTime'] as String),
      glycemia: (json['glycemia'] as num).toInt(),
      shift: json['shift'] as String,
      status: json['status'] as String,
    );
  }
}
