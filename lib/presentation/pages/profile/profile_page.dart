import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/app_colors.dart';
import '../../../providers/theme_provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  String _userEmail = 'mahasiswa@kampus.ac.id';
  String _userName = 'Mahasiswa';
  String _userNim = '-';
  String _userProdi = 'Belum diisi';
  String _userFakultas = '-';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userEmail = prefs.getString('user_email') ?? 'mahasiswa@kampus.ac.id';
      _userName = prefs.getString('user_name') ?? _userEmail.split('@')[0];
      _userNim = prefs.getString('user_nim') ?? 'Belum diisi';
      _userProdi = prefs.getString('user_prodi') ?? 'Belum diisi';
      _userFakultas = prefs.getString('user_fakultas') ?? 'Belum diisi';
    });
  }

  // Fungsi untuk memilih foto dari Galeri/Album atau Kamera
  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 600,
        maxHeight: 600,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          _profileImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal mengambil gambar: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  // Modal Bottom Sheet untuk Pilihan Sumber Foto
  void _showImagePickerModal() {
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      backgroundColor: theme.scaffoldBackgroundColor,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pilih Foto Profil',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: theme.textTheme.titleLarge?.color,
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.photo_library_rounded,
                      color: AppColors.primary),
                ),
                title: const Text('Pilih dari Album / Galeri',
                    style: TextStyle(fontWeight: FontWeight.w600)),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              const Divider(height: 12),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.camera_alt_rounded,
                      color: AppColors.accent),
                ),
                title: const Text('Ambil Foto dari Kamera',
                    style: TextStyle(fontWeight: FontWeight.w600)),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              if (_profileImage != null) ...[
                const Divider(height: 12),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.redAccent.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.delete_outline_rounded,
                        color: Colors.redAccent),
                  ),
                  title: const Text('Hapus Foto Profil',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.redAccent)),
                  onTap: () {
                    Navigator.pop(context);
                    setState(() {
                      _profileImage = null;
                    });
                  },
                ),
              ]
            ],
          ),
        );
      },
    );
  }

  // Fungsi Logout Akun
  Future<void> _handleLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Konfirmasi Keluar',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text(
            'Apakah Anda yakin ingin keluar dari sesi akun Jadwal Kuliah Pintar saat ini?'),
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
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
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
    final theme = Theme.of(context);
    final themeProv = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProv.isDarkMode;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'Profil Akademik & Pengaturan',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          children: [
            // HEADER PROFIL FORMAL
            Center(
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: 110,
                        height: 110,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.primary,
                            width: 3,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            )
                          ],
                          image: _profileImage != null
                              ? DecorationImage(
                                  image: FileImage(_profileImage!),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: _profileImage == null
                            ? CircleAvatar(
                                backgroundColor: isDarkMode
                                    ? Colors.white.withOpacity(0.08)
                                    : AppColors.primary.withOpacity(0.1),
                                child: const Icon(
                                  Icons.person,
                                  size: 56,
                                  color: AppColors.primary,
                                ),
                              )
                            : null,
                      ),
                      Positioned(
                        bottom: 2,
                        right: 2,
                        child: GestureDetector(
                          onTap: _showImagePickerModal,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 4,
                                )
                              ],
                            ),
                            child: const Icon(
                              Icons.camera_alt_rounded,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _userName,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: theme.textTheme.titleLarge?.color,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _userEmail,
                    style: TextStyle(
                      fontSize: 13,
                      color: isDarkMode
                          ? Colors.grey.shade400
                          : Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border:
                          Border.all(color: AppColors.primary.withOpacity(0.3)),
                    ),
                    child: Text(
                      _userProdi, // <-- Diubah dinamis sesuai input setup
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // SECTION 1: INFORMASI AKADEMIK
            _buildSectionHeader('INFORMASI AKADEMIK', isDarkMode),
            const SizedBox(height: 10),
            _buildCardContainer(
              theme,
              isDarkMode,
              children: [
                _buildInfoTile(
                  icon: Icons.badge_outlined,
                  title: 'NIM / ID Mahasiswa',
                  value: _userNim,
                  theme: theme,
                ),
                const Divider(height: 1, indent: 52),
                _buildInfoTile(
                  icon: Icons.school_outlined,
                  title: 'Program Studi',
                  value: _userProdi,
                  theme: theme,
                ),
                const Divider(height: 1, indent: 52),
                _buildInfoTile(
                  icon: Icons.account_balance_outlined,
                  title: 'Fakultas',
                  value: _userFakultas,
                  theme: theme,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // SECTION 2: PREFERENSI APLIKASI
            _buildSectionHeader('PREFERENSI APLIKASI', isDarkMode),
            const SizedBox(height: 10),
            _buildCardContainer(
              theme,
              isDarkMode,
              children: [
                SwitchListTile(
                  secondary: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.amber.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      isDarkMode
                          ? Icons.dark_mode_rounded
                          : Icons.light_mode_rounded,
                      color: Colors.amber.shade700,
                      size: 20,
                    ),
                  ),
                  title: const Text('Mode Tampilan Gelap',
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                  subtitle: Text(
                    isDarkMode ? 'Mode Gelap Aktif' : 'Mode Terang Aktif',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  ),
                  value: isDarkMode,
                  activeColor: AppColors.primary,
                  onChanged: (val) {
                    themeProv.toggleTheme();
                  },
                ),
                const Divider(height: 1, indent: 52),
                SwitchListTile(
                  secondary: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.notifications_active_outlined,
                        color: Colors.blue, size: 20),
                  ),
                  title: const Text('Notifikasi Pengingat',
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                  subtitle: Text('Pengingat otomatis jadwal & tugas',
                      style:
                          TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                  value: true,
                  activeColor: AppColors.primary,
                  onChanged: (val) {},
                ),
              ],
            ),
            const SizedBox(height: 24),

            // SECTION 3: BANTUAN & INFORMASI
            _buildSectionHeader('INFORMASI & BANTUAN', isDarkMode),
            const SizedBox(height: 10),
            _buildCardContainer(
              theme,
              isDarkMode,
              children: [
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.teal.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.help_outline_rounded,
                        color: Colors.teal, size: 20),
                  ),
                  title: const Text('Pusat Bantuan & Kebijakan',
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                  trailing: const Icon(Icons.chevron_right_rounded,
                      color: Colors.grey),
                  onTap: () {},
                ),
                const Divider(height: 1, indent: 52),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.indigo.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.info_outline_rounded,
                        color: Colors.indigo, size: 20),
                  ),
                  title: const Text('Versi Aplikasi',
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                  subtitle: Text('Smart College Schedule v1.0.0',
                      style:
                          TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // TOMBOL KELUAR AKUN FORMAL
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _handleLogout,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.redAccent,
                  side: const BorderSide(color: Colors.redAccent, width: 1.2),
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                icon: const Icon(Icons.logout_rounded, size: 20),
                label: const Text(
                  'Keluar Sesi Akun',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // Helper Widget Header Section
  Widget _buildSectionHeader(String title, bool isDarkMode) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  // Helper Widget Container Card
  Widget _buildCardContainer(ThemeData theme, bool isDarkMode,
      {required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: isDarkMode
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Column(children: children),
    );
  }

  // Helper Item Informasi Tile
  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String value,
    required ThemeData theme,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.08),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: AppColors.primary, size: 20),
      ),
      title:
          Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      subtitle: Text(
        value,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: theme.textTheme.bodyLarge?.color,
        ),
      ),
    );
  }
}
