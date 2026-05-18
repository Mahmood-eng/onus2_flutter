class UserModel {
  final String uid;
  final String email;
  final String? displayName;

  UserModel({required this.uid, required this.email, this.displayName});

  String get simpleName {
    final trimmed = displayName?.trim();
    if (trimmed != null && trimmed.isNotEmpty) return trimmed;
    return email.split('@').first;
  }
}
