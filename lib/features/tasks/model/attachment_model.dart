class TaskAttachments {

  factory TaskAttachments.fromJson(Map<String, dynamic> json) {
    return TaskAttachments(
      fileUrl: json['file_url'] ?? '',
      fileName: json['file_name'] ?? '',
      fileSize: json['file_size'] ?? 0,
      name: json['name'] ?? '',
    );
  }

  TaskAttachments({
    required this.fileUrl,
    required this.fileName,
    required this.fileSize,
    required this.name
  });
  final String fileUrl;
  final String fileName;
  final int fileSize;
  final String name;
}