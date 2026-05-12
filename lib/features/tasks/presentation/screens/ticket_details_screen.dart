import 'dart:io';

import 'package:app/core/core.dart';
import 'package:app/features/auth/model/logged_in_user.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:app/features/tasks/data/api_service.dart';
import 'package:app/features/tasks/model/attachment_model.dart';
import 'package:app/features/tasks/model/comment_data.dart';
import 'package:app/features/tasks/model/task_model.dart';
import 'package:app/features/tasks/model/user_model.dart';
import 'package:app/features/tasks/presentation/widgets/activity_section.dart';
import 'package:app/features/tasks/presentation/screens/full_screen_image.dart';

class TaskDetailsScreen extends StatefulWidget {

  const TaskDetailsScreen({super.key, required this.task});
  final Task task;

  @override
  State<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  List<String> assignees = [];
  bool isLoadingAssignees = true;
  List<TaskAttachments> attachments = [];
  bool isLoadingAttachments = true;
  late String status;
  List<CommentModel> activities = [];
  bool isLoadingComments = true;
  bool isLoading = false;
  List<UserModel> users = [];
  DateTime? dueDate;
  bool canEdit = false;
  LoggedInUser? currentUser;
  late String previousStatus;
  TextEditingController commentController = TextEditingController();
  bool isSending = false;
  bool isLocked = false;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    loadAssignees();
    loadAttachments();
    loadComments();
    loadUser();
    loadUsers();
    dueDate = widget.task.expEndDate != null
        ? DateTime.parse(widget.task.expEndDate!)
        : null;
    status = widget.task.status;
    previousStatus = widget.task.status;
    if (status == 'Completed' || status == 'Cancelled') {
      isLocked = true;
    }
  }

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('#${widget.task.name}'),
      ),
      backgroundColor: const Color(0xffF5F7FB),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 1),
              buildTitle(),
              const SizedBox(height: 12),
              buildActions(),
              const SizedBox(height: 16),
              buildStatusStepper(),
              const SizedBox(height: 20),
              buildDescription(),
              const SizedBox(height: 6),
              buildAttachmentsSection(),
              const SizedBox(height: 10),
              buildAssignmentDetails(),
              const SizedBox(height: 20),
              buildActivitySection(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // ── Permission logic (any logged-in user) ─────────────────────────────────

  bool get canEditStatus {
    if (isLocked) return false;
    if (currentUser == null) return false;
    const activeStatuses = ['Open', 'Working', 'Pending Review', 'Overdue'];
    return activeStatuses.contains(status);
  }

  List<String> getAllowedStatuses() {
    if (isLocked) return [];
    if (currentUser == null) return [];

    switch (status) {
      case 'Open':
        return ['Working', 'Pending Review'];
      case 'Working':
        return ['Pending Review', 'Completed', 'Cancelled'];
      case 'Pending Review':
        return ['Working', 'Completed'];
      case 'Overdue':
        return ['Working', 'Pending Review', 'Completed', 'Cancelled'];
      default:
        return [];
    }
  }

  bool checkEditPermission() {
    return currentUser != null;
  }

  // ── Data loading ──────────────────────────────────────────────────────────

  Future<void> loadUser() async {
    final user = context.user;
    if (!mounted) return;
    setState(() {
      currentUser = user;
      canEdit = checkEditPermission();
    });
  }

  Future<void> loadUsers() async {
    final result = await TaskApiService.fetchUsers();
    if (!mounted) return;
    setState(() {
      users = result;
    });
  }

  Future<void> loadAssignees() async {
    try {
      final data = await TaskApiService.fetchAssignees(widget.task.name);
      if (!mounted) return;
      setState(() {
        assignees = data;
        isLoadingAssignees = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => isLoadingAssignees = false);
    }
  }

  Future<void> loadAttachments() async {
    try {
      final data = await TaskApiService.fetchAttachments(widget.task.name);
      if (!mounted) return;
      setState(() {
        attachments = data;
        isLoadingAttachments = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => isLoadingAttachments = false);
    }
  }

  Future<void> loadComments() async {
    try {
      final data = await TaskApiService.fetchComments(widget.task.name);
      if (!mounted) return;
      setState(() {
        activities = data;
        isLoadingComments = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => isLoadingComments = false);
    }
  }

  // ── Status update ─────────────────────────────────────────────────────────

  Future<void> updateStatus(String newStatus) async {
    if (!mounted) return;
    setState(() => isLoading = true);

    try {
      await TaskApiService.updateTaskStatus(
        taskName: widget.task.name,
        status: newStatus,
      );

      if (!mounted) return;
      setState(() {
        previousStatus = status;
        status = newStatus;
        isLoading = false;
        if (newStatus == 'Completed' || newStatus == 'Cancelled') {
          isLocked = true;
        }
      });

      if (!mounted) return;
      await showDialog(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Success'),
          content: Text('Status updated to $newStatus'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('OK'),
            ),
          ],
        ),
      );

      if (!mounted) return;
      await refreshTask();
    } catch (e) {
      if (!mounted) return;
      setState(() => isLoading = false);
      showDialog(
        context: context,
        builder: (_) => const AlertDialog(
          title: Text('Error'),
          content: Text('Failed to update status'),
        ),
      );
    }
  }

  bool isOverdue() {
    if (dueDate == null) return false;
    if (isLocked || status == 'Pending Review') return false;
    final today = DateTime.now();
    return dueDate!.isBefore(DateTime(today.year, today.month, today.day));
  }

  Future<void> refreshTask() async {
    try {
      if (!mounted) return;
      setState(() => isLoading = true);

      final updatedTask = await TaskApiService.getTaskById(widget.task.name);

      if (!mounted) return;
      setState(() {
        status = updatedTask.status;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => isLoading = false);
    }
  }

  // ── UI widgets ────────────────────────────────────────────────────────────

  Widget buildTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  widget.task.name,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.red.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    widget.task.priority.toUpperCase(),
                    style: const TextStyle(fontSize: 10, color: Colors.red),
                  ),
                ),
               
              ],
            ),
             Column(
               children: [
                 Text(
                  currentUser?.fullName ?? '',
                  style: const TextStyle(fontSize: 14, color: Colors.black),
                             ),
                              Text(
              widget.task.owner,
              style: const TextStyle(fontSize: 14, color: Colors.black),
            ),
               ],
             ),
           
          ],
        ),
        const SizedBox(height: 8),
        Text(
          widget.task.subject,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget buildActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: currentUser != null && !isLocked && status != 'Cancelled'
                  ? pickDueDate
                  : null,
              child: Container(
                height: 36,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF2F3FF),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFD6D9F0)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 14),
                    const SizedBox(width: 6),
                    Text(
                      dueDate != null
                          ? '${dueDate!.day}/${dueDate!.month}/${dueDate!.year}'
                          : 'Due Date',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            if (isOverdue())
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'OVERDUE',
                  style: TextStyle(color: Colors.white, fontSize: 10),
                ),
              ),
          ],
        ),
        ElevatedButton(
          onPressed: canEditStatus ? openStatusSelector : null,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            minimumSize: const Size(0, 36),
          ),
          child: Text(
            status.toUpperCase(),
            style: const TextStyle(fontSize: 12),
          ),
        ),
      ],
    );
  }

  void openStatusSelector() {
    final statuses = getAllowedStatuses();

    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: statuses.map((s) {
            return ListTile(
              title: Text(s),
              trailing: status == s
                  ? const Icon(Icons.check, color: Colors.blue)
                  : null,
              onTap: () async {
                if ((s == 'Working' || s == 'Open' || s == 'Pending Review') &&
                    dueDate == null) {
                  Navigator.pop(context);
                  if (!mounted) return;
                  await showDialog(
                    context: context,
                    builder: (dialogContext) => AlertDialog(
                      title: const Text(
                        'Warning',
                        style: TextStyle(color: Colors.red),
                      ),
                      content: const Text(
                        'Please set the due date before changing the status',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(dialogContext),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                  return;
                }

                Navigator.pop(context);
                if (!mounted) return;
                await updateStatus(s);
              },
            );
          }).toList(),
        );
      },
    );
  }

  Future<void> pickDueDate() async {
    final messenger = ScaffoldMessenger.of(context);

    final picked = await showDatePicker(
      context: context,
      initialDate: dueDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked == null) return;
    if (!mounted) return;

    try {
      await TaskApiService.updateDueDate(
        taskName: widget.task.name,
        dueDate: picked,
      );

      if (!mounted) return;
      setState(() => dueDate = picked);
      messenger.showSnackBar(const SnackBar(content: Text('Due date updated')));
    } catch (e) {
      messenger.showSnackBar(
          const SnackBar(content: Text('Failed to update due date')));
    }
  }

  Color getStatusColor(String s) {
    switch (s) {
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
        return Colors.blue;
    }
  }

  Widget buildStatusStepper() {
    final steps = ['Open', 'In Progress', 'Review', 'Completed'];
    final currentIndex = getStepIndex(status);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(steps.length, (index) {
        final isActive = index <= currentIndex;
        return Column(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: isActive ? Colors.blue : Colors.grey.shade300,
              child: Icon(
                index <= currentIndex ? Icons.check : Icons.circle,
                size: 14,
                color: isActive ? Colors.white : Colors.grey,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              steps[index].toUpperCase(),
              style: TextStyle(
                fontSize: 10,
                color: isActive ? Colors.blue : Colors.grey,
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget buildDescription() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xffEEF1F7),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'DETAILED DESCRIPTION',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            widget.task.description.isNotEmpty
                ? widget.task.description
                : 'No description provided.',
            textAlign: TextAlign.start,
            style: const TextStyle(height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget buildAttachmentsSection() {
    final String base = Urls.baseUrl.replaceAll('/api', '');
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xffEEF1F7),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ATTACHMENTS (${attachments.length})',
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: attachments.map((file) {
              final isImage = file.fileUrl.endsWith('.png') ||
                  file.fileUrl.endsWith('.jpg') ||
                  file.fileUrl.endsWith('.jpeg');

              return Stack(
                clipBehavior: Clip.none,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => FullScreenImage(
                                imageUrl: '$base${file.fileUrl}',
                              ),
                            ),
                          ),
                          child: isImage
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  child: Image.network(
                                    '$base${file.fileUrl}',
                                    width: 30,
                                    height: 30,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : const Icon(Icons.insert_drive_file, size: 30),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                file.fileName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 12),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                formatFileSize(file.fileSize),
                                style: TextStyle(
                                    fontSize: 10, color: Colors.grey.shade600),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: -2,
                    right: -2,
                    child: GestureDetector(
                      onTap: () => deleteFile(file),
                      child: const CircleAvatar(
                        radius: 10,
                        child: Icon(Icons.close, size: 14),
                      ),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

Widget buildAssignmentDetails() {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: const Color(0xffEEF1F7),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'ASSIGNMENT DETAILS',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),

        const SizedBox(height: 12),

        Row(
          children: [
            const CircleAvatar(
              radius: 16,
              child: Icon(Icons.person)
            ),

            const SizedBox(width: 10),

            Expanded(
              child: Text(
                widget.task.creator.isNotEmpty
                    ? widget.task.creator
                    : 'No User Assigned',
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
  Future<void> reassignTask(List<UserModel> newUsers) async {
    try {
      for (final user in assignees) {
        await TaskApiService.removeAssignment(
            taskName: widget.task.name, user: user);
      }
      for (final user in newUsers) {
        await TaskApiService.assignUser(
            taskName: widget.task.name, username: user.name);
      }
      if (!mounted) return;
      await loadAssignees();
    } catch (_) {}
  }

  int getStepIndex(String s) {
    final effectiveStatus = s.toLowerCase() == 'overdue'
        ? previousStatus.toLowerCase()
        : s.toLowerCase();
    switch (effectiveStatus) {
      case 'open':
        return 0;
      case 'working':
        return 1;
      case 'pending review':
        return 2;
      case 'completed':
        return 3;
      default:
        return 0;
    }
  }

  String formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  Widget buildActivitySection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xffEEF1F7),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'ACTIVITY & COMMENTS',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          if (isLoadingComments)
            const Center(child: CircularProgressIndicator()),
          if (!isLoadingComments && activities.isEmpty)
            const Text('No comments yet'),
          if (activities.isNotEmpty)
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: activities.length,
              itemBuilder: (context, index) => buildTimelineItem(
                  activities[index], index, activities.length),
            ),
          const SizedBox(height: 20),
          if (widget.task.status != 'Cancelled') buildCommentInput(),
        ],
      ),
    );
  }

  Widget buildCommentInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () async {
              // Capture messenger BEFORE await
              final messenger = ScaffoldMessenger.of(context);
              final pickedFile =
                  await picker.pickImage(source: ImageSource.gallery);
              if (pickedFile == null) return;
              if (!mounted) return;
              try {
                await TaskApiService.uploadFile(
                  taskName: widget.task.name,
                  file: File(pickedFile.path),
                );
                if (!mounted) return;
                await loadAttachments();
              } catch (e) {
                messenger.showSnackBar(
                    const SnackBar(content: Text('Failed to upload file')));
              }
            },
            child: const Icon(Icons.attach_file, color: Colors.grey),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: commentController,
              decoration: const InputDecoration(
                hintText: 'Type your reply or @mention colleague...',
                border: InputBorder.none,
              ),
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: isSending
                  ? const SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2),
                    )
                  : const Icon(Icons.send, color: Colors.white),
              onPressed: sendComment,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> sendComment() async {
    final text = commentController.text.trim();
    if (text.isEmpty) return;

    if (!mounted) return;
    setState(() => isSending = true);

    try {
      await TaskApiService.addComment(
          taskName: widget.task.name, content: text);

      if (!mounted) return;
      commentController.clear();
      await loadComments();
      if (!mounted) return;
      setState(() => isSending = false);
    } catch (e) {
      if (!mounted) return;
      setState(() => isSending = false);
      showDialog(
        context: context,
        builder: (_) => const AlertDialog(
          title: Text('Error'),
          content: Text('Failed to send comment'),
        ),
      );
    }
  }

  Future<void> deleteFile(TaskAttachments file) async {
    // Capture messenger BEFORE await
    final messenger = ScaffoldMessenger.of(context);
    try {
      await TaskApiService.deleteAttachment(file.name);
      if (!mounted) return;
      await loadAttachments();
      messenger
          .showSnackBar(const SnackBar(content: Text('Attachment deleted')));
    } catch (e) {
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (_) => const AlertDialog(
          title: Text('Error'),
          content: Text('Failed to delete attachment'),
        ),
      );
    }
  }
}
