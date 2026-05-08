import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:app/core/consts/urls.dart';
import 'package:app/core/di/injector.dart';
import 'package:app/features/auth/model/logged_in_user.dart';
import 'package:app/features/tasks/model/attachment_model.dart';
import 'package:app/features/tasks/model/comment_data.dart';
import 'package:app/features/tasks/model/task_model.dart';
import 'package:app/features/tasks/model/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';


class TaskApiService {

  static Map<String, String> get headers {

    final user = $sl.get<LoggedInUser>();

    final apiKey = user.apiKey;
    final apiSecret = user.apiSecret;

    return {
      HttpHeaders.authorizationHeader:
          'token $apiKey:$apiSecret',

      HttpHeaders.contentTypeHeader:
          'application/json',
    };
  }
  
  static Future<List<Task>> fetchTasks() async {


  final String base =
      Urls.baseUrl.replaceAll('/api', '');

  final url = Uri.parse(
    '$base/api/resource/Task'
    '?fields=["name","subject","status","priority","project","creation","description","exp_end_date"]'
    '&order_by=creation desc'
    '&limit_page_length=None',
  );

  final response = await http.get(
    url,
    headers: headers);

  log('fetchTasks response: ${response.body}');

  if (response.statusCode != 200) {
    throw Exception(
      'fetchTasks failed [${response.statusCode}]: ${response.body}',
    );
  }

  final decoded = jsonDecode(response.body);

  final List data = decoded['data'];

  return data
      .map((e) => Task.fromJson(e))
      .toList();
}

