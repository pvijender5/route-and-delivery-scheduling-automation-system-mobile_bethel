/// A custom interceptor that adds headers to outgoing HTTP requests.
///
/// This interceptor overrides the `onRequest` method to asynchronously fetch
/// custom headers and add them to the request options before proceeding.
///
/// - `getCustomHeaders`: A method that returns a `Future` containing a map of
///   custom headers to be added to the request.
///
/// Example usage:
/// ```dart
/// Dio dio = Dio();
/// dio.interceptors.add(RequestHeaderInterceptor());
/// `

import 'package:dio/dio.dart';

class RequestHeaderInterceptor extends InterceptorsWrapper {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    getCustomHeaders().then((customHeaders) {
      options.headers.addAll(customHeaders);
      super.onRequest(options, handler);
    });
  }

  /// Fetches custom headers asynchronously.
  ///
  /// This method returns a `Future` containing a map of custom headers
  /// to be added to the request. The headers include the `content-type`
  /// set to `application/json`.
  ///
  /// Returns:
  /// - A `Future<Map<String, String>>` containing the custom headers.
  Future<Map<String, String>> getCustomHeaders() async {
    var customHeaders = {'content-type': 'application/json'};

    return customHeaders;
  }
}
