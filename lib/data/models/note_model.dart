class NoteModel {
  final String id;
  final String judul;
  final String isiCatatan;
  final DateTime tanggal;
  final String kategori; // 'Pemrograman', 'Basis Data', 'UI/UX', 'Lainnya'

  NoteModel({
    required this.id,
    required this.judul,
    required this.isiCatatan,
    required this.tanggal,
    required this.kategori,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'judul': judul,
    'isiCatatan': isiCatatan,
    'tanggal': tanggal.toIso8601String(),
    'kategori': kategori,
  };

  factory NoteModel.fromJson(Map<String, dynamic> json) => NoteModel(
    id: json['id'],
    judul: json['judul'],
    isiCatatan: json['isiCatatan'],
    tanggal: DateTime.parse(json['tanggal']),
    kategori: json['kategori'],
  );
}
