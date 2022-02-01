import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive_diary_main_project/db/diary_db.dart';
import 'package:hive_diary_main_project/models/models.dart';
import 'package:hive_diary_main_project/screens/AddListScreen/screen_add_list.dart';
import 'package:hive_diary_main_project/screens/EditScreen/edit_list_screen.dart';
import 'package:hive_diary_main_project/widgets/text_frave.dart';
import 'package:intl/intl.dart';

class ScreenList extends StatelessWidget {
  const ScreenList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DiarDB.instance.refresh();
    final size = MediaQuery.of(context).size;

    return Scaffold(
        backgroundColor: const Color(0xffF2F3F7),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const TextFrave(
              text: 'Personal Diary ',
              fontWeight: FontWeight.w500,
              fontSize: 21),
          centerTitle: true,
          backgroundColor: const Color(0xffF2F3F7),
          elevation: 0,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pushNamed(ScreenAddList.routeName);
          },
          child: const Icon(Icons.edit_outlined),
          backgroundColor: const Color(0xff1977F3),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: ValueListenableBuilder(
            valueListenable: DiarDB.instance.diaryListNotifier,
            builder: (BuildContext ctx, List<DiaryModel> newList, Widget? _) {
              if (newList.isEmpty) {
                return const Center(
                  child: TextFrave(text: 'Empty List..', color: Colors.blue),
                );
              }

              return ListView.separated(
                  itemBuilder: (context, index) {
                    final _value = newList[index];
                    return Slidable(
                      key: Key(_value.id!),
                      startActionPane:
                          ActionPane(motion: const ScrollMotion(), children: [
                        SlidableAction(
                          onPressed: (ctx) {
                            DiarDB.instance.deleteDiary(_value.id!);
                          },
                          icon: Icons.delete,
                          backgroundColor: Colors.red,
                          label: 'Delete',
                        ),
                      ]),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
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
                        ),
                      ),
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
