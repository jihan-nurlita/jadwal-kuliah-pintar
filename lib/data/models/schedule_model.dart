import 'package:flutter/material.dart';

class ScheduleModel {
  final String id;
  final String namaMatkul;
  final String dosen;
  final String ruangan;
  final String hari;
  final TimeOfDay mulai;
  final TimeOfDay selesai;

  ScheduleModel({
    required this.id,
    required this.namaMatkul,
    required this.dosen,
    required this.ruangan,
    required this.hari,
    required this.mulai,
    required this.selesai,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'namaMatkul': namaMatkul,
    'dosen': dosen,
    'ruangan': ruangan,
    'hari': hari,
    'mulai_hour': mulai.hour,
    'mulai_minute': mulai.minute,
    'selesai_hour': selesai.hour,
    'selesai_minute': selesai.minute,
  };

  factory ScheduleModel.fromJson(Map<String, dynamic> json) => ScheduleModel(
    id: json['id'],
    namaMatkul: json['namaMatkul'],
    dosen: json['dosen'],
    ruangan: json['ruangan'],
    hari: json['hari'],
    mulai: TimeOfDay(hour: json['mulai_hour'], minute: json['mulai_minute']),
    selesai: TimeOfDay(hour: json['selesai_hour'], minute: json['selesai_minute']),
  );
}
