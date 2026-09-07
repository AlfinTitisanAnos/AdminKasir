class UserModel {
  final String id;
  String name;
  final String email;
  final String role;
  String password;

  UserModel({required this.id, required this.name, required this.email, required this.role, this.password = ''});
}