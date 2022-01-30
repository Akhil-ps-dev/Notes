import 'package:flutter/material.dart';
import 'package:hive_diary_main_project/db/diary_db.dart';
import 'package:hive_diary_main_project/models/models.dart';

class ScreenAddList extends StatefulWidget {
  const ScreenAddList({Key? key}) : super(key: key);
  static const routeName = 'add-list';

  @override
  State<ScreenAddList> createState() => _ScreenAddListState();
}

class _ScreenAddListState extends State<ScreenAddList> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  final _descriptionTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        actions: [
          //! Submit

          TextButton(
              onPressed: () {
                addDiary();
              },
              child: const Text(
                'Done',
                style: TextStyle(color: Colors.white),
              ))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            //!Date
            TextButton.icon(
              onPressed: () async {
                final _selectedDateTemp = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now().subtract(const Duration(days: 30)),
                  lastDate: DateTime.now(),
                );

                if (_selectedDateTemp == null) {
                  return;
                } else {
                  setState(() {
                    _selectedDate = _selectedDateTemp;
                  });
                }
              },
              icon: const Icon(Icons.calendar_today_outlined),
              label: Text(_selectedDate == null
                  ? 'Select Date'
                  : _selectedDate!.toString()),
            ),

            //! Time
            // TextButton.icon(
            //   onPressed: () async {
            //     final _selectedTimeTemp = await showTimePicker(
            //         context: context, initialTime: TimeOfDay.now());

            //     if (_selectedTimeTemp == null) {
            //       return;
            //     } else {
            //       setState(() {
            //         _selectedTime = _selectedTimeTemp;
            //       });
            //     }
            //   },
            //   icon: const Icon(Icons.alarm),
            //   label: Text(_selectedTime == null
            //       ? 'Select Time'
            //       : _selectedTime!.format(context)),
            // ),
            const SizedBox(
              height: 20,
            ),
            //!description
            TextFormField(
              minLines: 2,
              maxLines: 10,
              controller: _descriptionTextEditingController,
              decoration: const InputDecoration(hintText: 'Dear Diary...'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> addDiary() async {
    final _description = _descriptionTextEditingController.text;
    if (_description.isEmpty) {
      return;
    }
    if (_selectedDate == null) {
      return;
    }
    // if (_selectedTime == null) {
    //   return;
    // }

    final _model = DiaryModel(
        date: _selectedDate!,
        //time: _selectedTime!,
        description: _description);

    await DiarDB.instance.addDiary(_model);
    Navigator.of(context).pop();
    DiarDB.instance.refresh();
  }
}
