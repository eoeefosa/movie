import 'package:json_annotation/json_annotation.dart';
part 'authenticated_user.g.dart';

@JsonSerializable()
class AuthenticatedUser {
  final int id;
  final String username;
  final String email;
  @JsonKey(name: 'phone_number', defaultValue: '')
  final String phoneNumber;
  @JsonKey(name: 'is_verified')
  final bool isVerified;
  @JsonKey(defaultValue: '')
  final String token;

  const AuthenticatedUser({
    required this.token,
    required this.id,
    required this.email,
    required this.phoneNumber,
    required this.isVerified,
    required this.username,
  });

  factory AuthenticatedUser.fromJson(Map<String, dynamic>? json) =>
      _$AuthenticatedUserFromJson(json ?? {});
  Map<String, dynamic> toJson() => _$AuthenticatedUserToJson(this);
}
