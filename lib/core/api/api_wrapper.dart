import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'interceptors.dart';
import 'exceptions.dart';

class DioWrapper {
  late final Dio _dio;
  late final FlutterSecureStorage _storage;

  DioWrapper({required String token}) {
    _storage = FlutterSecureStorage();

    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://api.github.com/',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );

    _dio.interceptors.add(ApiInterceptor(token));

    assert(() {
      _dio.interceptors.add(
        LogInterceptor(responseBody: true, requestBody: true),
      );
      return true;
    }());
  }

  // Recuperar para uso no Dio
  Future<String?> get token async {
    //TODO put Your token here or use a secure way to store it, like environment variables or secure storage.
    _storage.write(key: 'github_token', value: 'SEU_TOKEN');
    return await _storage.read(key: 'github_token');
  }

  // ── GET ──────────────────────────────────────────────────────────────────

  Future<T> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
      );
      return response.data as T;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ── POST ─────────────────────────────────────────────────────────────────

  Future<T> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response.data as T;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ── PUT ──────────────────────────────────────────────────────────────────

  Future<T> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response.data as T;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ── PATCH ────────────────────────────────────────────────────────────────

  Future<T> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.patch<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response.data as T;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ── DELETE ───────────────────────────────────────────────────────────────

  Future<T> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response.data as T;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ── Error handling ────────────────────────────────────────────────────────

  ApiException _handleError(DioException e) {
    final statusCode = e.response?.statusCode;
    final responseData = e.response?.data;

    final message = switch (e.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout => 'Tempo limite da ligação excedido.',
      DioExceptionType.connectionError => 'Sem ligação à internet.',
      DioExceptionType.badResponse => _messageFromStatus(
        statusCode,
        responseData,
      ),
      DioExceptionType.cancel => 'Pedido cancelado.',
      _ => e.message ?? 'Ocorreu um erro inesperado.',
    };

    return ApiException(
      message: message,
      statusCode: statusCode,
      data: responseData,
    );
  }

  String _messageFromStatus(int? statusCode, dynamic data) {
    final serverMessage = data is Map ? data['message'] as String? : null;

    return switch (statusCode) {
      400 => serverMessage ?? 'Pedido inválido.',
      401 => 'Não autorizado. Verifique o seu Personal Access Token.',
      403 => serverMessage ?? 'Acesso proibido ou rate limit da API excedido.',
      404 => serverMessage ?? 'Recurso não encontrado.',
      422 => serverMessage ?? 'Entidade não processável.',
      500 => 'Erro interno do servidor GitHub.',
      _ => serverMessage ?? 'Resposta inesperada ($statusCode).',
    };
  }
}
