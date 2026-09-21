import '../data/sample_records.dart';
import '../models/glycemia_record.dart';
import 'glycemia_repository.dart';

class InMemoryGlycemiaRepository implements GlycemiaRepository {
  @override
  Future<List<GlycemiaRecord>> getRecords() async {
    return List<GlycemiaRecord>.of(sampleRecords);
  }
}
