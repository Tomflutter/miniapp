import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:miniapp/data/student_model.dart';
import 'package:miniapp/presentation/student/student_bloc.dart';
import 'package:miniapp/presentation/student/student_event.dart';
import 'package:miniapp/theme/theme_bloc.dart';
import 'package:miniapp/theme/theme_state.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _nisnController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();

  String? _selectedMajor;

  final List<String> _majors = ['IPA', 'IPS', 'RPL', 'TKJ', 'MM'];

  @override
  void dispose() {
    _nameController.dispose();
    _nisnController.dispose();
    _birthDateController.dispose();
    super.dispose();
  }

  Future<void> _selectBirthDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2005),
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      _birthDateController.text =
          "${picked.day.toString().padLeft(2, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.year}";
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      if (_selectedMajor == null) {
        _showErrorSnackbar("Silakan pilih jurusan");
        return;
      }

      final student = StudentModel(
        name: _nameController.text.trim(),
        nisn: _nisnController.text.trim(),
        birthDate: _birthDateController.text.trim(),
        major: _selectedMajor!,
      );

      context.read<StudentBloc>().add(AddStudent(student));

      _showSuccessSnackbar("Siswa berhasil didaftarkan");

      Future.delayed(const Duration(milliseconds: 800), () {
        Navigator.pop(context);
      });
    }
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        return Scaffold(
          backgroundColor: isDarkMode ? Colors.grey[900] : Colors.grey[50],
          appBar: AppBar(
            title: Text(
              "Pendaftaran Siswa",
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 20,
                color: isDarkMode ? Colors.white : Colors.grey[800],
              ),
            ),
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_rounded,
                color: isDarkMode ? Colors.white : Colors.grey[800],
              ),
              onPressed: () => Navigator.pop(context),
            ),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Section
                Container(
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.only(bottom: 32),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        theme.primaryColor,
                        theme.primaryColor.withOpacity(0.8),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: theme.primaryColor.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.person_add_alt_1,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Daftarkan Siswa Baru",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Isi form berikut dengan data lengkap",
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Form Section
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _buildModernTextField(
                        label: "Nama Lengkap",
                        controller: _nameController,
                        icon: Icons.person_outline,
                        isDarkMode: isDarkMode,
                        validator: (value) => value == null || value.isEmpty
                            ? "Nama tidak boleh kosong"
                            : null,
                      ),
                      const SizedBox(height: 20),

                      _buildModernTextField(
                        label: "NISN",
                        controller: _nisnController,
                        icon: Icons.badge_outlined,
                        keyboardType: TextInputType.number,
                        isDarkMode: isDarkMode,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "NISN tidak boleh kosong";
                          }
                          if (value.length < 10) {
                            return "NISN minimal 10 digit";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      _buildDateField(
                        label: "Tanggal Lahir",
                        controller: _birthDateController,
                        onTap: _selectBirthDate,
                        isDarkMode: isDarkMode,
                        validator: (value) => value == null || value.isEmpty
                            ? "Tanggal lahir wajib diisi"
                            : null,
                      ),
                      const SizedBox(height: 20),

                      _buildModernDropdown(
                        label: "Jurusan",
                        value: _selectedMajor,
                        items: _majors,
                        onChanged: (value) {
                          setState(() {
                            _selectedMajor = value;
                          });
                        },
                        isDarkMode: isDarkMode,
                        validator: (value) =>
                            value == null ? "Jurusan wajib dipilih" : null,
                      ),
                      const SizedBox(height: 40),

                      // Submit Button
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: LinearGradient(
                            colors: [
                              theme.primaryColor,
                              theme.primaryColor.withOpacity(0.9),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: theme.primaryColor.withOpacity(0.4),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(16),
                          child: InkWell(
                            onTap: _submit,
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                vertical: 18,
                                horizontal: 24,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.save_alt_rounded,
                                    color: Colors.white,
                                    size: 22,
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    "SIMPAN DATA SISWA",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildModernTextField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    bool isDarkMode = false,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            label,
            style: TextStyle(
              color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.grey[800] : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: isDarkMode
                    ? Colors.black.withOpacity(0.1)
                    : Colors.grey[200]!,
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Icon(
                  icon,
                  color: isDarkMode ? Colors.grey[400] : Colors.grey[500],
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  controller: controller,
                  keyboardType: keyboardType,
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.grey[800],
                    fontSize: 16,
                  ),
                  decoration: InputDecoration(
                    hintText: "Masukkan $label",
                    hintStyle: TextStyle(
                      color: isDarkMode ? Colors.grey[500] : Colors.grey[400],
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 18),
                  ),
                  validator: validator,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDateField({
    required String label,
    required TextEditingController controller,
    required VoidCallback onTap,
    bool isDarkMode = false,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            label,
            style: TextStyle(
              color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.grey[800] : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: isDarkMode
                    ? Colors.black.withOpacity(0.1)
                    : Colors.grey[200]!,
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Icon(
                  Icons.calendar_today_outlined,
                  color: isDarkMode ? Colors.grey[400] : Colors.grey[500],
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  controller: controller,
                  readOnly: true,
                  onTap: onTap,
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.grey[800],
                    fontSize: 16,
                  ),
                  decoration: InputDecoration(
                    hintText: "Pilih tanggal lahir",
                    hintStyle: TextStyle(
                      color: isDarkMode ? Colors.grey[500] : Colors.grey[400],
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 18),
                  ),
                  validator: validator,
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.arrow_drop_down_rounded,
                  color: isDarkMode ? Colors.grey[400] : Colors.grey[500],
                  size: 28,
                ),
                onPressed: onTap,
              ),
              const SizedBox(width: 8),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildModernDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
    bool isDarkMode = false,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            label,
            style: TextStyle(
              color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.grey[800] : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: isDarkMode
                    ? Colors.black.withOpacity(0.1)
                    : Colors.grey[200]!,
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: DropdownButtonFormField<String>(
              value: value,
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 4),
              ),
              icon: Icon(
                Icons.arrow_drop_down_rounded,
                color: isDarkMode ? Colors.grey[400] : Colors.grey[500],
                size: 28,
              ),
              dropdownColor: isDarkMode ? Colors.grey[800] : Colors.white,
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.grey[800],
                fontSize: 16,
              ),
              items: items.map((major) {
                return DropdownMenuItem<String>(
                  value: major,
                  child: Row(
                    children: [
                      Icon(
                        _getMajorIcon(major),
                        color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Text(major),
                    ],
                  ),
                );
              }).toList(),
              onChanged: onChanged,
              validator: validator,
              hint: Text(
                "Pilih jurusan",
                style: TextStyle(
                  color: isDarkMode ? Colors.grey[500] : Colors.grey[400],
                ),
              ),
              isExpanded: true,
            ),
          ),
        ),
      ],
    );
  }

  IconData _getMajorIcon(String major) {
    switch (major) {
      case 'IPA':
        return Icons.science;
      case 'IPS':
        return Icons.public;
      case 'RPL':
        return Icons.code;
      case 'TKJ':
        return Icons.computer;
      case 'MM':
        return Icons.design_services;
      default:
        return Icons.school;
    }
  }
}
