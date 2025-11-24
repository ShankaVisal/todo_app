import 'package:flutter/material.dart';

class DetailedTaskCard extends StatelessWidget {
  final String title;
  final String description;
  final DateTime scheduledDate;
  final String scheduleTime;
  final String priority;
  final DateTime createdAt;
  final bool isChecked;

  const DetailedTaskCard({
    super.key,
    required this.title,
    required this.description,
    required this.scheduledDate,
    required this.scheduleTime,
    required this.priority,
    required this.createdAt,
    required this.isChecked,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
        const SizedBox(height: 10),

        Text(description, style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 10),

        Text("Priority: $priority"),
        Text("Scheduled Date: ${scheduledDate.toString().split(' ')[0]}"),
        Text("Scheduled Time: $scheduleTime"),
        Text("Created At: ${createdAt.toString().split('.')[0]}"),

        const SizedBox(height: 10),

        Text(
          isChecked ? "Completed" : "Incomplete",
          style: TextStyle(
            color: isChecked ? Colors.green : Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 20),
      ],
    );
  }
}
