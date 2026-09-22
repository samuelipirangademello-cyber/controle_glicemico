import 'dart:convert';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import '../models/glycemia_record.dart';

class GoogleSheetsService {
  static final GoogleSheetsService instance = GoogleSheetsService._internal();
  GoogleSheetsService._internal();
  factory GoogleSheetsService() => instance;
  static const String sheetsScope = 'https://www.googleapis.com/auth/spreadsheets';
  final GoogleSignIn _signIn = GoogleSignIn.instance;
  bool _initialized = false;
  GoogleSignInAccount? _user;

  GoogleSignInAccount? get user => _user;

  Future<void> _initialize(String serverClientId) async {
    if (_initialized) return;
    if (serverClientId.trim().isEmpty) {
      throw StateError('Informe o ID do cliente OAuth Web nas Configurações.');
    }
    await _signIn.initialize(serverClientId: serverClientId.trim());
    _initialized = true;
  }

  Future<GoogleSignInAccount> connect({required String serverClientId}) async {
    await _initialize(serverClientId);
    final account = await _signIn.authenticate();
    _user = account;
    await account.authorizationClient.authorizeScopes([sheetsScope]);
    return account;
  }

  Future<void> disconnect() async {
    if (!_initialized) return;
    await _signIn.disconnect();
    _user = null;
  }

  Future<Map<String, String>> _headers() async {
    final account = _user;
    if (account == null) throw StateError('Conecte uma conta Google primeiro.');
    final headers = await account.authorizationClient.authorizationHeaders(
      [sheetsScope],
      promptIfNecessary: true,
    );
    if (headers == null) throw StateError('Não foi possível obter autorização para o Google Sheets.');
    return headers;
  }

  Future<List<GlycemiaRecord>> readRecords({required String spreadsheetId, String range = 'A:E'}) async {
    if (spreadsheetId.trim().isEmpty) throw StateError('Informe o ID da planilha.');
    final uri = Uri.https('sheets.googleapis.com', '/v4/spreadsheets/${Uri.encodeComponent(spreadsheetId.trim())}/values/${Uri.encodeComponent(range)}');
    final response = await http.get(uri, headers: await _headers());
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw StateError('Google Sheets retornou ${response.statusCode}: ${response.body}');
    }
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final values = (body['values'] as List?) ?? const [];
    final records = <GlycemiaRecord>[];
    for (final row in values) {
      if (row is! List) continue;
      if (row.length < 3) continue;
      final date = _parseDate('${row[0]}');
      final time = _parseTime('${row[1]}');
      final glucose = int.tryParse('${row[2]}'.replaceAll(',', '.').split('.').first);
      if (date == null || time == null || glucose == null || glucose <= 0) continue;
      final dt = DateTime(date.year, date.month, date.day, time.hour, time.minute);
      final shift = row.length > 3 && '${row[3]}'.trim().isNotEmpty ? '${row[3]}' : _shift(dt);
      final status = row.length > 4 && '${row[4]}'.trim().isNotEmpty ? '${row[4]}' : _status(glucose);
      records.add(GlycemiaRecord(dateTime: dt, glycemia: glucose, shift: shift, status: status));
    }
    records.sort((a,b) => a.dateTime.compareTo(b.dateTime));
    return records;
  }

  Future<void> appendRecord({required String spreadsheetId, String range = 'A:E', required GlycemiaRecord record}) async {
    final uri = Uri.https('sheets.googleapis.com', '/v4/spreadsheets/${Uri.encodeComponent(spreadsheetId.trim())}/values/${Uri.encodeComponent(range)}:append', {
      'valueInputOption': 'USER_ENTERED',
      'insertDataOption': 'INSERT_ROWS',
    });
    final response = await http.post(uri, headers: {...await _headers(), 'Content-Type': 'application/json'}, body: jsonEncode({
      'values': [[record.dateLabel, record.timeLabel, record.glycemia, record.shift, record.status]],
    }));
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw StateError('Não foi possível gravar na planilha (${response.statusCode}).');
    }
  }

  DateTime? _parseDate(String value) {
    final m = RegExp(r'^(\d{1,2})[/-](\d{1,2})[/-](\d{4})$').firstMatch(value.trim());
    if (m != null) return DateTime.tryParse('${m.group(3)}-${m.group(2)!.padLeft(2,'0')}-${m.group(1)!.padLeft(2,'0')}');
    return DateTime.tryParse(value.trim());
  }
  DateTime? _parseTime(String value) {
    final m = RegExp(r'^(\d{1,2}):(\d{2})').firstMatch(value.trim());
    if (m == null) return null;
    return DateTime(2000,1,1,int.parse(m.group(1)!),int.parse(m.group(2)!));
  }
  String _shift(DateTime d) => d.hour < 12 ? 'Manhã' : (d.hour < 18 ? 'Tarde' : 'Noite');
  String _status(int v) => v < 70 ? 'Hipoglicemia' : (v <= 140 ? 'Normal' : (v <= 180 ? 'Atenção' : 'Hiperglicemia'));
}
