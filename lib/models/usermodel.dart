import 'dart:convert';

class Usermodel {
  final String? id;
  final String? email;
  final String? username;
  final String? displayName;
  final String? profileImageUrl;

  Usermodel({
    this.id,
    this.email,
    this.username,
    this.displayName,
    this.profileImageUrl,
  });

  Usermodel copyWith({
    String? id,
    String? email,
    String? username,
    String? displayName,
    String? profileImageUrl,
  }) {
    return Usermodel(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      displayName: displayName ?? this.displayName,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'email': email,
      'username': username,
      'displayName': displayName,
      'profileImageUrl': profileImageUrl,
    };
  }

  factory Usermodel.fromMap(Map<String, dynamic> map) {
    return Usermodel(
      id: map['id'] != null ? map['id'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      username: map['username'] != null ? map['username'] as String : null,
      displayName:
          map['displayName'] != null ? map['displayName'] as String : null,
      profileImageUrl: map['profileImageUrl'] != null
          ? map['profileImageUrl'] as String
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Usermodel.fromJson(String source) =>
      Usermodel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Usermodel(id: $id, email: $email, username: $username, displayName: $displayName, profileImageUrl: $profileImageUrl)';
  }

  @override
  bool operator ==(covariant Usermodel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.email == email &&
        other.username == username &&
        other.displayName == displayName &&
        other.profileImageUrl == profileImageUrl;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        email.hashCode ^
        username.hashCode ^
        displayName.hashCode ^
        profileImageUrl.hashCode;
  }
}
