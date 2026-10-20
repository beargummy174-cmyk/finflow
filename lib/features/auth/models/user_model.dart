class UserModel {
  final String id;
  final String email;
  final String displayName;
  final String? photoUrl;

  const UserModel({
    required this.id,
    required this.email,
    required this.displayName,
    this.photoUrl,
  });

  factory UserModel.fromMap(Map<String, dynamic> map, String id) {
    return UserModel(
      id: id,
      email: map['email'] ?? '',
      displayName: map['displayName'] ?? 'User FinFlow',
      photoUrl: map['photoUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
    };
  }
}
