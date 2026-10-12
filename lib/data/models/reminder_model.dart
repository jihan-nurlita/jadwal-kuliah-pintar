class ReminderModel {
  final String id;
  final String title;
  final String time; // "HH:MM"
  final bool isActive;
  final String type; // 'Jadwal Kuliah', 'Deadline Tugas', 'Belajar'

  ReminderModel({
    required this.id,
    required this.title,
    required this.time,
    required this.isActive,
    required this.type,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'time': time,
    'isActive': isActive,
    'type': type,
  };

  factory ReminderModel.fromJson(Map<String, dynamic> json) => ReminderModel(
    id: json['id'],
    title: json['title'],
    time: json['time'],
    isActive: json['isActive'],
    type: json['type'],
  );
}
