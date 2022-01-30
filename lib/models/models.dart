import 'package:hive/hive.dart';
part 'models.g.dart';

@HiveType(typeId: 1)
class DiaryModel {
  @HiveField(0)
  final DateTime date;
  @HiveField(1)
  final String description;
  @HiveField(2)
  String? id;

  DiaryModel(
      {required this.date,
     
      required this.description}) {
    id = DateTime.now().millisecondsSinceEpoch.toString();
  }
}
