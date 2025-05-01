

class ManagerModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String password;

  ManagerModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
  });

  // Convert model to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'password': password,
    };
  }

  // Create model from Firestore document
  factory ManagerModel.fromMap(Map<String, dynamic> map) {
    return ManagerModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      password: map['password'] ?? '',
    );
  }

  // Copy with method for easy updates
  ManagerModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? password,
  }) {
    return ManagerModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      password: password ?? this.password,
    );
  }
}