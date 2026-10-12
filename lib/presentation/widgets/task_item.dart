import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/models/task_model.dart';
import '../../core/constants/app_colors.dart';
import 'custom_card.dart';

class TaskItem extends StatelessWidget {
  final TaskModel task;
  final ValueChanged<bool?>? onStatusChanged;
  final VoidCallback? onDelete;

  const TaskItem({
    super.key,
    required this.task,
    this.onStatusChanged,
    this.onDelete,
  });

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

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final priorityColor = _getPriorityColor(task.prioritas, isDarkMode);
    final formattedDate =
        DateFormat('dd MMM yyyy', 'id_ID').format(task.deadline);
    final deadlineStatus = _getDeadlineStatus(task.deadline);
    final isOverdue = DateTime.now().isAfter(task.deadline) && !task.selesai;

    // Warna teks yang lebih kontras dan jelas terbaca
    final primaryTextColor = isDarkMode ? Colors.white : Colors.black87;
    final secondaryTextColor =
        isDarkMode ? Colors.grey.shade200 : Colors.grey.shade800;

    return CustomCard(
      padding: EdgeInsets.zero,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                color: task.selesai ? secondaryTextColor : priorityColor,
                width: 4,
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize
                  .min, // Penting agar Column tidak error di emulator
              children: [
                // 1. Baris Atas: Badge Prioritas di Kiri & Status Sisa Hari di Kanan
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Badge Prioritas di Kiri
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: priorityColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        task.prioritas.toUpperCase(),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: priorityColor,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),

                    // Status Sisa Hari (H-x) di Kanan
                    if (!task.selesai)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: isOverdue
                              ? Colors.red.withOpacity(0.15)
                              : (isDarkMode
                                  ? Colors.white.withOpacity(0.1)
                                  : Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          deadlineStatus,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: isOverdue
                                ? Colors.red.shade400
                                : secondaryTextColor,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),

                // 2. Judul Tugas (Tanpa Expanded agar aman dan muncul di emulator)
                Text(
                  task.namaTugas,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    decoration: task.selesai
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                    color: task.selesai ? secondaryTextColor : primaryTextColor,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),

                // 3. Baris Mata Kuliah
                Row(
                  children: [
                    Icon(
                      Icons.book_outlined,
                      size: 13,
                      color: secondaryTextColor,
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        task.namaMatkul,
                        style: TextStyle(
                          fontSize: 12,
                          color: secondaryTextColor,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Divider Pemisah Tipis
                Divider(
                  height: 1,
                  thickness: 1,
                  color: isDarkMode
                      ? Colors.white.withOpacity(0.15)
                      : Colors.grey.shade300,
                ),
                const SizedBox(height: 10),

                // 4. Baris Bawah: Tanggal, Tombol Hapus, & Checkbox di Kanan
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Tanggal Deadline
                    Row(
                      children: [
                        Icon(
                          Icons.event_outlined,
                          size: 13,
                          color: secondaryTextColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Hingga: $formattedDate',
                          style: TextStyle(
                            fontSize: 11,
                            color: secondaryTextColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),

                    // Aksi Bagian Kanan (Tombol Hapus & Checkbox)
                    Row(
                      children: [
                        if (onDelete != null) ...[
                          InkWell(
                            onTap: onDelete,
                            borderRadius: BorderRadius.circular(8),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Icon(
                                Icons.delete_outline_rounded,
                                color: Colors.redAccent.shade200,
                                size: 18,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                        SizedBox(
                          height: 22,
                          width: 22,
                          child: Checkbox(
                            value: task.selesai,
                            onChanged: onStatusChanged,
                            activeColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
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
    );
  }
}
