import 'dart:io';
import 'dart:typed_data';
import 'package:app/core/di/injector.dart';
import 'package:app/core/logger/app_logger.dart';
import 'package:app/features/auth/model/logged_in_user.dart';
import 'package:app/features/tasks/data/api_service.dart';
import 'package:app/features/tasks/model/task_model.dart';
import 'package:app/features/tasks/model/user_list.dart';
import 'package:app/features/tasks/model/user_model.dart';
import 'package:app/features/tasks/presentation/screens/image_preview_screen.dart';
import 'package:app/features/tasks/presentation/screens/video_preview_screen.dart';
import 'package:app/widgets/inputs/search_dropdown_widget.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class CreateTaskScreen extends StatefulWidget {
  const CreateTaskScreen({super.key, this.task});

  /// Pass an existing task to open this screen in edit mode.
  /// Leave null to create a brand-new ticket.
  final Task? task;

  @override
  State<CreateTaskScreen> createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {
  final subjectController = TextEditingController();
  final descriptionController = TextEditingController();
  List<XFile> selectedImages = [];
  String issueType = 'Repair';
  String category = 'Maintenance';
  DateTime? dueDate;
  String priority = 'Low';
  String status = 'Open';
  bool isLoading = false;
  List<UserModel> users = [];
  List<UserModel> selectedUsers = [];

  List<UserList> usersList = [];
  UserList? selectedUserList;
  List<String> _originalAssigneeNames = [];
  final ImagePicker picker = ImagePicker();
  final FocusNode _assignFocusNode = FocusNode();
  final ScrollController _formScrollController = ScrollController();

  final LoggedInUser user = $sl.get<LoggedInUser>();

  bool get isEditing => widget.task != null;
    String stripHtml(String? html) {
  if (html == null || html.isEmpty) return '';

  var text = html
      .replaceAll(RegExp(r'</p>', caseSensitive: false), '\n')
      .replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), '\n')
      .replaceAll(RegExp(r'<[^>]*>'), '')
      .replaceAll('&nbsp;', ' ')
      .replaceAll('&amp;', '&')
      .replaceAll('&lt;', '<')
      .replaceAll('&gt;', '>')
      .replaceAll('&quot;', '"')
      .replaceAll('&#39;', "'");

  return text.trim();
}

  @override
  void initState() {
    super.initState();

    if (isEditing) {
      final task = widget.task!;
      subjectController.text = task.subject;
      // descriptionController.text = task.description;
       descriptionController.text = stripHtml(task.description);
      priority = task.priority;
      status = task.status;
      dueDate = task.expEndDate != null ? DateTime.parse(task.expEndDate!) : null;
    }

    loadUsers();
    if (isEditing) {
      loadExistingAssignees();
    }
  }

  @override
  void dispose() {
    _assignFocusNode.dispose();
    _formScrollController.dispose();
    super.dispose();
  }

  Future<void> loadUsers() async {
    usersList = await TaskApiService.fetchUsersList();
    _applyExistingAssigneeSelection();
    setState(() {});
  }

  Future<void> loadExistingAssignees() async {
    try {
      _originalAssigneeNames = await TaskApiService.fetchAssignees(widget.task!.name);
      _applyExistingAssigneeSelection();
      if (mounted) setState(() {});
    } catch (_) {
      // Non-fatal: user just won't see a preselected assignee.
    }
  }

  void _applyExistingAssigneeSelection() {
    if (_originalAssigneeNames.isEmpty || usersList.isEmpty) return;
    final match = usersList.where((u) => _originalAssigneeNames.contains(u.name));
    if (match.isNotEmpty) {
      selectedUserList = match.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xffF5F7FB),
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Ticket' : 'New Ticket'),
        actions: [
          TextButton(
            onPressed: isLoading ? null : submitTask,
            child: isLoading
                ? const CircularProgressIndicator(color: Colors.blueAccent)
                : ElevatedButton(
                    onPressed: isLoading ? null : submitTask,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade700,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: isLoading
                        ? const SizedBox(
                            height: 18,
                            width: 16,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(isEditing ? 'Update' : 'Create',
                            style: const TextStyle(fontSize: 18)),
                  ),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final keyboardInset = MediaQuery.viewInsetsOf(context).bottom;
          return SingleChildScrollView(
            controller: _formScrollController,
            clipBehavior: Clip.none,
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
            child: Column(
              children: [
                const SizedBox(height: 6),
                buildInputField(
                  title: 'Job Order',
                  required: true,
                  controller: subjectController,
                  hint: 'Briefly describe the issue...',
                ),
                buildInputField(
                  title: 'DETAILED DESCRIPTION',
                  required: true,
                  controller: descriptionController,
                  hint: 'Provide context, steps...',
                  maxLines: 4,
                ),
                if(!isEditing) buildAttachments(),
                buildDropdown(
                  'CATEGORY',
                  category,
                  [
                    'Maintenance',
                    'IT',
                    'House keeping',
                    'Laundry',
                    'Groundskeeping',
                    'General Store',
                    'Taxi',
                    'Lab booking',
                  ],
                  (v) => setState(() => category = v),
                ),
                buildDropdownField(
                  title: 'PRIORITY',
                  value: priority,
                  items: const ['Low', 'Medium', 'High', 'Urgent'],
                  onChanged: (v) => setState(() => priority = v),
                ),
                buildAssignTo(),
                SizedBox(
                  height: keyboardInset > 0
                      ? constraints.maxHeight * 0.5
                      : 20,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Future<void> submitTask() async {
  //   if (subjectController.text.trim().isEmpty) {
  //     _showError('Job Order is mandatory');
  //     return;
  //   }
  //   if (descriptionController.text.trim().isEmpty) {
  //     _showError('Description is mandatory');
  //     return;
  //   }

  //   setState(() => isLoading = true);

  //   try {
  //     final taskName = isEditing ? widget.task!.name : await _createOrUpdate();

  //     // Reconcile assignee only if it changed.
  //     final newAssigneeName = selectedUserList?.name;
  //     final alreadyAssigned = newAssigneeName != null &&
  //         _originalAssigneeNames.contains(newAssigneeName);

  //     if (newAssigneeName != null && !alreadyAssigned) {
  //       for (final old in _originalAssigneeNames) {
  //         await TaskApiService.removeAssignment(taskName: taskName, user: old);
  //       }
  //       await TaskApiService.assignUser(
  //         taskName: taskName,
  //         username: newAssigneeName,
  //       );
  //       await TaskApiService.sendAssignmentNotification(
  //         taskName: taskName,
  //         username: newAssigneeName,
  //         subject: subjectController.text.trim(),
  //         description: descriptionController.text.trim(),
  //       );
  //       $logger.devLog(
  //           'Assignment notification sent to ${selectedUserList!.name},{taskName: $taskName},{subject: ${subjectController.text.trim()}}');
  //     }

  //     for (final image in selectedImages) {
  //       await TaskApiService.uploadFile(
  //           taskName: taskName, file: File(image.path));
  //     }

  //     setState(() => isLoading = false);
  //     if (mounted) {
  //       Navigator.pop(context, true);
  //     }
  //   } catch (e) {
  //     setState(() => isLoading = false);
  //     _showError(e.toString());
  //   }
  // }
//   Future<void> submitTask() async {
//   if (subjectController.text.trim().isEmpty) {
//     _showError('Job Order is mandatory');
//     return;
//   }
//   if (descriptionController.text.trim().isEmpty) {
//     _showError('Description is mandatory');
//     return;
//   }

//   setState(() => isLoading = true);

//   try {
//     final taskName = await _createOrUpdate();

//     // Reconcile assignee only if it changed.
//     final newAssigneeName = selectedUserList?.name;
//     final alreadyAssigned = newAssigneeName != null &&
//         _originalAssigneeNames.contains(newAssigneeName);

//     if (newAssigneeName != null && !alreadyAssigned) {
//       for (final old in _originalAssigneeNames) {
//         await TaskApiService.removeAssignment(taskName: taskName, user: old);
//       }
//       await TaskApiService.assignUser(
//         taskName: taskName,
//         username: newAssigneeName,
//       );
//       await TaskApiService.sendAssignmentNotification(
//         taskName: taskName,
//         username: newAssigneeName,
//         subject: subjectController.text.trim(),
//         description: descriptionController.text.trim(),
//       );
//       $logger.devLog(
//           'Assignment notification sent to ${selectedUserList!.name},{taskName: $taskName},{subject: ${subjectController.text.trim()}}');
//     }

//     for (final image in selectedImages) {
//       await TaskApiService.uploadFile(
//           taskName: taskName, file: File(image.path));
//     }

//     setState(() => isLoading = false);
//     if (mounted) {
//       Navigator.pop(context, true);
//     }
//   } catch (e) {
//     setState(() => isLoading = false);
//     _showError(e.toString());
//   }
// }
Future<void> submitTask() async {
  if (subjectController.text.trim().isEmpty) {
    _showError('Job Order is mandatory');
    return;
  }
  if (descriptionController.text.trim().isEmpty) {
    _showError('Description is mandatory');
    return;
  }

  setState(() => isLoading = true);

  try {
    final taskName = await _createOrUpdate();

    final newAssignee = selectedUserList?.name;
    final hasAssignee = newAssignee != null && newAssignee.isNotEmpty;

    if (hasAssignee) {
      if (isEditing) {
        final currentAssignees = await TaskApiService.fetchAssignees(taskName);
        final alreadyAssigned = currentAssignees.contains(newAssignee);

        if (!alreadyAssigned) {
          for (final oldUser in currentAssignees) {
            if (oldUser != newAssignee) {
              await TaskApiService.removeAssignment(taskName: taskName, user: oldUser);
            }
          }
          await TaskApiService.assignUser(taskName: taskName, username: newAssignee);
        }
      } else {
        await TaskApiService.assignUser(taskName: taskName, username: newAssignee);
      }

      await TaskApiService.sendAssignmentNotification(
        taskName: taskName,
        username: newAssignee,
        subject: subjectController.text.trim(),
        description: descriptionController.text.trim(),
      );
    }
    // No assignee selected -> we just skip assignment/notification entirely
    // and fall through to the success dialog below.

    for (final image in selectedImages) {
      await TaskApiService.uploadFile(taskName: taskName, file: File(image.path));
    }

    if (!mounted) return;
    setState(() => isLoading = false);

    await showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Success'),
        content: Text(isEditing
            ? 'Ticket updated successfully'
            : 'Ticket created successfully'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('OK'),
          ),
        ],
      ),
    );

    if (!mounted) return;
    Navigator.pop(context, true);
  } catch (e) {
    if (mounted) {
      setState(() => isLoading = false);
      _showError(e.toString());
    }
  }
}

  Future<String> _createOrUpdate() async {
      final assigneeFullName = selectedUserList?.fullName ?? '';
    if (isEditing) {
        $logger.devLog('selectedUserList?.name,,,,,,,,update,,,,${selectedUserList?.name}');
      final response = await TaskApiService.updateTask(
        taskName: widget.task!.name,
        subject: subjectController.text,
        description: descriptionController.text,
        priority: priority,
        status: status,
        dueDate: dueDate,
        username: assigneeFullName,
      );
      return response['data']['name'] as String? ?? widget.task!.name;
    } else {
      $logger.devLog('selectedUserList?.name,,,,,,,,${selectedUserList?.name}');
      final response = await TaskApiService.createTask(
        subject: subjectController.text,
        description: descriptionController.text,
        priority: priority,
        project: 'PROJ-0001',
        status: status,
        dueDate: dueDate,
        username: assigneeFullName,
      );
      return response['data']['name'] as String;
    }
  }

  void _showError(String message) {
    if (!mounted) return;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Validation Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Widget buildAssignTo() {
    return buildSection(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'ASSIGN TO',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          SearchDropDownList<UserList>(
            title: '',
            key: ValueKey(usersList.length),
            hint: 'Select User',
            items: usersList,
            focusNode: _assignFocusNode,
            color: Colors.black,
            defaultSelection: selectedUserList,
            futureRequest: (searchText) async {
              if (searchText.trim().isEmpty) {
                return usersList;
              }
              final query = searchText.trim().toLowerCase();
              final filtered = usersList.where((item) {
                final name = item.fullName?.toLowerCase() ?? '';
                return name.contains(query);
              }).toList();
              return filtered;
            },
            listItemBuilder: (context, item, isSelected, onItemSelect) {
              return ListTile(
                title: Text(item.fullName ?? ''),
                onTap: onItemSelect,
              );
            },
            headerBuilder: (context, item, isExpanded) {
              return Text(item.fullName ?? '');
            },
            onSelected: (value) {
              setState(() => selectedUserList = value);
            },
          ),
        ],
      ),
    );
  }

  Widget buildSection({required Widget child}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xffEEF1F7),
        borderRadius: BorderRadius.circular(14),
      ),
      child: child,
    );
  }

  Widget buildInputField({
    required String title,
    required TextEditingController controller,
    String hint = '',
    int maxLines = 1,
    bool readOnly = false,
    bool required = false, 
  }) {
    return buildSection(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         Row(                      
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (required)
              const Text(
                ' *',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
          ],
        ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 2,
            ),
            decoration: BoxDecoration(
              color: readOnly ? Colors.grey.shade200 : const Color(0xFFF2F3FF),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: Colors.grey,
                width: 1,
              ),
            ),
            child: TextField(
              controller: controller,
              maxLines: maxLines,
              readOnly: readOnly,
              decoration: InputDecoration(
                hintText: hint,
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDropdown(String title, String value, List<String> items,
      Function(String) onChanged) {
    return buildSection(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          DropdownButtonFormField(
            value: value,
            items: items
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (v) => onChanged(v.toString()),
            decoration: const InputDecoration(border: OutlineInputBorder()),
          ),
        ],
      ),
    );
  }

  Widget buildAttachments() {
    return buildSection(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'ATTACHMENTS',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: showPickerOptions,
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF2F3FF),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFD6D9F0)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.attach_file),
                  SizedBox(width: 10),
                  Text('Attach files'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            children: selectedImages.map((file) {
              final path = file.path;
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => isVideo(path)
                          ? VideoPreviewScreen(path: path)
                          : ImagePreviewScreen(path: path),
                    ),
                  );
                },
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: isVideo(path)
                          ? Container(
                              width: 70,
                              height: 70,
                              color: Colors.black12,
                              child: const Icon(Icons.videocam,
                                  size: 30, color: Colors.black54),
                            )
                          : Image.file(File(file.path),
                              width: 70, height: 70, fit: BoxFit.cover),
                    ),
                    Positioned(
                      right: 0,
                      child: GestureDetector(
                        onTap: () =>
                            setState(() => selectedImages.remove(file)),
                        child: const CircleAvatar(
                          radius: 10,
                          backgroundColor: Colors.red,
                          child: Icon(Icons.close, size: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  bool isVideo(String path) {
    final lower = path.toLowerCase();
    return lower.endsWith('.mp4') ||
        lower.endsWith('.mov') ||
        lower.endsWith('.avi');
  }

  Future<Uint8List?> getThumbnail(String path) async {
    return await VideoThumbnail.thumbnailData(
      video: path,
      imageFormat: ImageFormat.JPEG,
      maxWidth: 128,
      quality: 75,
    );
  }

  Future<void> showPickerOptions() async {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('Camera'),
              onTap: () {
                Navigator.pop(context);
                showCameraOptions();
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () {
                Navigator.pop(context);
                showGalleryOptions();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> showCameraOptions() async {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take Photo'),
              onTap: () async {
                Navigator.pop(context);
                final XFile? photo =
                    await picker.pickImage(source: ImageSource.camera);
                if (photo != null) setState(() => selectedImages.add(photo));
              },
            ),
            ListTile(
              leading: const Icon(Icons.videocam),
              title: const Text('Record Video'),
              onTap: () async {
                Navigator.pop(context);
                final XFile? video =
                    await picker.pickVideo(source: ImageSource.camera);
                if (video != null) setState(() => selectedImages.add(video));
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> showGalleryOptions() async {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.image),
              title: const Text('Pick Images'),
              onTap: () async {
                Navigator.pop(context);
                final List<XFile> images = await picker.pickMultiImage();
                if (images.isNotEmpty) {
                  setState(() => selectedImages.addAll(images));
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.video_library),
              title: const Text('Pick Video'),
              onTap: () async {
                Navigator.pop(context);
                final XFile? video =
                    await picker.pickVideo(source: ImageSource.gallery);
                if (video != null) setState(() => selectedImages.add(video));
              },
            ),
          ],
        ),
      ),
    );
  }
}

Widget buildDropdownField({
  required String title,
  required String value,
  required List<String> items,
  required Function(String) onChanged,
}) {
  return Container(
    margin: const EdgeInsets.only(bottom: 16),
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
    decoration: BoxDecoration(
      color: const Color(0xffEEF1F7),
      borderRadius: BorderRadius.circular(14),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: (v) => onChanged(v!),
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 2),
          ),
        ),
      ],
    ),
  );
}