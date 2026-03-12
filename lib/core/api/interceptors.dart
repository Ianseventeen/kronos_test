import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ApiInterceptor extends Interceptor {
  final String personalAccessToken;

  ApiInterceptor(this.personalAccessToken);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['Authorization'] = 'Bearer $personalAccessToken';
    options.headers['Accept'] = 'application/vnd.github.v3+json';
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      final status = err.response?.statusCode;
      if (status == 401) {
        debugPrint('[ApiInterceptor] 401 Unauthorized — verifique o PAT.');
      } else if (status == 403) {
        debugPrint(
          '[ApiInterceptor] 403 Forbidden — rate limit ou permissões insuficientes.',
        );
      }
    }
    super.onError(err, handler);
  }
}
