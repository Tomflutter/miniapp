class StudentModel {
  final String name;
  final String nisn;
  final String birthDate;
  final String major;

  StudentModel({
    required this.name,
    required this.nisn,
    required this.birthDate,
    required this.major,
  });

  Map<String, dynamic> toJson() => {
        "name": name,
        "nisn": nisn,
        "birthDate": birthDate,
        "major": major,
      };

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      name: json['name'],
      nisn: json['nisn'],
      birthDate: json['birthDate'],
      major: json['major'],
    );
  }
}
