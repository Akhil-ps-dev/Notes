import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive_diary_main_project/db/diary_db.dart';
import 'package:hive_diary_main_project/models/models.dart';
import 'package:hive_diary_main_project/screens/AddListScreen/screen_add_list.dart';
import 'package:hive_diary_main_project/screens/EditScreen/edit_list_screen.dart';
import 'package:intl/intl.dart';

class ScreenList extends StatelessWidget {
  const ScreenList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DiarDB.instance.refresh();

    return Scaffold(
        floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              Navigator.of(context).pushNamed(ScreenAddList.routeName);
            },
            label: const Text('Compose'),
            icon: const Icon(Icons.edit)),
        body: ValueListenableBuilder(
            valueListenable: DiarDB.instance.diaryListNotifier,
            builder: (BuildContext ctx, List<DiaryModel> newList, Widget? _) {
              return ListView.separated(
                  itemBuilder: (context, index) {
                    final _value = newList[index];
                    return Slidable(
                      key: Key(_value.id!),
                      startActionPane:
                          ActionPane(motion: ScrollMotion(), children: [
                        SlidableAction(
                          onPressed: (ctx) {
                            DiarDB.instance.deleteDiary(_value.id!);
                          },
                          icon: Icons.delete,
                          backgroundColor: Colors.red,
                          label: 'Delete',
                        )
                      ]),
                      child: Card(
                          elevation: 5,
                          child: ListTile(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => EditListScreen(
                                        date: parseDate(_value.date),
                                        description: _value.description,
                                      )));
                            },
                            leading: const CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.black,
                            ),
                            title: Text(parseDate(_value.date)),
                            subtitle: Text(_value.description),
                          )),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const SizedBox(
                      height: 10,
                    );
                  },
                  itemCount: newList.length);
            }));
  }

  String parseDate(DateTime date) {
    return DateFormat.MMMEd().format(date);
    // return '${date.day} ${date.month}';
  }
}
