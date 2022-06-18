import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String authenticatedBy;
  String createdAt;
  String email;
  String joinedAt;
  String id;
  String name;

  UserModel({
    this.authenticatedBy,
    this.createdAt,
    this.email,
    this.joinedAt,
    this.id,
    this.name,
  });

  factory UserModel.fromDocument(QueryDocumentSnapshot queryDocumentSnapshot) {
    return UserModel(
      authenticatedBy: queryDocumentSnapshot.get('authenticatedBy'),
      createdAt: queryDocumentSnapshot.get('createdAt'),
      email: queryDocumentSnapshot.get('email'),
      joinedAt: queryDocumentSnapshot.get('joinedAt'),
      id: queryDocumentSnapshot.get('id'),
      name: queryDocumentSnapshot.get('name'),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'authenticatedBy': authenticatedBy,
      'createdAt': createdAt,
      'email': email,
      'joinedAt': joinedAt,
      'id': id,
      'name': name,
    };
  }
}
