class StudentModel {
  final String id;

  final String name;
  final String universityId;
  final String phone;
  final String major;
  final double gpa;
  final String status;
  final int warnings;
  final int failures;
  final String advisoremail; // رقم الجامعي للمرشد الأكاديمي
  final String email;
  final String password;

  StudentModel({

    required this.id,
    required this.name,
    required this.universityId,
    required this.phone,
    required this.major,
    required this.gpa,
    required this.status,
    required this.warnings,
    required this.failures,
    required this.advisoremail,
    required this.email,
    required this.password,
  });

  factory StudentModel.fromMap(Map<String, dynamic> map) {
    return StudentModel(

      id: map['id'] ?? '',
      name: map['name'] ?? '',
      universityId: map['universityId'] ?? '',
      phone: map['phone'] ?? '',
      major: map['major'] ?? '',
      gpa: map['gpa']?.toDouble() ?? 0.0,
      status: map['status'] ?? 'منتظم',
      warnings: map['warnings']?.toInt() ?? 0,
      failures: map['failures']?.toInt() ?? 0,
      advisoremail: map['advisoremail'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'universityId': universityId,
      'phone': phone,
      'major': major,
      'gpa': gpa,
      'status': status,
      'warnings': warnings,
      'failures': failures,
      'advisoremail': advisoremail,
      'email': email,
      'password': password,
    };
  }
}