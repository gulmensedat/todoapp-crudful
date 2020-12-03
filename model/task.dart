class TaskModel {
  final String id;
  final String createdAt;
  final String title;
  final String details;
  final String due;
  final bool isCompleted;

  TaskModel(this.id, this.createdAt, this.title, this.details, this.due,
      this.isCompleted);

  TaskModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        createdAt = json['createdAt'],
        title = json['title'],
        details = json['details'],
        due = json['due'],
        isCompleted = json['isCompleted'];
}
