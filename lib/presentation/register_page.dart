import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:miniapp/data/student_model.dart';
import 'package:miniapp/presentation/student/student_bloc.dart';
import 'package:miniapp/presentation/student/student_event.dart';

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

  final List<String> _majors = [
    'IPA',
    'IPS',
    'RPL',
    'TKJ',
    'MM',
  ];

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
          "${picked.day}-${picked.month}-${picked.year}";
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      if (_selectedMajor == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Silakan pilih jurusan")),
        );
        return;
      }

      final student = StudentModel(
        name: _nameController.text.trim(),
        nisn: _nisnController.text.trim(),
        birthDate: _birthDateController.text.trim(),
        major: _selectedMajor!,
      );

      context.read<StudentBloc>().add(AddStudent(student));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Siswa berhasil didaftarkan")),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pendaftaran Siswa"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: "Nama Lengkap",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty
                        ? "Nama tidak boleh kosong"
                        : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _nisnController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "NISN",
                  border: OutlineInputBorder(),
                ),
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
              const SizedBox(height: 16),

              TextFormField(
                controller: _birthDateController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: "Tanggal Lahir",
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                onTap: _selectBirthDate,
                validator: (value) =>
                    value == null || value.isEmpty
                        ? "Tanggal lahir wajib diisi"
                        : null,
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: _selectedMajor,
                decoration: const InputDecoration(
                  labelText: "Jurusan",
                  border: OutlineInputBorder(),
                ),
                items: _majors
                    .map(
                      (major) => DropdownMenuItem(
                        value: major,
                        child: Text(major),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedMajor = value;
                  });
                },
                validator: (value) =>
                    value == null ? "Jurusan wajib dipilih" : null,
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _submit,
                  child: const Text("SIMPAN"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
