import 'package:app/core/ext/context_ext.dart';
import 'package:app/features/auth/model/logged_in_user.dart';
import 'package:app/features/tasks/data/api_service.dart';
import 'package:app/features/tasks/model/task_model.dart';
import 'package:app/features/tasks/presentation/screens/ticket_creation_screen.dart';
import 'package:app/features/tasks/presentation/screens/ticket_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  List<Task> tasks = [];
  String selectedFilter = 'All';
  bool isSearching = false;
  String searchQuery = '';
  TextEditingController searchController = TextEditingController();
  LoggedInUser? currentUser;
  List<String> allowedUsers = [
    'anweshega',
    'krishnasaraf',
    'ERAJU',
    'udaykiran'
  ];

  @override
  void initState() {
    super.initState();
    loadTasks();
    loadUser();
  }

  Future<void> loadUser() async {
    final user = context.user;

    setState(() {
      currentUser = user;
    });
  }

  Future<void> loadTasks() async {
    tasks = await TaskApiService.fetchTasks();
    if(!mounted) return ;
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {

    DateTime now = DateTime.now();

int todayCount = tasks.where((t) {
  if (t.creation.isEmpty) return false;
  DateTime date = DateTime.parse(t.creation);
  return date.year == now.year &&
         date.month == now.month &&
         date.day == now.day;
}).length;

int weekCount = tasks.where((t) {
  if (t.creation.isEmpty) return false;
  DateTime date = DateTime.parse(t.creation);

  DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
  DateTime endOfWeek = startOfWeek.add (const Duration(days: 6));

  return date.isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
         date.isBefore(endOfWeek.add(const Duration(days: 1)));
}).length;
    int allCount = tasks.length;
    int openCount = tasks.where((t) => t.status == 'Open').length;
    int inProgressCount = tasks.where((t) => t.status == 'Working').length;
    int completedCount = tasks.where((t) => t.status == 'Completed').length;
    int overdueCount = tasks.where((t) => t.status == 'Overdue').length;
    int cancelledCount = tasks.where((t) => t.status == 'Cancelled').length;
    int pendingReviewCount = tasks.where((t) => t.status == 'Pending Review').length;

    return Scaffold(
   
      backgroundColor: const Color(0xffF5F7FB),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  currentUser != null
                      ? Text(
                          currentUser!.name,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        )
                      : const Text(''),
                ],
              ),
              const SizedBox(height: 8),
              const SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    buildFilterChip('All', allCount),
                    buildFilterChip('Today', todayCount),
                    buildFilterChip('This Week', weekCount),
                    buildFilterChip('Open', openCount),
                    buildFilterChip('In Progress', inProgressCount),
                    buildFilterChip('Completed', completedCount),
                    buildFilterChip('Overdue', overdueCount),
                    buildFilterChip('Cancelled', cancelledCount),
                    buildFilterChip('Pending Review', pendingReviewCount),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: loadTasks,
                  child: filteredTasks.isEmpty
                      ? const Center(child: Text('No tasks available'))
                      : ListView.builder(
                          itemCount: filteredTasks.length,
                          itemBuilder: (_, index) {
                            final task = filteredTasks[index];

                            return GestureDetector(
                                onTap: () async {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          TaskDetailsScreen(task: task),
                                    ),
                                  ).then((value) {
                                    loadTasks();
                                  });
                                },
                                child: buildTaskCard(filteredTasks[index]));
                          },
                        ),
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton:
          currentUser != null && allowedUsers.contains(currentUser!.username)
              ? FloatingActionButton(
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const CreateTaskScreen(),
                      ),
                    );
                    loadTasks();
                  },
                  backgroundColor: Colors.blue,
                  child: const Icon(Icons.add),
                )
              : null,
    );
  }

  List get filteredTasks {
    List temp = tasks;
    DateTime now = DateTime.now();

  if (selectedFilter == 'Today') {
    temp = temp.where((t) {
      if (t.creation == null) return false;
      DateTime date = DateTime.parse(t.creation!);

      return date.year == now.year &&
             date.month == now.month &&
             date.day == now.day;
    }).toList();

  } else if (selectedFilter == 'This Week') {
    DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    DateTime endOfWeek = startOfWeek.add(const Duration(days: 6));

    temp = temp.where((t) {
      if (t.creation.isEmpty) return false;
      DateTime date = DateTime.parse(t.creation);

      return date.isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
             date.isBefore(endOfWeek.add(const Duration(days: 1)));
    }).toList();

  } 
    else if (selectedFilter == 'Open') {
      temp = temp.where((t) => t.status == 'Open').toList();
    } else if (selectedFilter == 'In Progress') {
      temp = temp.where((t) => t.status == 'Working').toList();
    } else if (selectedFilter == 'Completed') {
      temp = temp.where((t) => t.status == 'Completed').toList();
    } else if (selectedFilter == 'Overdue') {
      temp = temp.where((t) => t.status == 'Overdue').toList();
    } else if (selectedFilter == 'Cancelled') {
      temp = temp.where((t) => t.status == 'Cancelled').toList();
    } else if (selectedFilter == 'Pending Review') {
      temp = temp.where((t) => t.status == 'Pending Review').toList();
    }
    if (searchQuery.isNotEmpty) {
      temp = temp.where((t) {
        final subject = (t.subject ?? '').toString().toLowerCase();
        return subject.contains(searchQuery.toLowerCase());
      }).toList();
    }

    return temp;
  }

  Color getPriorityColor(String priority) {
    switch (priority) {
      case 'High':
        return Colors.red.shade100;
      case 'Medium':
        return Colors.orange.shade100;
      default:
        return Colors.grey.shade200;
    }
  }

  Widget buildFilterChip(String title, int count) {
    final isSelected = selectedFilter == title;

    return GestureDetector(
      onTap: () {
        setState(() => selectedFilter = title);
      },
      child: Container(
        margin: const EdgeInsets.only(right: 4),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          '$title ($count) ',
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }

  Widget buildTaskCard(Task task) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
           BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '#${task.name}',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: getPriorityColor(task.priority),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  task.priority,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
          const SizedBox(height: 8),
          Text(
            task.subject,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Creation: ${formatDate(task.creation)}',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
              Text(
                task.status,
                style: TextStyle(
                  color: getStatusColor(task.status),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Text(
            'DueDate: ${formatDate(task.expEndDate)}',
            style: TextStyle(
              fontStyle: FontStyle.italic,
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  String formatDate(String? date) {
    if (date == null || date.isEmpty) return 'N/A';
    try {
      final parsedDate = DateTime.parse(date);
      return DateFormat('dd/MM/yyyy').format(parsedDate);
    } catch (e) {
      return 'N/A';
    }
  }

  Color getStatusColor(String status) {
    switch (status) {
      case 'Open':
        return Colors.blue;
      case 'Working':
        return Colors.orange;
      case 'Pending Review':
        return Colors.purple;
      case 'Overdue':
        return Colors.red;
      case 'Completed':
        return Colors.green;
      case 'Cancelled':
        return Colors.grey;
      default:
        return Colors.black;
    }
  }
}
