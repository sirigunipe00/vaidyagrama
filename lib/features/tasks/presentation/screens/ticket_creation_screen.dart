import 'dart:io';
import 'dart:typed_data';
import 'package:app/core/di/injector.dart';
import 'package:app/features/auth/model/logged_in_user.dart';
import 'package:app/features/tasks/data/api_service.dart';
import 'package:app/features/tasks/model/user_list.dart';
import 'package:app/features/tasks/model/user_model.dart';
import 'package:app/features/tasks/presentation/screens/image_preview_screen.dart';
import 'package:app/features/tasks/presentation/screens/video_preview_screen.dart';
import 'package:app/widgets/inputs/search_dropdown_widget.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class CreateTaskScreen extends StatefulWidget {
  const CreateTaskScreen({super.key});

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
  final ImagePicker picker = ImagePicker();

  final LoggedInUser user = $sl.get<LoggedInUser>();

  @override
  void initState() {
    super.initState();

    loadUsers();
  }

  Future<void> loadUsers() async {
    usersList = await TaskApiService.fetchUsersList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FB),
      appBar: AppBar(
        title: const Text('New Ticket'),
        actions: [
          TextButton(
            onPressed: isLoading ? null : createTask,
            child: isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : ElevatedButton(
                    onPressed: isLoading ? null : createTask,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade700,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: isLoading
                        ? const SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text('Create', style: TextStyle(fontSize: 18)),
                  ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 6),
            buildInputField(
              title: 'SUBJECT',
              controller: subjectController,
              hint: 'Briefly describe the issue...',
            ),
            buildInputField(
              title: 'DETAILED DESCRIPTION',
              controller: descriptionController,
              hint: 'Provide context, steps...',
              maxLines: 4,
            ),
            buildAttachments(),
            buildDropdown(
              'ISSUE TYPE',
              issueType,
              ['Repair', 'Replacement'],
              (v) => setState(() => issueType = v),
            ),
            buildInputField(
              title: 'CATEGORY',
              controller: TextEditingController(text: category),
              hint: 'Maintenance',
            ),
            buildDateField(),
            buildInputField(
              title: 'STATUS',
              controller: TextEditingController(text: status),
              hint: 'Open',
              readOnly: true,
            ),
            buildDropdownField(
              title: 'PRIORITY',
              value: priority,
              items: const ['Low', 'Medium', 'High', 'Urgent'],
              onChanged: (v) => setState(() => priority = v),
            ),
            buildAssignTo(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Future<void> createTask() async {
    if (subjectController.text.trim().isEmpty) {
      _showError('Subject is mandatory');
      return;
    }
    if (descriptionController.text.trim().isEmpty) {
      _showError('Description is mandatory');
      return;
    }

    setState(() => isLoading = true);

    try {
      final response = await TaskApiService.createTask(
        subject: subjectController.text,
        description: descriptionController.text,
        priority: priority,
        project: 'PROJ-0001',
        status: status,
        dueDate: dueDate,
        username: selectedUserList?.fullName ?? '',
      );

      final taskName = response['data']['name'];

      if (selectedUserList != null) {
        await TaskApiService.assignUser(
          taskName: taskName,
          username: selectedUserList!.name ?? '',
        );
      }
      for (final image in selectedImages) {
        await TaskApiService.uploadFile(
            taskName: taskName, file: File(image.path));
      }

      setState(() => isLoading = false);
      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      setState(() => isLoading = false);
      _showError(e.toString());
    }
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Validation Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
  Widget buildDateField() {
  return buildSection(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'DUE DATE',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 8),

        GestureDetector(
          onTap: () async {
            final pickedDate = await showDatePicker(
              context: context,
              initialDate: dueDate ?? DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime(2100),
            );

            if (pickedDate != null) {
              setState(() {
                dueDate = pickedDate;
              });
            }
          },

          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 16,
            ),

            decoration: BoxDecoration(
              color: const Color(0xFFF2F3FF),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.grey),
            ),

            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  dueDate == null
                      ? 'Select Due Date'
                      : '${dueDate!.day}/${dueDate!.month}/${dueDate!.year}',
                  style: TextStyle(
                    color: dueDate == null
                        ? Colors.grey
                        : Colors.black,
                  ),
                ),

                const Icon(Icons.calendar_today, size: 18),
              ],
            ),
          ),
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
            hint: 'Select User',
            items: usersList,
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
}) {
  return buildSection(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 8),

        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 2,
          ),

          decoration: BoxDecoration(
            color: readOnly
                ? Colors.grey.shade200
                : const Color(0xFFF2F3FF),

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
