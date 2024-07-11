import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../Commerce/models.dart/cartegory.dart';

class CustomException implements Exception {
  final String message;
  final bool status;

  const CustomException({required this.status, required this.message});

  factory CustomException.fromJson(Map<String, dynamic> json) =>
      CustomException(
        status: json['success'] ?? false,
        message: json['message'] as String,
      );
  @override
  String toString() {
    return '{"message": "$message", "success": "$status"}';
  }
}

CustomException error(DioException e) {
  if (e.type == DioExceptionType.connectionTimeout ||
      e.type == DioExceptionType.receiveTimeout) {
    debugPrint(e.type.toString());
    return const CustomException(
      message: 'Connection timeout',
      status: false,
    );
  } else if (e.response?.data is Map) {
    return CustomException.fromJson(e.response?.data);
  } else {
    return CustomException(
      status: false,
      message: e.response?.statusMessage ?? '',
    );
  }
}

var options = BaseOptions(
  baseUrl: 'https://api.2geda.net/api',
  connectTimeout: const Duration(milliseconds: 2000),
  receiveTimeout: const Duration(milliseconds: 500000),
);

Dio dio = Dio(options);

const token =
    "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzIxNTI5MjU1LCJpYXQiOjE3MjA2NjUyNTUsImp0aSI6ImNmY2M1Njg1YmRiYjRkNDU5YTg3Y2ZjNDlhMGI5MTE3IiwidXNlcl9pZCI6NDd9.AaZubadu3GqC2oy_wsEZKo8TXtR4Tff_Om2j53sESUA";

const refreshtoken =
    "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTcyMjM5MzI1NSwiaWF0IjoxNzIwNjY1MjU1LCJqdGkiOiJkNWZkMmMyMjA4ZGY0Y2FjODA1NGUxOTEwNzQzMWY1NyIsInVzZXJfaWQiOjQ3fQ.yYrveG8BvzPPMWz5Xd5T4hWStSevGzKCL5cEm2jKOes";

class CommerceApi {
  static const String path = '/commerce';

  // Future getCartegories(String token) async {
  Future getCartegories() async {
    List cartegories = [];
    try {
      final cartegoriesResponse = await dio.get(
        '$path/products/all',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      List cartegoriesList = cartegoriesResponse.data;

      cartegories = cartegoriesList.map((e) {
        return Categories.fromJson(e);
      }).toList();

      return cartegories;
    } on DioException catch (e, trace) {
      debugPrint(e.response?.data.runtimeType.toString());
      debugPrint(trace.toString());
      throw (error(e));
    } catch (e, trace) {
      debugPrint(e.toString());
      debugPrint(trace.toString());
      rethrow;
    }
  }
}
