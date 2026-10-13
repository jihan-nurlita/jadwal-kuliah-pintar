import 'package:flutter/material.dart';
import 'package:jadwal_kuliah_pintar/presentation/pages/profile/profile_page.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/app_colors.dart';
import '../../../providers/schedule_provider.dart';
import '../../../providers/task_provider.dart';
import '../../../providers/theme_provider.dart';
import '../schedule/schedule_page.dart';
import '../tasks/tasks_page.dart';
import '../calendar/calendar_page.dart';
import '../notes/notes_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _currentTab = 0;
  String _userEmail = 'mahasiswa@kampus.ac.id';
  String _userName = 'Mahasiswa';

  @override
  void initState() {
    super.initState();
    _loadUserEmail();
    _loadUserData();
  }

  Future<void> _loadUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userEmail = prefs.getString('user_email') ?? 'mahasiswa@kampus.ac.id';
    });
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userEmail = prefs.getString('user_email') ?? 'mahasiswa@kampus.ac.id';
      _userName = prefs.getString('user_name') ?? _userEmail.split('@')[0];
    });
  }

  // Fungsi helper untuk memaksa format 24 jam (00:00)
  String _formatTime24(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  // Fungsi helper untuk menghitung status deadline
  String _getDeadlineStatus(DateTime deadline) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(deadline.year, deadline.month, deadline.day);
    final difference = target.difference(today).inDays;

    if (difference < 0) {
      return 'Lewat ${difference.abs()} Hari';
    } else if (difference == 0) {
      return 'Hari Ini';
    } else if (difference == 1) {
      return 'Besok';
    } else {
      return '$difference Hari Lagi';
    }
  }

  Future<void> _handleLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Keluar',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text('Apakah Anda yakin ingin keluar dari aplikasi?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Batal',
              style: TextStyle(
                  color: Colors.grey[600], fontWeight: FontWeight.w600),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Keluar',
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_logged_in', false);
      if (mounted) {
        context.go('/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheduleProv = Provider.of<ScheduleProvider>(context);
    final taskProv = Provider.of<TaskProvider>(context);
    final themeProv = Provider.of<ThemeProvider>(context);

    final List<Widget> pages = [
      _buildHomeOverview(scheduleProv, taskProv),
      const SchedulePage(),
      const TasksPage(),
      const CalendarPage(),
      const NotesPage(),
    ];

    final isDark = themeProv.isDarkMode;

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF121212) : const Color(0xFFF8F9FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        title: Padding(
          padding: const EdgeInsets.only(left: 0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Jadwal Kuliah Pintar',
                style: TextStyle(
                  fontSize: 19,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withOpacity(0.05)
                  : Colors.black.withOpacity(0.03),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(
                Icons.notifications,
                color: isDark ? Colors.white : const Color(0xFF4A5568),
                size: 22,
              ),
              onPressed: () {},
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withOpacity(0.05)
                  : Colors.black.withOpacity(0.03),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(
                Icons.person,
                color: isDark ? Colors.white : const Color(0xFF4A5568),
                size: 22,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfilePage()),
                );
              },
            ),
          ),
        ],
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: pages[_currentTab],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withOpacity(0.3)
                  : Colors.grey.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: NavigationBar(
          elevation: 0,
          backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          selectedIndex: _currentTab,
          height: 72,
          indicatorColor: AppColors.primary.withOpacity(0.12),
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          onDestinationSelected: (index) {
            setState(() {
              _currentTab = index;
            });
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.dashboard_outlined, color: Colors.grey),
              selectedIcon:
                  Icon(Icons.dashboard_rounded, color: AppColors.primary),
              label: 'Beranda',
            ),
            NavigationDestination(
              icon: Icon(Icons.calendar_today_outlined, color: Colors.grey),
              selectedIcon:
                  Icon(Icons.calendar_today_rounded, color: AppColors.primary),
              label: 'Jadwal',
            ),
            NavigationDestination(
              icon: Icon(Icons.task_alt_outlined, color: Colors.grey),
              selectedIcon:
                  Icon(Icons.task_alt_rounded, color: AppColors.primary),
              label: 'Tugas',
            ),
            NavigationDestination(
              icon: Icon(Icons.date_range_outlined, color: Colors.grey),
              selectedIcon:
                  Icon(Icons.date_range_rounded, color: AppColors.primary),
              label: 'Kalender',
            ),
            NavigationDestination(
              icon: Icon(Icons.description_outlined, color: Colors.grey),
              selectedIcon:
                  Icon(Icons.description_rounded, color: AppColors.primary),
              label: 'Catatan',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeOverview(
      ScheduleProvider scheduleProv, TaskProvider taskProv) {
    final activeTasks = taskProv.activeTasks;
    final totalSchedules = scheduleProv.schedules.length;
    final totalTasks = taskProv.tasks.length;
    final completedCount = taskProv.completedTasks.length;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final progress = totalTasks > 0 ? (completedCount / totalTasks) : 0.0;
    final today = DateTime.now();
    final todaysSchedules = scheduleProv.getSchedulesByDate(today);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20.0, 1.0, 20.0, 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Halo, $_userName',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : const Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 20),

          // CARD PROGRESS UTAMA
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark
                      ? [
                          AppColors.primary.withOpacity(0.8),
                          const Color(0xFF312E81)
                        ]
                      : [AppColors.primary, const Color(0xFF4F46E5)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  )
                ]),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Penyelesaian Tugas Yuk!',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '$completedCount Selesai dari $totalTasks tugas kuliah.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.85),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Stack(
                        children: [
                          Container(
                            height: 8,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 500),
                            height: 8,
                            width: MediaQuery.of(context).size.width *
                                0.45 *
                                progress,
                            decoration: BoxDecoration(
                                color: AppColors.success,
                                borderRadius: BorderRadius.circular(4),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.success.withOpacity(0.5),
                                    blurRadius: 6,
                                  )
                                ]),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 64,
                      height: 64,
                      child: CircularProgressIndicator(
                        value: progress,
                        backgroundColor: Colors.white.withOpacity(0.15),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                            AppColors.success),
                        strokeWidth: 6,
                        strokeCap: StrokeCap.round,
                      ),
                    ),
                    Text(
                      '${(progress * 100).toInt()}%',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          const SizedBox(height: 28),

          // BENTO STATISTICS CARD SYSTEM SECTION
          _buildSectionHeader(
            title: 'Statistik Semester',
            isDark: isDark,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildEnhancedTile(
                  title: 'Jumlah Matkul',
                  value: '$totalSchedules',
                  icon: Icons.school_rounded,
                  color: AppColors.primary,
                  isDark: isDark,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildEnhancedTile(
                  title: 'Deadline Tugas',
                  value: '${activeTasks.length}',
                  icon: Icons.assignment_late_rounded,
                  color: AppColors.accent,
                  isDark: isDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),

          // JADWAL HARI INI SECTION
          _buildSectionHeader(
            title: 'Jadwal Kuliah Hari Ini',
            isDark: isDark,
            onActionPressed: () => setState(() => _currentTab = 1),
          ),
          const SizedBox(height: 12),
          todaysSchedules.isEmpty
              ? _buildEmptyState(
                  message: 'Tidak ada jadwal kuliah untuk hari ini. 🎉',
                  icon: Icons.auto_stories_outlined,
                  isDark: isDark,
                )
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount:
                      todaysSchedules.length > 2 ? 2 : todaysSchedules.length,
                  itemBuilder: (context, index) {
                    final sch = todaysSchedules[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color:
                                Colors.black.withOpacity(isDark ? 0.2 : 0.03),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            height: 44,
                            width: 44,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.import_contacts_rounded,
                                color: AppColors.primary, size: 22),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  sch.namaMatkul,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: isDark
                                        ? Colors.white
                                        : const Color(0xFF2D3748),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(Icons.account_balance_outlined,
                                        size: 12, color: Colors.grey[500]),
                                    const SizedBox(width: 4),
                                    Text(
                                      sch.ruangan,
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[500]),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '${_formatTime24(sch.mulai)}\n${_formatTime24(sch.selesai)}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                              fontSize: 14,
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
          const SizedBox(height: 20),

          // DEADLINE TERDEKAT SECTION
          _buildSectionHeader(
            title: 'Deadline Tugas Terdekat',
            isDark: isDark,
            onActionPressed: () => setState(() => _currentTab = 2),
          ),
          const SizedBox(height: 12),
          activeTasks.isEmpty
              ? _buildEmptyState(
                  message: 'Keren! Semua tugasmu sudah selesai. 🎉',
                  icon: Icons.task_alt_rounded,
                  isDark: isDark,
                )
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: activeTasks.length > 2 ? 2 : activeTasks.length,
                  itemBuilder: (context, index) {
                    final tsk = activeTasks[index];
                    final deadlineStatus = _getDeadlineStatus(tsk.deadline);
                    final isOverdue = DateTime.now().isAfter(tsk.deadline);

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color:
                                Colors.black.withOpacity(isDark ? 0.2 : 0.03),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            height: 44,
                            width: 44,
                            decoration: BoxDecoration(
                              color: AppColors.accent.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.assignment_rounded,
                                color: AppColors.accent, size: 22),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  tsk.namaTugas,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: isDark
                                        ? Colors.white
                                        : const Color(0xFF2D3748),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  tsk.namaMatkul,
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.grey[500]),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: isOverdue
                                  ? AppColors.error.withOpacity(0.1)
                                  : (isDark
                                      ? Colors.white.withOpacity(0.1)
                                      : Colors.grey.shade200),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              deadlineStatus,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: isOverdue
                                    ? AppColors.error
                                    : (isDark
                                        ? Colors.grey.shade300
                                        : Colors.grey.shade700),
                                letterSpacing: 0.5,
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(
      {required String title,
      required bool isDark,
      VoidCallback? onActionPressed}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.3,
            color: isDark
                ? Colors.white.withOpacity(0.9)
                : const Color(0xFF2D3748),
          ),
        ),
        if (onActionPressed != null)
          TextButton(
            onPressed: onActionPressed,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text(
              'Lihat Semua',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          )
      ],
    );
  }

  Widget _buildEnhancedTile({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.02),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : const Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[500],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(
      {required String message, required IconData icon, required bool isDark}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF1E1E1E).withOpacity(0.5)
            : Colors.grey.withOpacity(0.03),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.05)
              : Colors.black.withOpacity(0.03),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.grey[400], size: 36),
          const SizedBox(height: 12),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.grey[500],
                fontSize: 13,
                fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
