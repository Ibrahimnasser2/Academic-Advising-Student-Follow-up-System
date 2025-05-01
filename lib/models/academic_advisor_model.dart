class AdvisorModel {
  final String id;
  final String name;
  final String phone;
  final String email;
  final String password;
  final List<String> assignedStudents; // قائمة برقم الجامعي للطلاب المخصصين

  AdvisorModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.password,
    this.assignedStudents = const [],
  });

  factory AdvisorModel.fromMap(Map<String, dynamic> map) {
    return AdvisorModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      assignedStudents: List<String>.from(map['assignedStudents'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'password': password,
      'assignedStudents': assignedStudents,
    };
  }
}