// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'authenticated_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthenticatedUser _$AuthenticatedUserFromJson(Map<String, dynamic> json) =>
    AuthenticatedUser(
      token: json['token'] as String? ?? '',
      id: (json['id'] as num).toInt(),
      email: json['email'] as String,
      phoneNumber: json['phone_number'] as String? ?? '',
      isVerified: json['is_verified'] as bool,
      username: json['username'] as String,
    );

Map<String, dynamic> _$AuthenticatedUserToJson(AuthenticatedUser instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'email': instance.email,
      'phone_number': instance.phoneNumber,
      'is_verified': instance.isVerified,
      'token': instance.token,
    };
