import 'package:cloud_firestore/cloud_firestore.dart';

class DeanModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String password;

  DeanModel({
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
  factory DeanModel.fromMap(Map<String, dynamic> map) {
    return DeanModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      password: map['password'] ?? '',
    );
  }
}