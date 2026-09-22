import '../models/glycemia_record.dart';

abstract interface class GlycemiaRepository {
  Future<List<GlycemiaRecord>> getRecords();
  Future<void> addRecord(GlycemiaRecord record);
}
