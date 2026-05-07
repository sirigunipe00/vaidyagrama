
import 'dart:io';
import 'dart:typed_data';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:app/core/core.dart';
import 'package:app/features/auth/model/logged_in_user.dart';
import 'package:app/features/auth/presentation/bloc/auth/auth_cubit.dart';

typedef ApiCall<T> = Future<ApiResponse<T>> Function(RequestConfig<T> config);
typedef StandardApiResponse<T> = Future<Either<Failure, ApiResponse<T>>>;

class BaseApiRepository {
  const BaseApiRepository(this.client);

  final ApiClient client;

  StandardApiResponse<T> get<T>(RequestConfig<T> params,
      {bool includeAuthHeader = true}) async {
    try {
      return _request(client.get, params, includeAuthHeader: includeAuthHeader);
    } on Exception catch (e, st) {
      $logger.error('[Api Failure]', e, st);
      return left(Failure(error: e.toString()));
    }
  }

  StandardApiResponse<T> post<T>(
    RequestConfig<T> params, {
    bool includeAuthHeader = true,
  }) async =>
      _request(client.post, params, includeAuthHeader: includeAuthHeader);

  StandardApiResponse<T> put<T>(
    RequestConfig<T> params, {
    bool includeAuthHeader = true,
  }) async =>
      _request(client.put, params, includeAuthHeader: includeAuthHeader);

  StandardApiResponse<T> multiPart<T>(
    RequestConfig<T> params, {
    bool includeAuthHeader = true,
  }) async {
    return _requestMultipart(client.multipartRequest, params,
        includeAuthHeader: includeAuthHeader);
  }

  StandardApiResponse<T> _requestMultipart<T>(
      ApiCall<T> apiCall, RequestConfig<T> config,
      {bool includeAuthHeader = true}) async {
    try {
      // For multipart requests, don't set content-type - it will be set automatically with boundary
      final commonHeaders = <String, dynamic>{};
      if (includeAuthHeader) {
        final cookie = await _getAuthHeader();
        commonHeaders.addAll(cookie);
      }

      final RequestConfig<T> requestConfig = config.copyWith(
        headers: {...config.headers ?? {}, ...commonHeaders},
      );

      final ApiResponse<T> response = await apiCall(requestConfig);

      if (response.isFailed()) {
        // Check for 401 authentication error
        if (response.status == 401 || 
            (response.error != null && 
             (response.error!.contains('Wrong credentials') || 
              response.error!.contains('Invalid Username or Password') ||
              response.error!.contains('AuthenticationError')))) {
          _handleAuthenticationError();
        }
        return left(Failure(error: response.error!));
      }

      return right(response);
    } on BaseApiException catch (e, _) {
      // Check for 401 authentication error in exception message
      if (e.message.contains('Wrong credentials') || 
          e.message.contains('Invalid Username or Password') ||
          e.message.contains('AuthenticationError')) {
        _handleAuthenticationError();
      }
      return left(Failure(error: e.message));
    } on Exception catch (e, st) {
      $logger
        ..info('Log 2')
        ..error(e.toString(), e, st);

      // Check for 401 authentication error in exception
      final errorString = e.toString();
      if (errorString.contains('Wrong credentials') || 
          errorString.contains('Invalid Username or Password') ||
          errorString.contains('AuthenticationError') ||
          errorString.contains('401')) {
        _handleAuthenticationError();
      }

      return left(Failure(error: e.toString()));
    }
  }

  AsyncValueOf<Uint8List> downloadFile(String url) async {

    String baseUrl;

    if (Urls.isTest) {
       baseUrl = 'https://m11ucouat.easycloud.co.in/';
    } else {
      baseUrl = 'https://rucoprd.sunpure.in/';
    }
    // const String baseUrl = 'https://m11ucouat.easycloud.co.in//';
    // // const String baseUrl = 'https://rucoprd.sunpure.in//';
  //  
    if (!url.startsWith(baseUrl)) {
      url = baseUrl + url;
    }

    final res = await client.downloadFile(url);
    return res;
  }

