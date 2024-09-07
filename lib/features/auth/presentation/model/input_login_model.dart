import 'dart:convert';

class LoginInputModel {
  String email;
  String password;

  LoginInputModel({
    required this.email,
    required this.password,
  });

  LoginInputModel copyWith({
    String? email,
    String? password,
  }) {
    return LoginInputModel(
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'password': password,
    };
  }

  factory LoginInputModel.fromMap(Map<String, dynamic> map) {
    return LoginInputModel(
      email: map['email'] ?? '',
      password: map['password'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory LoginInputModel.fromJson(String source) =>
      LoginInputModel.fromMap(json.decode(source));

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LoginInputModel &&
        other.email == email &&
        other.password == password;
  }

  @override
  int get hashCode => email.hashCode ^ password.hashCode;
}
