import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/models/task_model.dart';
import '../../../providers/task_provider.dart';
import '../../widgets/task_item.dart';
import '../../../core/constants/app_colors.dart';
import 'package:intl/intl.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Color _getPriorityColor(String priority, bool isDarkMode) {
    switch (priority) {
      case 'Tinggi':
        return isDarkMode ? const Color(0xFFEF4444) : const Color(0xFFDC2626);
      case 'Sedang':
        return isDarkMode ? const Color(0xFFF59E0B) : const Color(0xFFD97706);
      case 'Rendah':
      default:
        return isDarkMode ? const Color(0xFF10B981) : const Color(0xFF059669);
    }
  }

  // Fungsi untuk menampilkan Bottom Sheet Detail Tugas saat kartu diklik
  void _showTaskDetailDialog(BuildContext context, TaskModel task) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final formattedDate =
        DateFormat('dd MMMM yyyy', 'id_ID').format(task.deadline);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
              20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getPriorityColor(task.prioritas, isDarkMode)
                          .withOpacity(0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Prioritas: ${task.prioritas}',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: _getPriorityColor(task.prioritas, isDarkMode),
                      ),
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: task.selesai
                          ? AppColors.success.withOpacity(0.12)
                          : AppColors.error.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      task.selesai ? 'Selesai' : 'Aktif',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color:
                            task.selesai ? AppColors.success : AppColors.error,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                task.namaTugas,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(Icons.book_rounded,
                      size: 16, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Text(
                    task.namaMatkul,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isDarkMode
                          ? Colors.grey.shade300
                          : Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.calendar_month_rounded,
                      size: 16, color: Colors.orange),
                  const SizedBox(width: 8),
                  Text(
                    'Deadline: $formattedDate',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 12),
              const Text(
                'Deskripsi / Catatan:',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                task.deskripsi.isNotEmpty
                    ? task.deskripsi
                    : 'Tidak ada deskripsi tambahan.',
                style: TextStyle(
                  fontSize: 14,
                  color: isDarkMode ? Colors.white70 : Colors.black87,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: const Text('Tutup',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAddTaskDialog(BuildContext context) {
    final provider = Provider.of<TaskProvider>(context, listen: false);
    final formKey = GlobalKey<FormState>();
    String namaTugas = '';
    String namaMatkul = '';
    DateTime deadline = DateTime.now().add(const Duration(days: 3));
    String prioritas = 'Sedang';
    String deskripsi = '';
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final formattedDate = DateFormat('dd MMM yyyy').format(deadline);
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
                    Icon(Icons.assignment_add, color: Colors.white, size: 26),
                    SizedBox(width: 12),
                    Text(
                      'Tambah Tugas Baru',
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
                          labelText: 'Nama Tugas / Proyek',
                          labelStyle: TextStyle(color: dialogTheme.hintColor),
                          prefixIcon: const Icon(Icons.task_rounded,
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
                            ? 'Nama tugas tidak boleh kosong'
                            : null,
                        onSaved: (v) => namaTugas = v!.trim(),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        style: TextStyle(
                            color: dialogTheme.textTheme.bodyLarge?.color),
                        decoration: InputDecoration(
                          labelText: 'Mata Kuliah',
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
                            ? 'Mata kuliah tidak boleh kosong'
                            : null,
                        onSaved: (v) => namaMatkul = v!.trim(),
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: prioritas,
                        dropdownColor: dialogTheme.scaffoldBackgroundColor,
                        style: TextStyle(
                            color: dialogTheme.textTheme.bodyLarge?.color),
                        decoration: InputDecoration(
                          labelText: 'Tingkat Prioritas',
                          labelStyle: TextStyle(color: dialogTheme.hintColor),
                          prefixIcon: const Icon(Icons.outlined_flag_rounded,
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
                        items: ['Rendah', 'Sedang', 'Tinggi']
                            .map((p) => DropdownMenuItem(
                                  value: p,
                                  child: Text(
                                    p,
                                    style: TextStyle(
                                      color: _getPriorityColor(p, isDarkMode),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ))
                            .toList(),
                        onChanged: (v) {
                          setDialogState(() {
                            prioritas = v!;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: isDarkMode
                                ? Colors.white24
                                : Colors.grey.shade300,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(14),
                          color: isDarkMode
                              ? Colors.white.withOpacity(0.03)
                              : Colors.grey.withOpacity(0.02),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () async {
                              final date = await showDatePicker(
                                context: dialogContext,
                                initialDate: deadline,
                                firstDate: DateTime.now(),
                                lastDate: DateTime.now()
                                    .add(const Duration(days: 365)),
                                builder: (context, child) {
                                  return Theme(
                                    data: isDarkMode
                                        ? ThemeData.dark().copyWith(
                                            colorScheme: const ColorScheme.dark(
                                              primary: AppColors.primary,
                                              onPrimary: Colors.white,
                                              surface: Color(0xFF1E1E2E),
                                              onSurface: Colors.white,
                                            ),
                                            dialogBackgroundColor:
                                                const Color(0xFF1E1E2E),
                                          )
                                        : ThemeData.light().copyWith(
                                            colorScheme:
                                                const ColorScheme.light(
                                              primary: AppColors.primary,
                                              onPrimary: Colors.white,
                                              surface: Colors.white,
                                              onSurface: Colors.black,
                                            ),
                                            dialogBackgroundColor: Colors.white,
                                          ),
                                    child: child!,
                                  );
                                },
                              );
                              if (date != null) {
                                setDialogState(() {
                                  deadline = date;
                                });
                              }
                            },
                            borderRadius: BorderRadius.circular(14),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              child: Row(
                                children: [
                                  const Icon(Icons.calendar_month_outlined,
                                      color: AppColors.primary, size: 22),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Deadline Pengumpulan',
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: isDarkMode
                                                ? Colors.grey.shade400
                                                : Colors.grey.shade600,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          formattedDate,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            color: dialogTheme
                                                .textTheme.bodyLarge?.color,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        style: TextStyle(
                            color: dialogTheme.textTheme.bodyLarge?.color),
                        decoration: InputDecoration(
                          labelText: 'Deskripsi Tambahan',
                          labelStyle: TextStyle(color: dialogTheme.hintColor),
                          prefixIcon: const Icon(Icons.description_rounded,
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
                        maxLines: 2,
                        onSaved: (v) => deskripsi = (v ?? '').trim(),
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 12),
                  ),
                  child: const Text('Batal',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      formKey.currentState!.save();
                      final newTask = TaskModel(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        namaTugas: namaTugas,
                        namaMatkul: namaMatkul,
                        deadline: deadline,
                        prioritas: prioritas,
                        deskripsi: deskripsi,
                        selesai: false,
                      );

                      final messenger = ScaffoldMessenger.of(context);
                      provider.addTask(newTask);
                      Navigator.pop(dialogContext);

                      messenger.showSnackBar(
                        SnackBar(
                          content: const Row(
                            children: [
                              Icon(Icons.check_circle_rounded,
                                  color: Colors.white),
                              SizedBox(width: 10),
                              Text('Tugas berhasil ditambahkan!',
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
                  child: const Text('Simpan',
                      style: TextStyle(fontWeight: FontWeight.bold)),
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
    final taskProvider = Provider.of<TaskProvider>(context);
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Container(
          decoration: BoxDecoration(
            color: isDarkMode ? theme.cardColor : Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
            border: Border(
              bottom: BorderSide(
                color: isDarkMode
                    ? Colors.white.withOpacity(0.08)
                    : Colors.grey.withOpacity(0.12),
                width: 1,
              ),
            ),
          ),
          child: SafeArea(
            child: TabBar(
              controller: _tabController,
              labelColor: AppColors.primary,
              unselectedLabelColor:
                  isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
              indicatorColor: AppColors.primary,
              indicatorWeight: 3.5,
              indicatorSize: TabBarIndicatorSize.tab,
              labelStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  letterSpacing: 0.3),
              unselectedLabelStyle:
                  const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              tabs: [
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.assignment_rounded, size: 18),
                      const SizedBox(width: 8),
                      Text('Aktif (${taskProvider.activeTasks.length})'),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.task_alt_rounded, size: 18),
                      const SizedBox(width: 8),
                      Text('Selesai (${taskProvider.completedTasks.length})'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTaskList(context, taskProvider.activeTasks, taskProvider),
          _buildTaskList(context, taskProvider.completedTasks, taskProvider),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddTaskDialog(context),
        backgroundColor: AppColors.primary,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        icon: const Icon(Icons.add_rounded, color: Colors.white, size: 24),
        label: const Text(
          'Tambah Tugas',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  Widget _buildTaskList(
      BuildContext context, List<TaskModel> list, TaskProvider provider) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    if (list.isEmpty) {
      return Center(
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? Colors.white10
                        : Colors.grey.withOpacity(0.04),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.assignment_turned_in_outlined,
                    size: 68,
                    color: isDarkMode
                        ? Colors.white30
                        : Colors.grey.withOpacity(0.4),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Tidak ada tugas di kategori ini',
                  style: TextStyle(
                    color: theme.textTheme.titleLarge?.color,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Semua pekerjaan Anda tercatat dengan rapi di sini.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isDarkMode
                        ? Colors.grey.shade400
                        : Colors.grey.shade500,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final task = list[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 14.0),
          child: InkWell(
            onTap: () => _showTaskDetailDialog(context, task),
            borderRadius: BorderRadius.circular(16),
            child: TaskItem(
              task: task,
              onStatusChanged: (val) {
                provider.toggleTaskStatus(task.id);
              },
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
                        Text('Hapus Tugas',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    content: const Text(
                        'Apakah Anda yakin ingin menghapus tugas ini? Tindakan ini tidak dapat dibatalkan.'),
                    actionsPadding: const EdgeInsets.all(16),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        style: TextButton.styleFrom(
                          foregroundColor: isDarkMode
                              ? Colors.grey.shade300
                              : Colors.grey.shade600,
                        ),
                        child: const Text('Batal',
                            style: TextStyle(fontWeight: FontWeight.w600)),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context, true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade600,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        child: const Text('Hapus',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                );
                if (confirm == true) {
                  provider.deleteTask(task.id);
                }
              },
            ),
          ),
        );
      },
    );
  }
}
