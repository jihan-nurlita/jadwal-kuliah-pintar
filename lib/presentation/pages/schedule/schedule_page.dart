import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/models/schedule_model.dart';
import '../../../providers/schedule_provider.dart';
import '../../widgets/schedule_item.dart';
import '../../../core/constants/app_colors.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  final TextEditingController _searchController = TextEditingController();

  late String _selectedDayFilter;
  final List<String> _days = [
    'Semua',
    'Senin',
    'Selasa',
    'Rabu',
    'Kamis',
    'Jumat',
    'Sabtu',
    'Minggu'
  ];

  @override
  void initState() {
    super.initState();
    _selectedDayFilter = _getTodayName();
  }

  String _getTodayName() {
    final int weekday = DateTime.now().weekday;
    switch (weekday) {
      case 1:
        return 'Senin';
      case 2:
        return 'Selasa';
      case 3:
        return 'Rabu';
      case 4:
        return 'Kamis';
      case 5:
        return 'Jumat';
      case 6:
        return 'Sabtu';
      case 7:
        return 'Minggu';
      default:
        return 'Senin';
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Fungsi helper untuk memaksa format 24 jam (00:00)
  String _formatTime24(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  void _showAddScheduleDialog(BuildContext context, ScheduleProvider provider) {
    final formKey = GlobalKey<FormState>();
    String namaMatkul = '';
    String dosen = '';
    String ruangan = '';
    String hari = 'Senin';

    // Diatur default menjadi 00:00 agar user dapat mengaturnya secara manual
    TimeOfDay mulai = const TimeOfDay(hour: 0, minute: 0);
    TimeOfDay selesai = const TimeOfDay(hour: 0, minute: 0);

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

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
                    Icon(Icons.calendar_today_rounded,
                        color: Colors.white, size: 24),
                    SizedBox(width: 12),
                    Text(
                      'Tambah Jadwal Kuliah',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              content: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 20),
                      TextFormField(
                        style: TextStyle(
                            color: dialogTheme.textTheme.bodyLarge?.color),
                        decoration: InputDecoration(
                          labelText: 'Nama Mata Kuliah',
                          labelStyle: TextStyle(color: dialogTheme.hintColor),
                          prefixIcon: const Icon(Icons.book_rounded,
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
                            ? 'Harap isi nama matkul'
                            : null,
                        onSaved: (v) => namaMatkul = v!.trim(),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        style: TextStyle(
                            color: dialogTheme.textTheme.bodyLarge?.color),
                        decoration: InputDecoration(
                          labelText: 'Dosen Pengampu',
                          labelStyle: TextStyle(color: dialogTheme.hintColor),
                          prefixIcon: const Icon(Icons.person_rounded,
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
                            ? 'Harap isi nama dosen'
                            : null,
                        onSaved: (v) => dosen = v!.trim(),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        style: TextStyle(
                            color: dialogTheme.textTheme.bodyLarge?.color),
                        decoration: InputDecoration(
                          labelText: 'Ruangan Kelas / Lab',
                          labelStyle: TextStyle(color: dialogTheme.hintColor),
                          prefixIcon: const Icon(Icons.room_rounded,
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
                            ? 'Harap isi ruangan'
                            : null,
                        onSaved: (v) => ruangan = v!.trim(),
                      ),
                      const SizedBox(height: 16),

                      // PEMILIH JAM MULAI & SELESAI (00:00)
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () async {
                                final picked = await showTimePicker(
                                  context: dialogContext,
                                  initialTime: mulai,
                                );
                                if (picked != null) {
                                  setDialogState(() => mulai = picked);
                                }
                              },
                              borderRadius: BorderRadius.circular(14),
                              child: InputDecorator(
                                decoration: InputDecoration(
                                  labelText: 'Jam Mulai',
                                  labelStyle:
                                      TextStyle(color: dialogTheme.hintColor),
                                  prefixIcon: const Icon(
                                      Icons.access_time_rounded,
                                      color: AppColors.primary,
                                      size: 20),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(14)),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: BorderSide(
                                      color: isDarkMode
                                          ? Colors.white24
                                          : Colors.grey.shade400,
                                    ),
                                  ),
                                  filled: true,
                                  fillColor: isDarkMode
                                      ? Colors.white.withOpacity(0.05)
                                      : Colors.grey.withOpacity(0.04),
                                ),
                                child: Text(
                                  _formatTime24(mulai),
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color:
                                        dialogTheme.textTheme.bodyLarge?.color,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: InkWell(
                              onTap: () async {
                                final picked = await showTimePicker(
                                  context: dialogContext,
                                  initialTime: selesai,
                                );
                                if (picked != null) {
                                  setDialogState(() => selesai = picked);
                                }
                              },
                              borderRadius: BorderRadius.circular(14),
                              child: InputDecorator(
                                decoration: InputDecoration(
                                  labelText: 'Jam Selesai',
                                  labelStyle:
                                      TextStyle(color: dialogTheme.hintColor),
                                  prefixIcon: const Icon(
                                      Icons.access_time_filled_rounded,
                                      color: AppColors.primary,
                                      size: 20),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(14)),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: BorderSide(
                                      color: isDarkMode
                                          ? Colors.white24
                                          : Colors.grey.shade400,
                                    ),
                                  ),
                                  filled: true,
                                  fillColor: isDarkMode
                                      ? Colors.white.withOpacity(0.05)
                                      : Colors.grey.withOpacity(0.04),
                                ),
                                child: Text(
                                  _formatTime24(selesai),
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color:
                                        dialogTheme.textTheme.bodyLarge?.color,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // DROPDOWN HARI
                      DropdownButtonFormField<String>(
                        value: hari,
                        dropdownColor: dialogTheme.scaffoldBackgroundColor,
                        style: TextStyle(
                            color: dialogTheme.textTheme.bodyLarge?.color),
                        decoration: InputDecoration(
                          labelText: 'Hari',
                          labelStyle: TextStyle(color: dialogTheme.hintColor),
                          prefixIcon: const Icon(Icons.today_rounded,
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
                        items: [
                          'Senin',
                          'Selasa',
                          'Rabu',
                          'Kamis',
                          'Jumat',
                          'Sabtu',
                          'Minggu'
                        ]
                            .map((d) => DropdownMenuItem(
                                  value: d,
                                  child: Text(d,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ))
                            .toList(),
                        onChanged: (v) {
                          setDialogState(() {
                            hari = v!;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                    ],
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
                  ),
                  child: const Text('Batal'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      formKey.currentState!.save();
                      final newSchedule = ScheduleModel(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        namaMatkul: namaMatkul,
                        dosen: dosen,
                        ruangan: ruangan,
                        hari: hari,
                        mulai: mulai,
                        selesai: selesai,
                      );

                      final messenger = ScaffoldMessenger.of(context);
                      provider.addSchedule(newSchedule);
                      Navigator.pop(dialogContext);

                      messenger.showSnackBar(
                        SnackBar(
                          content:
                              const Text('Jadwal Kuliah berhasil disimpan!'),
                          backgroundColor: AppColors.success,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Simpan'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheduleProvider = Provider.of<ScheduleProvider>(context);
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    final filteredSchedules = scheduleProvider.schedules.where((schedule) {
      final matchesDay =
          _selectedDayFilter == 'Semua' || schedule.hari == _selectedDayFilter;
      return matchesDay;
    }).toList();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 12.0),
            child: TextField(
              controller: _searchController,
              style: TextStyle(color: theme.textTheme.bodyLarge?.color),
              decoration: InputDecoration(
                hintText: 'Cari matkul atau dosen pengampu...',
                hintStyle: TextStyle(color: theme.hintColor),
                prefixIcon:
                    const Icon(Icons.search_rounded, color: AppColors.primary),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear_rounded,
                            size: 20, color: theme.hintColor),
                        onPressed: () {
                          _searchController.clear();
                          scheduleProvider.setSearchQuery('');
                          setState(() {});
                        },
                      )
                    : null,
                filled: true,
                fillColor: isDarkMode
                    ? Colors.white.withOpacity(0.06)
                    : Colors.grey.withOpacity(0.07),
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide:
                      const BorderSide(color: AppColors.primary, width: 1.5),
                ),
              ),
              onChanged: (val) {
                scheduleProvider.setSearchQuery(val);
                setState(() {});
              },
            ),
          ),
          SizedBox(
            height: 44,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _days.length,
              itemBuilder: (context, index) {
                final day = _days[index];
                final isSelected = _selectedDayFilter == day;

                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary
                          : (isDarkMode
                              ? Colors.white.withOpacity(0.06)
                              : Colors.grey.shade100),
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(0.35),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              )
                            ]
                          : [],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _selectedDayFilter = day;
                          });
                        },
                        borderRadius: BorderRadius.circular(22),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                          child: Center(
                            child: Text(
                              day,
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : (isDarkMode
                                        ? Colors.grey.shade300
                                        : Colors.grey.shade700),
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.w500,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: filteredSchedules.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: isDarkMode
                                ? Colors.white.withOpacity(0.03)
                                : Colors.grey.withOpacity(0.05),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.event_busy_rounded,
                            size: 52,
                            color: isDarkMode
                                ? Colors.white30
                                : Colors.grey.shade400,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Tidak ada jadwal di hari $_selectedDayFilter',
                          style: TextStyle(
                            color: theme.textTheme.titleLarge?.color,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Silakan pilih hari lain atau tambahkan jadwal baru',
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    itemCount: filteredSchedules.length,
                    itemBuilder: (context, index) {
                      final schedule = filteredSchedules[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: ScheduleItem(
                          schedule: schedule,
                          onDelete: () async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                backgroundColor: theme.dialogBackgroundColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                title: const Row(
                                  children: [
                                    Icon(Icons.warning_amber_rounded,
                                        color: Colors.red, size: 24),
                                    SizedBox(width: 10),
                                    Text('Hapus Kelas',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                content: const Text(
                                    'Apakah Anda yakin ingin menghapus kelas ini?'),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                    child: const Text('Batal'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () =>
                                        Navigator.pop(context, true),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red.shade600,
                                      foregroundColor: Colors.white,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    ),
                                    child: const Text('Hapus'),
                                  ),
                                ],
                              ),
                            );
                            if (confirm == true) {
                              scheduleProvider.deleteSchedule(schedule.id);
                            }
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddScheduleDialog(context, scheduleProvider),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 3,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Tambah Jadwal',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}
