import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_diary_main_project/db/diary_db.dart';
import 'package:hive_diary_main_project/models/models.dart';
import 'package:hive_diary_main_project/widgets/text_frave.dart';

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
      backgroundColor: const Color(0xffF2F3F7),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xffF2F3F7),
        title: const TextFrave(
            text: 'Add Diary', fontWeight: FontWeight.w500, fontSize: 21),
        elevation: 0,
        leading: InkWell(
            onTap: () => Navigator.pop(context),
            child: const Center(
                child: TextFrave(
              text: 'Cancel',
              fontSize: 15,
              color: Color(0xff0C6CF2),
            ))),
        actions: [
          //! Submit
          TextButton(
            onPressed: () {
              addDiary();
            },
            child: Container(
              alignment: Alignment.center,
              width: 60,
              child: const TextFrave(
                text: 'Save',
                fontSize: 15,
                color: Color(0xff0C6CF2),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              children: [
                //!Date
                TextButton.icon(
                  onPressed: () async {
                    final _selectedDateTemp = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate:
                          DateTime.now().subtract(const Duration(days: 30)),
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
                Container(
                  height: 500,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0)),
                  child: TextFormField(
                    style: GoogleFonts.getFont('Inter'),
                    minLines: 2,
                    maxLines: 10,
                    controller: _descriptionTextEditingController,
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(10.0),
                        hintText: 'Dear Diary...'),
                  ),
                ),
              ],
            ),
          ),
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
