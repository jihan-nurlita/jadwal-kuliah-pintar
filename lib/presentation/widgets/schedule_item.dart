import 'package:flutter/material.dart';
import '../../data/models/schedule_model.dart';
import 'custom_card.dart';
import '../../core/constants/app_colors.dart';

class ScheduleItem extends StatelessWidget {
  final ScheduleModel schedule;
  final VoidCallback? onDelete;
  final VoidCallback? onTap;

  const ScheduleItem({
    super.key,
    required this.schedule,
    this.onDelete,
    this.onTap,
  });

  // Fungsi helper untuk memaksa format 24 jam (00:00)
  String _formatTime24(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Warna teks yang kontras dan jelas terbaca di kedua mode
    final primaryTextColor = isDarkMode ? Colors.white : Colors.black87;
    final secondaryTextColor =
        isDarkMode ? Colors.grey.shade300 : Colors.grey.shade700;

    return CustomCard(
      onTap: onTap,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Badge Hari
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  schedule.hari,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              if (onDelete != null)
                IconButton(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete_outline_rounded,
                      color: Colors.redAccent, size: 20),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                )
            ],
          ),
          const SizedBox(height: 12),

          // Nama Mata Kuliah
          Text(
            schedule.namaMatkul,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: primaryTextColor,
            ),
          ),
          const SizedBox(height: 1),

          // Nama Dosen
          Text(
            'Dosen: ${schedule.dosen}',
            style: TextStyle(
              fontSize: 12,
              color: secondaryTextColor,
              fontWeight: FontWeight.w400,
            ),
          ),

          Divider(
            height: 24,
            thickness: 1,
            color: isDarkMode
                ? Colors.white.withOpacity(0.15)
                : Colors.grey.shade300,
          ),

          // Informasi Ruangan & Waktu
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Ruangan
              Row(
                children: [
                  Icon(Icons.domain_outlined,
                      size: 16, color: secondaryTextColor),
                  const SizedBox(width: 6),
                  Text(
                    schedule.ruangan,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: secondaryTextColor,
                    ),
                  ),
                ],
              ),

              // Waktu Mulai - Selesai
              Row(
                children: [
                  const Icon(Icons.access_time_rounded,
                      size: 16, color: AppColors.primary),
                  const SizedBox(width: 6),
                  Text(
                    '${_formatTime24(schedule.mulai)} - ${_formatTime24(schedule.selesai)}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
