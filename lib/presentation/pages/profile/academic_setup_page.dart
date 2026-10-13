import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text.dart';

class AcademicSetupPage extends StatefulWidget {
  const AcademicSetupPage({super.key});

  @override
  State<AcademicSetupPage> createState() => _AcademicSetupPageState();
}

class _AcademicSetupPageState extends State<AcademicSetupPage> {
  final _formKey = GlobalKey<FormState>();
  final _nimController = TextEditingController();
  final _prodiController = TextEditingController();
  final _fakultasController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _nimController.dispose();
    _prodiController.dispose();
    _fakultasController.dispose();
    super.dispose();
  }

  Future<void> _saveAcademicData() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_nim', _nimController.text.trim());
    await prefs.setString('user_prodi', _prodiController.text.trim());
    await prefs.setString('user_fakultas', _fakultasController.text.trim());
    await prefs.setBool('is_profile_completed', true);

    setState(() => _isLoading = false);

    if (mounted) {
      context.go('/dashboard');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(
                    Icons.school_rounded,
                    size: 64,
                    color: AppColors.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Setup Profil Akademik',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.headingLarge.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Lengkapi data diri akademik untuk personalisasi perkuliahanmu!',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                  const SizedBox(height: 36),

                  // Input NIM / ID Mahasiswa
                  TextFormField(
                    controller: _nimController,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'NIM tidak boleh kosong';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'NIM / ID Mahasiswa',
                      hintText: 'Contoh: 2201010082',
                      prefixIcon: const Icon(Icons.badge_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Input Program Studi
                  TextFormField(
                    controller: _prodiController,
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Program studi tidak boleh kosong';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Program Studi',
                      hintText: 'Contoh: S1 Teknik Informatika',
                      prefixIcon: const Icon(Icons.school_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Input Fakultas
                  TextFormField(
                    controller: _fakultasController,
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Fakultas tidak boleh kosong';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Fakultas',
                      hintText: 'Contoh: Fakultas Ilmu Komputer',
                      prefixIcon: const Icon(Icons.account_balance_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Button Simpan & Lanjutkan
                  ElevatedButton(
                    onPressed: _isLoading ? null : _saveAcademicData,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ).copyWith(
                      elevation: ButtonStyleButton.allOrNull(4),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Simpan & Lanjutkan',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