  static Future<List<String>> fetchAssignees(String taskName) async {
    final String base = Urls.baseUrl.replaceAll('/api', '');
    final url = Uri.parse('$base/api/resource/ToDo'
        '?filters=[["reference_type","=","Task"],["reference_name","=","$taskName"],["status","=","Open"]]'
        '&fields=["allocated_to"]');

    final response = await http.get(url, headers: headers);

    final decoded = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final List data = decoded['data'] ?? [];

      return data
          .map<String>((e) => e['allocated_to']?.toString() ?? '')
          .where((e) => e.isNotEmpty)
          .toList();
    } else {
      throw Exception('Failed to fetch assignees');
    }
  }

  static Future<void> uploadFile({
    required String taskName,
    required File file,
  }) async {
    final String base = Urls.baseUrl.replaceAll('/api', '');
    final url = Uri.parse('$base/api/method/upload_file');

    var request = http.MultipartRequest('POST', url);

    request.headers.addAll(headers);

    request.fields['doctype'] = 'Task';
    request.fields['docname'] = taskName;
    request.fields['is_private'] = '0';

    request.files.add(
      await http.MultipartFile.fromPath(
        'file',
        file.path,
        filename: file.path.split('/').last,
        contentType: getMediaType(file.path),
      ),
    );

    final response = await request.send();

    final respStr = await response.stream.bytesToString();
  }

  static MediaType getMediaType(String path) {
    final lower = path.toLowerCase();

    if (lower.endsWith('.png')) return MediaType('image', 'png');
    if (lower.endsWith('.jpg') || lower.endsWith('.jpeg')) {
      return MediaType('image', 'jpeg');
    }
    if (lower.endsWith('.mp4')) return MediaType('video', 'mp4');
    if (lower.endsWith('.mov')) return MediaType('video', 'quicktime');

    return MediaType('application', 'octet-stream');
  }

  static Future<void> deleteAttachment(String fileId) async {
    final String base = Urls.baseUrl.replaceAll('/api', '');
    final url = Uri.parse('$base/api/resource/File/$fileId');

    final response = await http.delete(
      url,
      headers: headers,
    );

    if (response.statusCode != 200 &&
        response.statusCode != 202 &&
        response.statusCode != 204) {
      throw Exception(response.body); // 🔥 show real error
    }
  }

  static Future<List<UserModel>> fetchUsers() async {
    final String base = Urls.baseUrl.replaceAll('/api', '');
    final url = Uri.parse('$base/api/resource/User'
        '?fields=["*"]'
        '&limit_page_length=None');

    final response = await http.get(url, headers: headers);

    final decoded = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final List data = decoded['data'] ?? [];
      return data.map((e) => UserModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to fetch users');
    }
  }

  static Future<List<TaskAttachments>> fetchAttachments(String taskName) async {
    final String base = Urls.baseUrl.replaceAll('/api', '');
    final url = Uri.parse('$base/api/resource/File').replace(
      queryParameters: {
        'filters':
            '[["attached_to_doctype","=","Task"],["attached_to_name","=","$taskName"]]',
        'fields': '["file_url","file_name","file_size","name"]',
      },
    );

    final response = await http.get(url, headers: headers);

    final decoded = jsonDecode(response.body);

    final List data = decoded['data'] ?? [];

    return data
        .map<TaskAttachments>((e) => TaskAttachments.fromJson(e))
        .toList();
  }

  static Future<Map<String, dynamic>> createTask(
      {required String subject,
      required String description,
      required String priority,
      required String project,

      String status = 'Open',
      DateTime? dueDate,

      required String username}) async {
            final String base = Urls.baseUrl.replaceAll('/api', '');

    
    final url = Uri.parse('$base/api/resource/Task');

    final body = {
      'subject': subject,
      'description': description,
      'priority': priority,
      'status': status,
      'custom_assigned_to': username,


      // "project": project,
      if (dueDate != null)
        'exp_end_date': dueDate.toIso8601String().split('T')[0],
    };

    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(body),
    );

    final decoded = jsonDecode(response.body);
    log('response........${response.body}');
    log('body........${jsonEncode(body)}');

  

    if (response.statusCode == 200) {
      final taskName = decoded['data']['name'];
      await assignUser(
        taskName: taskName,
        // user: "maintenance@rockwell.co.in",
        username : username,
      );

      return decoded;
    } else {
      throw Exception(decoded['message'] ?? 'Failed to create task');
    }
  }

  static Future<void> updateDueDate({
    required String taskName,
    required DateTime dueDate,
  }) async {
        final String base = Urls.baseUrl.replaceAll('/api', '');

    final url = Uri.parse('$base/api/resource/Task/$taskName');

    final response = await http.put(
      url,
      headers: headers,
      body: jsonEncode({
        'exp_end_date': dueDate.toIso8601String().split('T')[0],
      }),
    );

    if (![200, 202].contains(response.statusCode)) {
      throw Exception('Failed to update due date');
    }
  }

  static Future<void> assignUser({
    required String taskName,
    required String username,
  }) async {
        final String base = Urls.baseUrl.replaceAll('/api', '');

    final url = Uri.parse(
      
      '$base/api/method/frappe.desk.form.assign_to.add',
    );
    final reqbody = {
      'assign_to': [username],
      'doctype': 'Task',
      'name': taskName,
    };

    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(reqbody),
    );
  }

  static Future<void> removeAssignment({
    required String taskName,
    required String user,
  }) async {
        final String base = Urls.baseUrl.replaceAll('/api', '');

    final url = Uri.parse(
      '$base/api/method/frappe.desk.form.assign_to.remove',
    );


    await http.post(
      url,
      headers: headers,
      body: jsonEncode({
        'doctype': 'Task',
        'name': taskName,
        'assign_to': user,
      }),
    );
  }

  static Future<void> updateTaskStatus({
    required String taskName,
    required String status,
  }) async {
        final String base = Urls.baseUrl.replaceAll('/api', '');

    final url = Uri.parse('$base/api/resource/Task/$taskName');
     final body = <String, dynamic>{
    'status': status,

    if (status == 'Completed')
      'completed_on': DateTime.now().toIso8601String().split('T')[0],
  };

    final response = await http.put(
      url,
      headers: headers,
      body: jsonEncode(
        body,
        ),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update status');
    }
  }

  static Future<Task> getTaskById(String taskName) async {
        final String base = Urls.baseUrl.replaceAll('/api', '');

    final url = Uri.parse('$base/api/resource/Task/$taskName');

    final response = await http.get(url, headers: headers);

    final decoded = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return Task.fromJson(decoded['data']);
    } else {
      throw Exception('Failed to fetch task');
    }
  }

  static Future<List<CommentModel>> fetchComments(String taskName) async {
        final String base = Urls.baseUrl.replaceAll('/api', '');

    final url = Uri.parse('$base/api/resource/Comment').replace(
      queryParameters: {
        'filters':
            '[["reference_doctype","=","Task"],["reference_name","=","$taskName"]]',
        'fields': '["comment_by","content","creation","comment_email"]',
        'order_by': 'creation desc',
      },
    );

    final response = await http.get(url, headers: headers);

    final decoded = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final List data = decoded['data'] ?? [];

      return data.map<CommentModel>((e) {
        return CommentModel.fromJson(e);
      }).toList();
    } else {
      throw Exception('Failed to fetch comments');
    }
  }

  static Future<void> addComment({
    required String taskName,
    required String content,
  }) async {
        final String base = Urls.baseUrl.replaceAll('/api', '');

    final url = Uri.parse('$base/api/resource/Comment');

    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode({
        'doctype': 'Comment',
        'comment_type': 'Comment',
        'reference_doctype': 'Task',
        'reference_name': taskName,
        'content': content,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to add comment');
    }
  }
}
