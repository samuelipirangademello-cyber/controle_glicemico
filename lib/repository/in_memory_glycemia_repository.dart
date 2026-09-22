import '../data/sample_records.dart';
import '../models/glycemia_record.dart';
import 'glycemia_repository.dart';

class InMemoryGlycemiaRepository implements GlycemiaRepository {
  final List<GlycemiaRecord> _records = List<GlycemiaRecord>.of(sampleRecords);

  @override
  Future<List<GlycemiaRecord>> getRecords() async {
    return List<GlycemiaRecord>.of(_records);
  }

  @override
  Future<void> addRecord(GlycemiaRecord record) async {
    _records.add(record);
    _records.sort((a, b) => a.dateTime.compareTo(b.dateTime));
  }
}
