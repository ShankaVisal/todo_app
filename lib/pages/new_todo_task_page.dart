import 'dart:ui';
import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/providers/to_do_list_provider.dart';

class NewToDoTaskPage extends StatefulWidget {
  final Task? task;
  const NewToDoTaskPage({super.key, this.task});

  @override
  State<NewToDoTaskPage> createState() => _NewToDoTaskPageState();
}

class _NewToDoTaskPageState extends State<NewToDoTaskPage> {
  TextEditingController title = TextEditingController();
  TextEditingController subtitle = TextEditingController();
  TextEditingController scheduleDate = TextEditingController();
  TextEditingController scheduleTime = TextEditingController();
  DateTime? selectDate;
  Time selectTime = Time(hour: 11, minute: 30, second: 20);
  String? selectedPriority;

  @override
  void initState() {
    if (widget.task != null) {
      title.text = widget.task?.title ?? '';
      subtitle.text = widget.task?.description ?? '';
      scheduleDate.text =
          widget.task?.scheduledDate.toString().split(' ').first ?? '';
      scheduleTime.text = widget.task?.scheduleTime ?? '';
      selectedPriority = widget.task?.priority ?? '';
      selectDate = widget.task?.scheduledDate;
    }
    super.initState();
  }

  void onTimeChanged(Time newTime) {
    setState(() {
      selectTime = newTime;
      scheduleTime.text =
          "${selectTime.hour.toString().padLeft(2, '0')} : ${selectTime.minute.toString().padLeft(2, '0')}";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TodoListProvider>(
      builder: (context, todoListProviderModal, child) => Scaffold(
        backgroundColor: Colors.black87, // Dark background for glass effect
        appBar: AppBar(
          title: Text(
            widget.task == null
                ? "New Task"
                : "${widget.task?.title ?? ''} Task",
          ),
          backgroundColor: Colors.black87,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _glassTextField(
                controller: title,
                hint: widget.task == null
                    ? "Task Name"
                    : widget.task?.title ?? '',
                icon: Icons.task_alt,
              ),
              SizedBox(height: 16),
              _glassTextField(
                  controller: subtitle,
                  hint: widget.task == null
                      ? "Description"
                      : widget.task?.description ?? '',
                  icon: Icons.description,
                  isDynamic: true),
              SizedBox(height: 16),
              _glassTextField(
                controller: scheduleDate,
                hint: widget.task == null
                    ? "Date"
                    : widget.task?.scheduledDate.toString().split(' ').first ??
                        '',
                icon: Icons.calendar_today,
                readOnly: true,
                onTap: () async {
                  selectDate = await showDatePicker(
                    context: context,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (selectDate != null && widget.task == null) {
                    scheduleDate.text =
                        "${selectDate!.year}-${selectDate!.month.toString().padLeft(2, '0')}-${selectDate!.day.toString().padLeft(2, '0')}";
                  }
                  if (selectDate != null && widget.task != null) {
                    scheduleDate.text =
                        "${selectDate!.year}-${selectDate!.month.toString().padLeft(2, '0')}-${selectDate!.day.toString().padLeft(2, '0')}";
                  }
                  if (selectDate == null && widget.task != null) {
                    scheduleDate.text = widget.task?.scheduledDate
                            .toString()
                            .split(' ')
                            .first ??
                        '';
                  }
                },
              ),
              SizedBox(height: 16),
              _glassTextField(
                controller: scheduleTime,
                hint: widget.task == null
                    ? "Time"
                    : widget.task?.scheduleTime ?? '',
                icon: Icons.access_time,
                readOnly: true,
                onTap: () {
                  Navigator.of(context).push(
                    showPicker(
                      context: context,
                      value: selectTime,
                      sunrise: TimeOfDay(hour: 6, minute: 0),
                      sunset: TimeOfDay(hour: 18, minute: 0),
                      duskSpanInMinutes: 120,
                      onChange: onTimeChanged,
                    ),
                  );
                },
              ),
              SizedBox(height: 16),
              _glassDropdown(
                value: selectedPriority,
                hint: widget.task == null
                    ? "Select Priority"
                    : widget.task?.priority ?? 'Select Priority',
                items: ["Low", "Medium", "High"],
                onChanged: (val) {
                  setState(() {
                    selectedPriority = val;
                  });
                },
              ),
              SizedBox(height: 32),
              _glassButton(
                text: widget.task == null ? "Submit" : "Update",
                onPressed: () {
                  if (title.text.isNotEmpty &&
                      subtitle.text.isNotEmpty &&
                      selectDate != null &&
                      selectedPriority != null) {
                    if (widget.task != null) {
                      todoListProviderModal.updateTask(
                        widget.task!.id,
                        title.text,
                        subtitle.text,
                        selectDate!,
                        selectTime,
                        selectedPriority!,
                      );
                      Navigator.pop(context);
                      return;
                    } else {
                      todoListProviderModal.addTask(
                        title.text,
                        subtitle.text,
                        selectDate!,
                        selectTime,
                        selectedPriority!,
                      );
                      Navigator.pop(context);
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Glass TextField
  Widget _glassTextField(
      {required TextEditingController controller,
      required String hint,
      required IconData icon,
      bool readOnly = false,
      VoidCallback? onTap,
      minlines = 1,
      bool isDynamic = false}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white
                .withValues(alpha: 0.13, red: 1.0, green: 1.0, blue: 1.0),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
                color: Colors.white
                    .withValues(alpha: 0.2, red: 1, green: 1, blue: 1),
                width: 1.2),
          ),
          child: TextField(
            controller: controller,
            readOnly: readOnly,
            minLines: minlines,
            maxLines: isDynamic ? null : minlines,
            onTap: onTap,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: Colors.white70),
              hintText: hint,
              hintStyle: TextStyle(color: Colors.white60),
              border: InputBorder.none,
            ),
          ),
        ),
      ),
    );
  }

  /// Glass Dropdown
  Widget _glassDropdown({
    required String? value,
    required String hint,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white
                .withValues(alpha: 0.13, red: 1.0, green: 1.0, blue: 1.0),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
                color: Colors.white
                    .withValues(alpha: 0.2, red: 1, green: 1, blue: 1),
                width: 1.2),
          ),
          child: DropdownButton<String>(
            dropdownColor: Colors.black87.withOpacity(0.9),
            value: value,
            hint: Text(
              hint,
              style: TextStyle(color: Colors.white60),
            ),
            icon: Icon(Icons.keyboard_arrow_down, color: Colors.white70),
            underline: SizedBox(),
            isExpanded: true,
            items: items
                .map((e) => DropdownMenuItem(
                      value: e,
                      child: Text(e, style: TextStyle(color: Colors.white)),
                    ))
                .toList(),
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }

  /// Glass Button
  Widget _glassButton({
    required String text,
    required VoidCallback onPressed,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white
                .withValues(alpha: 0.2, red: 1.0, green: 1.0, blue: 1.0),
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 60),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
          onPressed: onPressed,
          child: Text(
            text,
            style: TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
