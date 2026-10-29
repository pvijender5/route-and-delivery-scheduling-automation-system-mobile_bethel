/// `DioProvider` is a utility class that provides configured instances of `Dio`
/// for making HTTP requests. It includes methods for setting interceptors,
/// managing content types, and handling token-based authentication.

import 'package:bethel_farm/data/network/pretty_dio_logger.dart';
import 'package:bethel_farm/data/network/request_headers.dart';
import 'package:dio/dio.dart';

class DioProvider {
  static const String baseUrl = "baseUrl";
  static const String socketUrl = "socketUrl";

  static Dio? _instance;

  static const int _maxLineWidth = 90;

  // Logger interceptor for formatting and logging HTTP requests, responses, and errors.
  static final _prettyDioLogger = PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      // responseBody: BuildConfig.instance.environment == Environment.DEVELOPMENT,
      responseHeader: false,
      error: true,
      compact: true,
      maxWidth: _maxLineWidth);

  // Defines the base options for the Dio instance, including the base URL, connection timeout, and receive timeout.
  static final BaseOptions _options = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(milliseconds: (60 * 1000)),
      receiveTimeout: const Duration(milliseconds: (60 * 1000)));

  /// Provides a singleton instance of `Dio` configured with base options and interceptors.
  ///
  /// - If the instance is null, it initializes a new `Dio` instance with the specified base options.
  /// - Adds the `PrettyDioLogger` interceptor for logging HTTP requests, responses, and errors.
  /// - Ensures the interceptors are cleared and re-added each time the method is called.
  ///
  /// Returns:
  /// - A configured `Dio` instance.
  static Dio get httpDio {
    if (_instance == null) {
      _instance = Dio(_options);

      _instance!.interceptors.add(_prettyDioLogger);

      return _instance!;
    } else {
      _instance!.interceptors.clear();
      _instance!.interceptors.add(_prettyDioLogger);

      return _instance!;
    }
  }

  ///returns a Dio client with Access token in header
  static Dio get tokenClient {
    _addInterceptors();

    return _instance!;
  }

  ///returns a Dio client with Access token in header
  ///Also adds a token refresh interceptor which retry the request when it's unauthorized
  static Dio get dioWithHeaderToken {
    _addInterceptors();

    return _instance!;
  }

  /// Adds interceptors to the Dio instance.
  ///
  /// - Ensures the `httpDio` instance is initialized if not already.
  /// - Clears existing interceptors to avoid duplicates.
  /// - Adds the `RequestHeaderInterceptor` for handling request headers.
  /// - Adds the `PrettyDioLogger` for logging HTTP requests, responses, and errors.
  static _addInterceptors() {
    _instance ??= httpDio;
    _instance!.interceptors.clear();
    _instance!.interceptors.add(RequestHeaderInterceptor());
    _instance!.interceptors.add(_prettyDioLogger);
  }

  // Builds a custom content type string using the provided version.
  ///
  /// This method constructs a content type string in the format:
  /// `user_defined_content_type+<version>`.
  ///
  /// Parameters:
  /// - `version`: A `String` representing the version to append to the content type.
  ///
  /// Returns:
  /// - A `String` representing the custom content type.
  static String _buildContentType(String version) {
    return "user_defined_content_type+$version";
  }

  /// Sets the content type for the `Dio` instance.
  ///
  /// This method updates the `contentType` option of the `Dio` instance
  /// to a custom content type string constructed using the provided version.
  ///
  /// Parameters:
  /// - `version`: A `String` representing the version to append to the content type.
  ///
  DioProvider.setContentType(String version) {
    _instance?.options.contentType = _buildContentType(version);
  }

  /// Sets the content type of the `Dio` instance to `application/json`.
  ///
  /// This method updates the `contentType` option of the `Dio` instance
  /// to use the standard `application/json` MIME type.
  DioProvider.setContentTypeApplicationJson() {
    _instance?.options.contentType = "application/json";
  }
}
