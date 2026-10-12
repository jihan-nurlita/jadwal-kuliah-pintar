class TaskModel {
  final String id;
  final String namaTugas;
  final String namaMatkul;
  final DateTime deadline;
  final String prioritas; // 'Rendah', 'Sedang', 'Tinggi'
  final String deskripsi;
  final bool selesai;

  TaskModel({
    required this.id,
    required this.namaTugas,
    required this.namaMatkul,
    required this.deadline,
    required this.prioritas,
    required this.deskripsi,
    required this.selesai,
  });

  TaskModel copyWith({
    String? id,
    String? namaTugas,
    String? namaMatkul,
    DateTime? deadline,
    String? prioritas,
    String? deskripsi,
    bool? selesai,
  }) {
    return TaskModel(
      id: id ?? this.id,
      namaTugas: namaTugas ?? this.namaTugas,
      namaMatkul: namaMatkul ?? this.namaMatkul,
      deadline: deadline ?? this.deadline,
      prioritas: prioritas ?? this.prioritas,
      deskripsi: deskripsi ?? this.deskripsi,
      selesai: selesai ?? this.selesai,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'namaTugas': namaTugas,
    'namaMatkul': namaMatkul,
    'deadline': deadline.toIso8601String(),
    'prioritas': prioritas,
    'deskripsi': deskripsi,
    'selesai': selesai,
  };

  factory TaskModel.fromJson(Map<String, dynamic> json) => TaskModel(
    id: json['id'],
    namaTugas: json['namaTugas'],
    namaMatkul: json['namaMatkul'],
    deadline: DateTime.parse(json['deadline']),
    prioritas: json['prioritas'],
    deskripsi: json['deskripsi'],
    selesai: json['selesai'],
  );
}
