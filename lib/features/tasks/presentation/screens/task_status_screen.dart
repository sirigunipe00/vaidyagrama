import 'package:app/features/tasks/model/task_model.dart';
import 'package:app/features/tasks/presentation/screens/ticket_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TaskPeriodBreakdownScreen extends StatefulWidget {

  const TaskPeriodBreakdownScreen({
    super.key,
    required this.label,
    required this.tasks,
    required this.periodKey,
    this.intialStatus,
  });
  final String label;
  final List<Task> tasks;
  final String periodKey;
  final String? intialStatus;

  @override
  State<TaskPeriodBreakdownScreen> createState() => _State();
}

class _State extends State<TaskPeriodBreakdownScreen> {
  String? selectedStatus;
   @override
  void initState() {
    super.initState();
    selectedStatus = widget.intialStatus; 
  }

  List<Task> get filtered => selectedStatus == null
      ? widget.tasks
      : widget.tasks.where((t) => t.status == selectedStatus).toList();

  @override
  Widget build(BuildContext context) {
    final statuses = [
      ('Open', Colors.blue.shade50, Colors.blue.shade800, Colors.blue),
      ('Working', Colors.blue.shade50, Colors.blue.shade800, Colors.blue),
      ('Completed', Colors.blue.shade50, Colors.blue.shade800, Colors.blue),
      ('Overdue', Colors.blue.shade50, Colors.blue.shade800, Colors.blue),
      ('Pending Review', Colors.blue.shade50, Colors.blue.shade800, Colors.blue),
      ('Cancelled', Colors.blue.shade50, Colors.blue.shade800, Colors.blue),
    ];

    return Scaffold(
      backgroundColor: const Color(0xffF5F7FB),
      appBar: AppBar(
        title: Text(widget.label),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [

          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(12),
            child: GridView.count(
              crossAxisCount: 3, shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 8, mainAxisSpacing: 8, childAspectRatio: 2.2,
              children: statuses.map((s) {
                final count = widget.tasks.where((t) => t.status == s.$1).length;
                final isSelected = selectedStatus == s.$1;
                return GestureDetector(
                  onTap: () => setState(() =>
                      selectedStatus = isSelected ? null : s.$1),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    decoration: BoxDecoration(
                      color: isSelected ? s.$4 : s.$2,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected ? s.$4 : Colors.transparent,
                        width: 1.5,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('$count', style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600,
                          color: isSelected ? Colors.white : s.$3)),
                        Text(s.$1, style: TextStyle(
                          fontSize: 10,
                          color: isSelected ? Colors.white70 : s.$3),
                          overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          // Task list
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(selectedStatus ?? 'All tasks',
                    style: const TextStyle(fontWeight: FontWeight.w600)),
                Text('${filtered.length} records',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
              ],
            ),
          ),
          Expanded(
            child: filtered.isEmpty
                ? const Center(child: Text('No tasks found'))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filtered.length,
                    itemBuilder: (_, i) => _taskCard(filtered[i]),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _taskCard(Task task) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(
          builder: (_) => TaskDetailsScreen(task: task))),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('#${task.name}',
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 11)),
                _statusBadge(task.status),
              ],
            ),
            const SizedBox(height: 6),
            Text(task.subject,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Created: ${_fmt(task.creation)}',
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
                Text('Due: ${_fmt(task.expEndDate)}',
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _statusBadge(String status) {
    final colorMap = {
      'Open': Colors.blue, 'Working': Colors.orange,
      'Completed': Colors.green, 'Overdue': Colors.red,
      'Pending Review': Colors.purple, 'Cancelled': Colors.grey,
    };
    final c = colorMap[status] ?? Colors.grey;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
          color: c.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
      child: Text(status,
          style: TextStyle(color: c, fontSize: 11, fontWeight: FontWeight.w600)),
    );
  }

  String _fmt(String? d) {
    if (d == null || d.isEmpty) return 'N/A';
    try { return DateFormat('dd/MM/yyyy').format(DateTime.parse(d)); }
    catch (_) { return 'N/A'; }
  }
}