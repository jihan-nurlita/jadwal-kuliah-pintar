import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/models/note_model.dart';
import '../../../providers/note_provider.dart';
import '../../widgets/custom_card.dart';
import '../../../core/constants/app_colors.dart';
import 'package:intl/intl.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  String _selectedCategory = 'Semua';

  // 5 Kategori Utama yang langsung tampil di bar atas agar bersih
  final List<String> _mainCategories = [
    'Semua',
    'Pemrograman',
    'Basis Data',
    'UI/UX',
    'Jaringan Komputer',
  ];

  // Seluruh daftar kategori lengkap kuliah IT / Ilmu Komputer
  final List<String> _allCategories = [
    'Semua',
    'Pemrograman',
    'Basis Data',
    'UI/UX',
    'Jaringan Komputer',
    'Kecerdasan Buatan',
    'Struktur Data & Algoritma',
    'Sistem Operasi',
    'Matematika Diskrit',
    'Rekayasa Perangkat Lunak',
    'Keamanan Informasi',
    'Pemrograman Web Lanjut',
    'Sistem Terdistribusi',
    'Etika Profesi & Kewirausahaan',
    'Lainnya',
  ];

  // Warna aksen elegan untuk setiap kategori (Light & Dark Mode)
  Color _getCategoryColor(String category, bool isDarkMode) {
    switch (category) {
      case 'Pemrograman':
        return isDarkMode ? const Color(0xFF818CF8) : const Color(0xFF4F46E5);
      case 'Basis Data':
        return isDarkMode ? const Color(0xFF2DD4BF) : const Color(0xFF0D9488);
      case 'UI/UX':
        return isDarkMode ? const Color(0xFFF97316) : const Color(0xFFEA580C);
      case 'Jaringan Komputer':
        return isDarkMode ? const Color(0xFF60A5FA) : const Color(0xFF2563EB);
      case 'Kecerdasan Buatan':
        return isDarkMode ? const Color(0xFFEC4899) : const Color(0xFFDB2777);
      case 'Struktur Data & Algoritma':
        return isDarkMode ? const Color(0xFF38BDF8) : const Color(0xFF0284C7);
      case 'Sistem Operasi':
        return isDarkMode ? const Color(0xFF34D399) : const Color(0xFF059669);
      case 'Matematika Diskrit':
        return isDarkMode ? const Color(0xFFFACC15) : const Color(0xFFCA8A04);
      case 'Rekayasa Perangkat Lunak':
        return isDarkMode ? const Color(0xFFFB923C) : const Color(0xFFC2410C);
      case 'Keamanan Informasi':
        return isDarkMode ? const Color(0xFFF87171) : const Color(0xFFDC2626);
      case 'Pemrograman Web Lanjut':
        return isDarkMode ? const Color(0xFF818CF8) : const Color(0xFF4338CA);
      case 'Sistem Terdistribusi':
        return isDarkMode ? const Color(0xFF22D3EE) : const Color(0xFF0891B2);
      case 'Etika Profesi & Kewirausahaan':
        return isDarkMode ? const Color(0xFFACC8E5) : const Color(0xFF475569);
      case 'Lainnya':
        return isDarkMode ? const Color(0xFFA78BFA) : const Color(0xFF7C3AED);
      default:
        return isDarkMode ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    }
  }

  // Dialog untuk memilih dari seluruh kategori lengkap saat tombol "Lainnya..." ditekan
  // Dialog untuk memilih dari seluruh kategori lengkap
  void _showAllCategoriesDialog(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final dialogTheme = Theme.of(context);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: dialogTheme.dialogBackgroundColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          titlePadding: const EdgeInsets.all(0),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          actionsPadding:
              const EdgeInsets.only(bottom: 16, right: 16, left: 16),
          title: Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: const Row(
              children: [
                SizedBox(width: 1),
                Text(
                  'Semua Kategori Kuliah',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.85,
            height: 350,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _allCategories.length,
              itemBuilder: (context, index) {
                final cat = _allCategories[index];
                final isSelected = _selectedCategory == cat;
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 2),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary.withOpacity(0.1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    dense: true,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    title: Text(
                      cat,
                      style: TextStyle(
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.w500,
                        color: isSelected
                            ? AppColors.primary
                            : dialogTheme.textTheme.bodyLarge?.color,
                      ),
                    ),
                    trailing: isSelected
                        ? const Icon(Icons.check_circle_rounded,
                            color: AppColors.primary, size: 20)
                        : null,
                    onTap: () {
                      setState(() {
                        _selectedCategory = cat;
                      });
                      Navigator.pop(context);
                    },
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                foregroundColor:
                    isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              child: const Text('Tutup',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  // Dialog untuk Tambah / Edit Catatan
  void _showNoteFormDialog(BuildContext context, NoteProvider provider,
      {NoteModel? noteToEdit}) {
    final formKey = GlobalKey<FormState>();
    final isEditing = noteToEdit != null;

    String judul = isEditing ? noteToEdit.judul : '';
    String isiCatatan = isEditing ? noteToEdit.isiCatatan : '';
    String kategori = isEditing ? noteToEdit.kategori : 'Pemrograman';
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final List<String> formCategoriesList =
        _allCategories.where((c) => c != 'Semua').toList();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final dialogTheme = Theme.of(context);
            return AlertDialog(
              backgroundColor: dialogTheme.dialogBackgroundColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24)),
              titlePadding: const EdgeInsets.all(0),
              contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              actionsPadding:
                  const EdgeInsets.only(bottom: 20, right: 20, left: 20),
              title: Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      isEditing ? Icons.edit_rounded : Icons.edit_note_rounded,
                      color: Colors.white,
                      size: 26,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      isEditing ? 'Edit Catatan Kuliah' : 'Buat Catatan Kuliah',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              content: SizedBox(
                width: MediaQuery.of(context).size.width *
                    0.85, // Membatasi lebar agar pas
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 24),
                        TextFormField(
                          initialValue: judul,
                          style: TextStyle(
                              color: dialogTheme.textTheme.bodyLarge?.color),
                          decoration: InputDecoration(
                            labelText: 'Judul Catatan / Bab',
                            labelStyle: TextStyle(color: dialogTheme.hintColor),
                            hintText: 'Contoh: Dasar OOP & Class',
                            prefixIcon: const Icon(Icons.title_rounded,
                                color: AppColors.primary, size: 20),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14)),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: const BorderSide(
                                  color: AppColors.primary, width: 2),
                            ),
                            filled: true,
                            fillColor: isDarkMode
                                ? Colors.white.withOpacity(0.05)
                                : Colors.grey.withOpacity(0.04),
                          ),
                          validator: (v) => v == null || v.trim().isEmpty
                              ? 'Masukkan judul catatan'
                              : null,
                          onSaved: (v) => judul = v!.trim(),
                        ),
                        const SizedBox(height: 16),
                        // Dropdown dengan penanganan Overflow teks
                        DropdownButtonFormField<String>(
                          value: formCategoriesList.contains(kategori)
                              ? kategori
                              : formCategoriesList.first,
                          dropdownColor: dialogTheme.scaffoldBackgroundColor,
                          style: TextStyle(
                              color: dialogTheme.textTheme.bodyLarge?.color),
                          isExpanded:
                              true, // PENTING agar dropdown mengikuti lebar layar dan tidak overflow
                          decoration: InputDecoration(
                            labelText: 'Kategori Kuliah',
                            labelStyle: TextStyle(color: dialogTheme.hintColor),
                            prefixIcon: const Icon(Icons.category_rounded,
                                color: AppColors.primary, size: 20),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14)),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: const BorderSide(
                                  color: AppColors.primary, width: 2),
                            ),
                            filled: true,
                            fillColor: isDarkMode
                                ? Colors.white.withOpacity(0.05)
                                : Colors.grey.withOpacity(0.04),
                          ),
                          items: formCategoriesList
                              .map((c) => DropdownMenuItem(
                                    value: c,
                                    child: Text(
                                      c,
                                      overflow: TextOverflow
                                          .ellipsis, // Mencegah teks terpotong/overflow
                                      style: TextStyle(
                                          color: dialogTheme
                                              .textTheme.bodyLarge?.color),
                                    ),
                                  ))
                              .toList(),
                          onChanged: (v) {
                            setDialogState(() {
                              kategori = v!;
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          initialValue: isiCatatan,
                          style: TextStyle(
                              color: dialogTheme.textTheme.bodyLarge?.color),
                          decoration: InputDecoration(
                            labelText: 'Catatan Kuliah / Rangkuman Bab...',
                            labelStyle: TextStyle(color: dialogTheme.hintColor),
                            alignLabelWithHint: true,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14)),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: const BorderSide(
                                  color: AppColors.primary, width: 2),
                            ),
                            filled: true,
                            fillColor: isDarkMode
                                ? Colors.white.withOpacity(0.05)
                                : Colors.grey.withOpacity(0.04),
                          ),
                          maxLines: 5,
                          validator: (v) => v == null || v.trim().isEmpty
                              ? 'Isi catatan tidak boleh kosong'
                              : null,
                          onSaved: (v) => isiCatatan = v!.trim(),
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  style: TextButton.styleFrom(
                    foregroundColor: isDarkMode
                        ? Colors.grey.shade400
                        : Colors.grey.shade600,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                  ),
                  child: const Text('Batal',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      formKey.currentState!.save();
                      final messenger = ScaffoldMessenger.of(context);

                      if (isEditing) {
                        final updatedNote = NoteModel(
                          id: noteToEdit.id,
                          judul: judul,
                          isiCatatan: isiCatatan,
                          tanggal: DateTime.now(),
                          kategori: kategori,
                        );
                        provider.editNote(updatedNote);
                        Navigator.pop(dialogContext);
                        messenger.showSnackBar(
                          SnackBar(
                            content: const Row(
                              children: [
                                Icon(Icons.check_circle_rounded,
                                    color: Colors.white),
                                SizedBox(width: 10),
                                Text('Catatan berhasil diperbarui!',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600)),
                              ],
                            ),
                            backgroundColor: AppColors.success,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            margin: const EdgeInsets.all(16),
                          ),
                        );
                      } else {
                        final newNote = NoteModel(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          judul: judul,
                          isiCatatan: isiCatatan,
                          tanggal: DateTime.now(),
                          kategori: kategori,
                        );
                        provider.addNote(newNote);
                        Navigator.pop(dialogContext);
                        messenger.showSnackBar(
                          SnackBar(
                            content: const Row(
                              children: [
                                Icon(Icons.check_circle_rounded,
                                    color: Colors.white),
                                SizedBox(width: 10),
                                Text('Catatan kuliah disimpan!',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600)),
                              ],
                            ),
                            backgroundColor: AppColors.success,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            margin: const EdgeInsets.all(16),
                          ),
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(isEditing ? 'Perbarui' : 'Simpan',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Bottom Sheet Detail Catatan (Tampil penuh saat container ditekan)
  void _showNoteDetailSheet(
      BuildContext context, NoteModel note, NoteProvider noteProvider) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final categoryColor = _getCategoryColor(note.kategori, isDarkMode);
    final fDate = DateFormat('dd MMMM yyyy, HH:mm').format(note.tanggal);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final theme = Theme.of(context);
        return Container(
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(28),
              topRight: Radius.circular(28),
            ),
          ),
          child: DraggableScrollableSheet(
            initialChildSize: 0.75,
            maxChildSize: 0.92,
            minChildSize: 0.4,
            expand: false,
            builder: (context, scrollController) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 44,
                        height: 5,
                        decoration: BoxDecoration(
                          color: isDarkMode
                              ? Colors.white24
                              : Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: categoryColor.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            note.kategori,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: categoryColor,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit_rounded,
                                  color: AppColors.primary),
                              onPressed: () {
                                Navigator.pop(context);
                                _showNoteFormDialog(context, noteProvider,
                                    noteToEdit: note);
                              },
                              tooltip: 'Edit Catatan',
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline_rounded,
                                  color: Colors.redAccent),
                              onPressed: () {
                                Navigator.pop(context);
                                noteProvider.deleteNote(note.id);
                              },
                              tooltip: 'Hapus Catatan',
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        Icon(Icons.calendar_month,
                            size: 14,
                            color: isDarkMode
                                ? Colors.grey.shade400
                                : Colors.grey),
                        const SizedBox(width: 3),
                        Text(
                          fDate,
                          style: TextStyle(
                            fontSize: 12,
                            color: isDarkMode
                                ? Colors.grey.shade400
                                : Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 7),
                    Text(
                      note.judul,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        height: 1.3,
                        color: theme.textTheme.titleLarge?.color,
                      ),
                    ),
                    const Divider(height: 13, thickness: 1),
                    Expanded(
                      child: SingleChildScrollView(
                        controller: scrollController,
                        physics: const BouncingScrollPhysics(),
                        child: Text(
                          note.isiCatatan,
                          style: TextStyle(
                            fontSize: 14.5,
                            height: 1.6,
                            color: isDarkMode
                                ? Colors.grey.shade200
                                : Colors.grey.shade800,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          _triggerAISummarize(context, note);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accent,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 17),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                          elevation: 0,
                        ),
                        icon: const Icon(Icons.auto_awesome_rounded, size: 20),
                        label: const Text(
                          'Rangkum Catatan Ini dengan AI',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _triggerAISummarize(BuildContext context, NoteModel note) async {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setBottomSheetState) {
            bool isLoading = true;
            String summaryResult = '';

            Future.delayed(const Duration(seconds: 2, milliseconds: 500), () {
              if (context.mounted) {
                setBottomSheetState(() {
                  isLoading = false;
                  summaryResult = '🎯 **RANGKUMAN PINTAR GEMINI AI**\n\n'
                      'Berikut beberapa poin penting dari catatan ilmiah Anda tentang "**${note.judul}**":\n\n'
                      '• Catatan ini merangkum esensi penting mata kuliah kategori **${note.kategori}**.\n'
                      '• Poin Utama: Mengulas pemahaman logis dan aspek teoretis dasar yang sangat berguna untuk persiapan ujian.\n'
                      '• Rekomendasi Action Point: Teruskan latihan latihan soal dan ulas ulang catatan ini seminggu sebelum masa UTS dimulai.\n\n'
                      '🎓 **REKOMENDASI SOAL LATIHAN**\n'
                      '1. Mengapa konsep dalam "${note.judul}" penting dalam arsitektur software?\n'
                      '2. Jelaskan korelasi materi tersebut dengan modul kuliah sebelumnya!';
                });
              }
            });

            final sheetTheme = Theme.of(context);

            return Container(
              decoration: BoxDecoration(
                color: sheetTheme.scaffoldBackgroundColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(28),
                  topRight: Radius.circular(28),
                ),
              ),
              child: DraggableScrollableSheet(
                initialChildSize: 0.7,
                maxChildSize: 0.9,
                minChildSize: 0.5,
                expand: false,
                builder: (context, scrollController) {
                  return SingleChildScrollView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            width: 44,
                            height: 5,
                            decoration: BoxDecoration(
                              color: isDarkMode
                                  ? Colors.white24
                                  : Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: AppColors.accent.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: const Icon(Icons.psychology_rounded,
                                  color: AppColors.accent, size: 28),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Asisten Akademik Gemini',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        sheetTheme.textTheme.titleLarge?.color,
                                  ),
                                ),
                                Text(
                                  'Generated by Google Gemini Pro',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: isDarkMode
                                        ? Colors.grey.shade400
                                        : Colors.grey,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'AI membantu merangkum materi Kuliah dan memberikan rekomendasi soal belajarmu secara instan.',
                          style: TextStyle(
                            fontSize: 13,
                            color: isDarkMode
                                ? Colors.grey.shade300
                                : Colors.grey.shade600,
                            height: 1.4,
                          ),
                        ),
                        const Divider(height: 32, thickness: 1),
                        isLoading
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const SizedBox(height: 48),
                                    const SizedBox(
                                      height: 40,
                                      width: 40,
                                      child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                AppColors.accent),
                                        strokeWidth: 3.5,
                                      ),
                                    ),
                                    const SizedBox(height: 24),
                                    Text(
                                      'Gemini AI sedang menganalisis materi Anda...',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: isDarkMode
                                            ? Colors.grey.shade300
                                            : Colors.grey.shade600,
                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 48),
                                  ],
                                ),
                              )
                            : Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: AppColors.primary
                                      .withOpacity(isDarkMode ? 0.08 : 0.03),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                      color:
                                          AppColors.primary.withOpacity(0.12)),
                                ),
                                child: Text(
                                  summaryResult,
                                  style: TextStyle(
                                    fontSize: 13.5,
                                    height: 1.6,
                                    color: isDarkMode
                                        ? Colors.grey.shade100
                                        : Colors.grey.shade800,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final noteProvider = Provider.of<NoteProvider>(context);
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    final filteredNotes = _selectedCategory == 'Semua'
        ? noteProvider.notes
        : noteProvider.notes
            .where((element) => element.kategori == _selectedCategory)
            .toList();

    bool isCustomCategorySelected =
        !_mainCategories.contains(_selectedCategory);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showNoteFormDialog(context, noteProvider),
        backgroundColor: AppColors.primary,
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 28),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          // CATEGORY SCROLL FILTER (5 Utama + Tombol "Lainnya...")
          SizedBox(
            height: 46,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _mainCategories.length + 1,
              itemBuilder: (context, index) {
                if (index < _mainCategories.length) {
                  final cat = _mainCategories[index];
                  final isSelected = _selectedCategory == cat;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedCategory = cat;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary
                            : (isDarkMode ? theme.cardColor : Colors.white),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isSelected
                              ? Colors.transparent
                              : (isDarkMode
                                  ? Colors.white10
                                  : Colors.grey.shade200),
                          width: 1.2,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: AppColors.primary.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                )
                              ]
                            : [
                                BoxShadow(
                                  color: Colors.black
                                      .withOpacity(isDarkMode ? 0.05 : 0.02),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                )
                              ],
                      ),
                      child: Text(
                        cat,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.w600,
                          color: isSelected
                              ? Colors.white
                              : (isDarkMode
                                  ? Colors.grey.shade300
                                  : Colors.blueGrey.shade700),
                        ),
                      ),
                    ),
                  );
                } else {
                  // Tombol "Lainnya..." / Kategori Kustom di Ujung
                  return GestureDetector(
                    onTap: () => _showAllCategoriesDialog(context),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isCustomCategorySelected
                            ? AppColors.primary
                            : (isDarkMode ? theme.cardColor : Colors.white),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isCustomCategorySelected
                              ? Colors.transparent
                              : (isDarkMode
                                  ? Colors.white10
                                  : Colors.grey.shade200),
                          width: 1.2,
                        ),
                        boxShadow: isCustomCategorySelected
                            ? [
                                BoxShadow(
                                  color: AppColors.primary.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                )
                              ]
                            : [
                                BoxShadow(
                                  color: Colors.black
                                      .withOpacity(isDarkMode ? 0.05 : 0.02),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                )
                              ],
                      ),
                      child: Row(
                        children: [
                          Text(
                            isCustomCategorySelected
                                ? _selectedCategory
                                : 'Lainnya...',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: isCustomCategorySelected
                                  ? FontWeight.bold
                                  : FontWeight.w600,
                              color: isCustomCategorySelected
                                  ? Colors.white
                                  : (isDarkMode
                                      ? Colors.grey.shade300
                                      : Colors.blueGrey.shade700),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.arrow_drop_down_rounded,
                            size: 20,
                            color: isCustomCategorySelected
                                ? Colors.white
                                : (isDarkMode
                                    ? Colors.grey.shade300
                                    : Colors.blueGrey.shade700),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              },
            ),
          ),
          const SizedBox(height: 16),
          // DAFTAR CATATAN
          Expanded(
            child: filteredNotes.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(28),
                          decoration: BoxDecoration(
                            color: isDarkMode
                                ? Colors.white.withOpacity(0.04)
                                : Colors.grey.withOpacity(0.06),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.note_alt_outlined,
                            size: 56,
                            color: isDarkMode
                                ? Colors.white38
                                : Colors.grey.shade400,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Belum Ada Catatan',
                          style: TextStyle(
                            color: theme.textTheme.titleLarge?.color,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _selectedCategory == 'Semua'
                              ? 'Ketuk tombol "+ Catatan" di bawah untuk mulai.'
                              : 'Tidak ada catatan pada kategori $_selectedCategory.',
                          style: TextStyle(
                            color: isDarkMode
                                ? Colors.grey.shade400
                                : Colors.grey.shade500,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 88),
                    itemCount: filteredNotes.length,
                    itemBuilder: (context, index) {
                      final note = filteredNotes[index];
                      final fDate =
                          DateFormat('dd MMM yyyy').format(note.tanggal);
                      final categoryColor =
                          _getCategoryColor(note.kategori, isDarkMode);

                      return Container(
                        margin: const EdgeInsets.only(bottom: 14),
                        decoration: BoxDecoration(
                          color: theme.cardColor,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: isDarkMode
                              ? null
                              : [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.04),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(18),
                          child: InkWell(
                            onTap: () => _showNoteDetailSheet(
                                context, note, noteProvider),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  left: BorderSide(
                                      color: categoryColor, width: 5),
                                ),
                              ),
                              child: CustomCard(
                                padding: const EdgeInsets.all(18),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 4),
                                          decoration: BoxDecoration(
                                            color:
                                                categoryColor.withOpacity(0.12),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            note.kategori,
                                            style: TextStyle(
                                              fontSize: 10.5,
                                              fontWeight: FontWeight.bold,
                                              color: categoryColor,
                                            ),
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Icon(Icons.calendar_today_rounded,
                                                size: 12,
                                                color: isDarkMode
                                                    ? Colors.grey.shade400
                                                    : Colors.grey),
                                            const SizedBox(width: 6),
                                            Text(
                                              fDate,
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: isDarkMode
                                                    ? Colors.grey.shade400
                                                    : Colors.grey,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      note.judul,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        height: 1.3,
                                        color:
                                            theme.textTheme.titleLarge?.color,
                                      ),
                                    ),
                                    const SizedBox(height: 0),
                                    Text(
                                      note.isiCatatan,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: isDarkMode
                                            ? Colors.grey.shade300
                                            : Colors.grey.shade700,
                                        height: 1.4,
                                      ),
                                    ),
                                    const SizedBox(height: 0),
                                    Divider(
                                        height: 16,
                                        thickness: 0.6,
                                        color: theme.dividerColor),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        TextButton.icon(
                                          onPressed: () => _triggerAISummarize(
                                              context, note),
                                          style: TextButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 6),
                                            backgroundColor: AppColors.accent
                                                .withOpacity(0.1),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                          icon: const Icon(
                                              Icons.auto_awesome_rounded,
                                              size: 16,
                                              color: AppColors.accent),
                                          label: const Text(
                                            'Rangkum AI',
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.accent,
                                            ),
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            IconButton(
                                              onPressed: () =>
                                                  _showNoteFormDialog(
                                                      context, noteProvider,
                                                      noteToEdit: note),
                                              icon: const Icon(
                                                Icons.edit_rounded,
                                                color: AppColors.primary,
                                                size: 20,
                                              ),
                                              padding: EdgeInsets.zero,
                                              constraints:
                                                  const BoxConstraints(),
                                            ),
                                            const SizedBox(width: 14),
                                            IconButton(
                                              onPressed: () => noteProvider
                                                  .deleteNote(note.id),
                                              icon: const Icon(
                                                Icons.delete_outline_rounded,
                                                color: Colors.redAccent,
                                                size: 20,
                                              ),
                                              padding: EdgeInsets.zero,
                                              constraints:
                                                  const BoxConstraints(),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