   Map<String, dynamic> removeNullValues(Map<String, dynamic> map) {
    map.removeWhere((key, value) => value == null);
    Map<String, dynamic> stringifiedMap = {};

    map.forEach((key, value) {
      if (value is! File) {
        stringifiedMap[key] = value;
      } else {
        stringifiedMap[key] = value;
      }
    });
    return stringifiedMap;
  }

  StandardApiResponse<T> _request<T>(
      ApiCall<T> apiCall, RequestConfig<T> config,
      {bool includeAuthHeader = true}) async {
    try {
      final commonHeaders = <String, dynamic>{
        HttpHeaders.contentTypeHeader: 'application/json'
      };
      if (includeAuthHeader) {
        final cookie = await _getAuthHeader();
        commonHeaders.addAll(cookie);
      }

      final RequestConfig<T> requestConfig = config.copyWith(
        headers: {...config.headers ?? {}, ...commonHeaders},
      );

      final ApiResponse<T> response = await apiCall(requestConfig);

      if (response.isFailed()) {
        // Check for 401 authentication error
        if (response.status == 401 || 
            (response.error != null && 
             (response.error!.contains('Wrong credentials') || 
              response.error!.contains('Invalid Username or Password') ||
              response.error!.contains('AuthenticationError')))) {
          _handleAuthenticationError();
        }
        return left(Failure(error: response.error!));
      }

      return right(response);
    } on BaseApiException catch (e, _) {
      // Check for 401 authentication error in exception message
      if (e.message.contains('Wrong credentials') || 
          e.message.contains('Invalid Username or Password') ||
          e.message.contains('AuthenticationError')) {
        _handleAuthenticationError();
      }
      return left(Failure(error: e.message));
    } on Exception catch (e, st) {
      $logger
        ..info('Log 2')
        ..error(e.toString(), e, st);

      // Check for 401 authentication error in exception
      final errorString = e.toString();
      if (errorString.contains('Wrong credentials') || 
          errorString.contains('Invalid Username or Password') ||
          errorString.contains('AuthenticationError') ||
          errorString.contains('401')) {
        _handleAuthenticationError();
      }

      return left(Failure(error: e.toString()));
    }
  }

  LoggedInUser user() => $sl.get<LoggedInUser>();

  Future<Map<String, dynamic>> _getAuthHeader() async {
    if ($sl.isRegistered<LoggedInUser>()) {
      final user = $sl.get<LoggedInUser>();
      final apiKey = user.apiKey;
      final apiSecret = user.apiSecret;
      if (apiKey.doesNotHaveValue || apiSecret.doesNotHaveValue) return {};
      return {HttpHeaders.authorizationHeader: 'token $apiKey:$apiSecret'};
    }
    return {};
  }

  AsyncValueOf<T> executeSafely<T>(AsyncValueOf<T> Function() asyncFunction) {
    return AppTaskEither.tryCatch(
      () async {
        final result = await asyncFunction();
        return result.fold((failure) => throw failure.error, (value) => value);
      },
      (error, stack) {
        $logger
          ..error('[BaseApiRepo]', error, stack)
          ..info(stack);
        
        // Check for 401 authentication error
        final errorString = error.toString();
        if (errorString.contains('Wrong credentials') || 
            errorString.contains('Invalid Username or Password') ||
            errorString.contains('AuthenticationError') ||
            errorString.contains('401')) {
          _handleAuthenticationError();
        }
        
        return Failure(error: error.toString());
      },
    ).run();
  }

  void _handleAuthenticationError() {
    try {
      if ($sl.isRegistered<AuthCubit>()) {
        final authCubit = $sl.get<AuthCubit>()
        ..signOut();
        debugPrint('authcubit........$authCubit');
        $logger.info('[BaseApiRepo] User logged out due to authentication error');
      }
    } catch (e, st) {
      $logger.error('[BaseApiRepo] Error during logout', e, st);
    }
  }
}
