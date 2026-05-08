class CommentModel {

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      type: 'comment', // since this API is for comments
      user: json['comment_by'] ?? '',
      commentEmail: json['comment_email'] ?? '',
      message: _stripHtml(json['content'] ?? ''),
      time: DateTime.parse(json['creation']),
    );
  }

  CommentModel({
    required this.type,
    required this.user,
    required this.commentEmail,
    required this.message,
    required this.time,
  });
  final String type; // "system" | "comment"
  final String user;
  final String commentEmail;
  final String message;
  final DateTime time;
}

String _stripHtml(String html) {
  return html.replaceAll(RegExp(r'<[^>]*>'), '');
}
