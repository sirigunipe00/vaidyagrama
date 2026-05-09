class Task {


  Task({
    required this.name,
    required this.subject,
    required this.status,
    required this.priority,
    required this.description,
    required this.creation,
    required this.creator,
    required this.expEndDate,
    required this.owner,
    this.customUnit,

  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      name: json['name'] ?? '',
      owner: json['owner'] ?? '',
      subject: json['subject'] ?? '',
      status: json['status'] ?? '',
      priority: json['priority'] ?? '',
      description: json['description'] ?? '',
      creation: json['creation'] ?? '',
      creator: json['custom_assigned_to'] ?? '',
      expEndDate: json['exp_end_date'],
      customUnit: json['custom_unit'],

    );
  }
  final String name;
  final String subject;
  final String status;
  final String priority;
  final String description;
  final String owner;
  final String creation;
  final String creator;
  final String? expEndDate;
  final String? customUnit;
}
