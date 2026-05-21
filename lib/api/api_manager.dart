import 'dart:io';

import 'package:weather_forecast/constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

import 'interceptor/api_log_interceptor.dart';
import 'interceptor/auth_interceptor.dart';
import 'api_result.dart';

final apiManagerProvider = Provider<ApiManager>((ref) {
  return ApiManager._internal();
});

class ApiManager {

  late final Dio _dio;

  ApiManager._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        sendTimeout: const Duration(seconds: 10),
        responseType: ResponseType.json,
        headers: {'accept': 'application/json'},
      ),
    );

    _dio.interceptors.add(AuthInterceptor());
    _dio.interceptors.add(ApiLogInterceptor()); // Log 放最後
  }

  Future<ApiResult<Response>> request(
      String path, {
        required String method,
        Map<String, dynamic>? params,
        dynamic data,
      }) async {
    try {
      final response = await _dio.request(
        path,
        queryParameters: params,
        data: data,
        options: Options(method: method),
      );
      return ApiSuccess(response);
    } on DioException catch (e) {
      return ApiError(_mapDioError(e));
    } catch (_) {
      return const ApiError('網路異常，請檢查連線');
    }
  }

  Future<ApiResult<Response>> get(String path, {Map<String, dynamic>? params}) {
    return request(path, method: 'GET', params: params);
  }

  Future<ApiResult<Response>> post(String path, {dynamic data}) {
    return request(path, method: 'POST', data: data);
  }

  Future<ApiResult<File>> downloadFile({
    required String url,
    required String fileName,
    void Function(int received, int total)? onProgress,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final savePath = '${dir.path}/$fileName';

      await _dio.download(
        url,
        savePath,
        onReceiveProgress: onProgress,
        options: Options(
          responseType: ResponseType.bytes,
          headers: headers,
        ),
      );

      return ApiSuccess(File(savePath));
    } on DioException catch (e) {
      return ApiError(_mapDioError(e));
    } catch (_) {
      return const ApiError('檔案下載失敗');
    }
  }


  String _mapDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return '連線逾時，請稍後再試';
      case DioExceptionType.sendTimeout:
        return '請求逾時，請稍後再試';
      case DioExceptionType.receiveTimeout:
        return '回應逾時，請稍後再試';
      case DioExceptionType.badResponse:
        final status = e.response?.statusCode;
        if (status == 401) return '登入已過期，請重新登入';
        if (status == 403) return '權限不足';
        if (status == 404) return '找不到資源';
        return '伺服器錯誤 ($status)';
      case DioExceptionType.cancel:
        return '請求已取消';
      default:
        return '網路異常，請檢查連線';
    }
  }
}
