class Validators {
  static String? required(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return "$fieldName tidak boleh kosong";
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return "Password tidak boleh kosong";
    }
    if (value.length < 6) {
      return "Password minimal 6 karakter";
    }
    return null;
  }

  /// NISN (10 digit)
  static String? nisn(String? value) {
    if (value == null || value.isEmpty) {
      return "NISN tidak boleh kosong";
    }
    if (value.length < 10) {
      return "NISN minimal 10 digit";
    }
    return null;
  }
}
