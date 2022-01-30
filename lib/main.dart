import 'package:flutter/material.dart';
import 'package:hive_diary_main_project/models/models.dart';
import 'package:hive_diary_main_project/screens/AddListScreen/screen_add_list.dart';
import 'package:hive_diary_main_project/screens/ListScreen/screen_list.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized;
  await Hive.initFlutter();

  if (!Hive.isAdapterRegistered(DiaryModelAdapter().typeId)) {
    Hive.registerAdapter( DiaryModelAdapter());
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ScreenList(),
      routes: {ScreenAddList.routeName: (ctx) => const ScreenAddList()},
    );
  }
}
