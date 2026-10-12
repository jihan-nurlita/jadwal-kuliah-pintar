export interface Schedule {
  id: string;
  namaMatkul: string;
  dosen: string;
  ruangan: string;
  hari: string; // 'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu'
  mulai: string; // "HH:MM"
  selesai: string; // "HH:MM"
}

export interface Task {
  id: string;
  namaTugas: string;
  namaMatkul: string;
  deadline: string; // YYYY-MM-DD
  prioritas: 'Rendah' | 'Sedang' | 'Tinggi';
  deskripsi: string;
  selesai: boolean;
}

export interface Note {
  id: string;
  judul: string;
  isiCatatan: string;
  tanggal: string; // YYYY-MM-DD
  kategori: 'Pemrograman' | 'Basis Data' | 'UI/UX' | 'Lainnya';
}

export interface AppReminder {
  id: string;
  title: string;
  time: string; // "HH:MM"
  isActive: boolean;
  type: 'Jadwal Kuliah' | 'Deadline Tugas' | 'Belajar' | 'Statistik';
}
