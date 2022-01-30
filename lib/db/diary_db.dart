import 'package:flutter/foundation.dart';
import 'package:hive_diary_main_project/models/models.dart';
import 'package:hive_flutter/hive_flutter.dart';

const DIARY_DB_NAME = 'diary-db';

abstract class DiaryDbFunctions {
  Future<void> addDiary(DiaryModel obj);

  Future<List<DiaryModel>> getAllDatas();
  Future<void> deleteDiary(String id);
}

class DiarDB implements DiaryDbFunctions {
  DiarDB._internal();

  static DiarDB instance = DiarDB._internal();

  factory DiarDB() {
    return instance;
  }

  ValueNotifier<List<DiaryModel>> diaryListNotifier = ValueNotifier([]);

  @override
  Future<void> addDiary(DiaryModel obj) async {
    final _db = await Hive.openBox<DiaryModel>(DIARY_DB_NAME);
    await _db.put(obj.id, obj);
  }

  Future<void> refresh() async {
    final _list = await getAllDatas();
    _list.sort((first, second) => second.date.compareTo(first.date));
    diaryListNotifier.value.clear();
    diaryListNotifier.value.addAll(_list);
    diaryListNotifier.notifyListeners();
  }

  @override
  Future<List<DiaryModel>> getAllDatas() async {
    final _db = await Hive.openBox<DiaryModel>(DIARY_DB_NAME);
    return _db.values.toList();
  }

  @override
  Future<void> deleteDiary(String id) async {
    final _db = await Hive.openBox<DiaryModel>(DIARY_DB_NAME);
    await _db.delete(id);
    refresh();
  }
}
