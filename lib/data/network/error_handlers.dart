/// Handles generic errors and maps them to an `AppException`.
///
/// This method takes an error message as input and returns an `AppException`
/// with the provided message. It ensures that unexpected errors are handled
/// gracefully and logged for debugging purposes.

import 'dart:async';
import 'dart:io';
import 'package:bethel_farm/data/network/exceptions/api_exception.dart';
import 'package:bethel_farm/data/network/exceptions/app_exception.dart';
import 'package:bethel_farm/data/network/exceptions/network_exception.dart';
import 'package:bethel_farm/data/network/exceptions/not_found_exception.dart';
import 'package:bethel_farm/data/network/exceptions/service_unavailable_exception.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

Exception handleError(String error) {
  // final logger = BuildConfig.instance.config.logger;
  debugPrint("LOG >> Generic exception: $error");

  return AppException(message: error);
}

/// Handles errors from Dio requests and maps them to appropriate exceptions.
///
/// This method takes a `DioException` and returns a corresponding exception
/// based on the type of error encountered. It ensures that specific error
/// types are handled gracefully, providing meaningful messages or custom
/// exceptions for each case.
Exception handleDioError(DioException dioError) {
  switch (dioError.type) {
    case DioExceptionType.cancel:
      return AppException(message: "Request to API server was cancelled");
    case DioExceptionType.connectionTimeout:
      return AppException(message: "Connection timeout with API server");
    case DioExceptionType.unknown:
      return NetworkException("Please check Internet Connection.");
    case DioExceptionType.receiveTimeout:
      return TimeoutException("Receive timeout in connection with API server");
    case DioExceptionType.sendTimeout:
      return TimeoutException("Send timeout in connection with API server");
    case DioExceptionType.badResponse:
      return _parseDioErrorResponse(dioError);
    case DioExceptionType.badCertificate:
      // Handle bad certificate
      return _parseDioErrorResponse(dioError);
    case DioExceptionType.connectionError:
      // Handle bad certificate
      return _parseDioErrorResponse(dioError);
  }
}

/// Parses the response from a Dio error and maps it to a specific exception.
///
/// This method extracts the HTTP status code, status, and server message
/// from the Dio error response. Based on the status code, it returns
/// appropriate exceptions such as `ServiceUnavailableException`, `NotFoundException`,
/// or `ApiException`. If the response data is invalid or missing, it defaults
/// to a generic error message.
Exception _parseDioErrorResponse(DioError dioError) {
  // final logger = BuildConfig.instance.config.logger;

  int statusCode = dioError.response?.statusCode ?? -1;
  String? status;
  String? serverMessage;

  try {
    if (statusCode == -1 || statusCode == HttpStatus.ok) {
      statusCode = dioError.response?.data["statusCode"];
    }
    status = dioError.response?.data["status"];
    serverMessage = dioError.response?.data["message"];
  } catch (e, s) {
    debugPrint("LOG >>$e");
    debugPrint("LOG >>$s");
    serverMessage = "Something went wrong. Please try again later.";
  }

  switch (statusCode) {
    case HttpStatus.serviceUnavailable:
      return ServiceUnavailableException("Service Temporarily Unavailable");
    case HttpStatus.notFound:
      return NotFoundException(serverMessage ?? "", status ?? "");
    default:
      return ApiException(httpCode: statusCode, status: status ?? "", message: serverMessage ?? "");
  }
}
