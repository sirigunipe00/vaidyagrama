// task_dashboard_screen.dart
import 'package:app/core/core.dart';
import 'package:app/features/auth/model/logged_in_user.dart';
import 'package:flutter/material.dart';
import 'package:app/features/tasks/data/api_service.dart';
import 'package:app/features/tasks/model/task_model.dart';
import 'package:app/features/tasks/presentation/screens/task_status_screen.dart';
import 'package:app/features/tasks/presentation/screens/ticket_creation_screen.dart';

class TaskDashboardScreen extends StatefulWidget {
  const TaskDashboardScreen({super.key});

  @override
  State<TaskDashboardScreen> createState() => _TaskDashboardScreenState();
}

class _TaskDashboardScreenState extends State<TaskDashboardScreen> {
  List<Task> tasks = [];
  bool loading = true;
  LoggedInUser? currentUser;

  @override
  void initState() {
    super.initState();
    _loadTasks();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = context.user;
    setState(() {
      currentUser = user;
    });
  }

  Future<void> _loadTasks() async {
    final fetched = await TaskApiService.fetchTasks();
    if (!mounted) return;
    setState(() {
      tasks = fetched;
      loading = false;
    });
  }

bool get _canCreateTask => currentUser != null;

  List<Task> _filterByPeriod(String period, List<Task> source) {
    final now = DateTime.now();
    return source.where((t) {
      if (t.creation.isEmpty) return false;
      final date = DateTime.tryParse(t.creation);
      if (date == null) return false;
      if (period == 'today') {
        return date.year == now.year &&
            date.month == now.month &&
            date.day == now.day;
      } else if (period == 'week') {
        final start = now.subtract(Duration(days: now.weekday - 1));
        final end = start.add(const Duration(days: 6));
        return date.isAfter(start.subtract(const Duration(days: 1))) &&
            date.isBefore(end.add(const Duration(days: 1)));
      } else {
        // month
        return date.year == now.year && date.month == now.month;
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FB),
      appBar: AppBar(
        title: const Text('Task Dashboard'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : _dashboardBody(tasks),
      floatingActionButton: _canCreateTask
          ? FloatingActionButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => CreateTaskScreen()),
                );
                _loadTasks();
              },
              backgroundColor: Colors.blue,
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  Widget _dashboardBody(List<Task> allTasks) {
    final todayTasks = _filterByPeriod('today', allTasks);
    final weekTasks = _filterByPeriod('week', allTasks);
    final monthTasks = _filterByPeriod('month', allTasks);

    return RefreshIndicator(
      onRefresh: _loadTasks,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _sectionLabel('Summary'),
          Row(
            children: [
              _periodCard(context, 'Today', todayTasks, 'today'),
              const SizedBox(width: 8),
              _periodCard(context, 'This Week', weekTasks, 'week'),
              const SizedBox(width: 8),
              _periodCard(context, 'This Month', monthTasks, 'month'),
            ],
          ),
          const SizedBox(height: 40),
          _sectionLabel('All Tasks by Status'),
          const SizedBox(height: 10),
          _statusGrid(allTasks),
        ],
      ),
    );
  }

  Widget _sectionLabel(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Text(
          text.toUpperCase(),
          style: TextStyle(
            fontSize: 20,
            color: Colors.grey.shade600,
            letterSpacing: 0.8,
            fontWeight: FontWeight.w600,
          ),
        ),
      );

  Widget _periodCard(
    BuildContext context,
    String label,
    List<Task> periodTasks,
    String periodKey,
  ) {
    return Expanded(
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => TaskPeriodBreakdownScreen(
              label: label,
              tasks: periodTasks,
              periodKey: periodKey,
            ),
          ),
        ).then((_) => _loadTasks()),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(color: Colors.black12, blurRadius: 4),
            ],
          ),
          child: Column(
            children: [
              Text(
                '${periodTasks.length}',
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 4),
              const Icon(Icons.chevron_right, size: 15, color: Colors.blue),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statusGrid(List<Task> all) {
    const statuses = [
      'Open',
      'Working',
      'Completed',
      'Overdue',
      'Pending Review',
      'Cancelled',
    ];

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      childAspectRatio: 2.0,
      children: statuses.map((status) {
        final count = all.where((t) => t.status == status).length;
        return GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => TaskPeriodBreakdownScreen(
                label: 'All Tasks',
                tasks: all,
                periodKey: 'all',
                intialStatus: status,
              ),
            ),
          ).then((_) => _loadTasks()),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 3),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$count',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue.shade800,
                  ),
                ),
                Text(
                  status,
                  style: TextStyle(fontSize: 13, color: Colors.blue.shade800),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}