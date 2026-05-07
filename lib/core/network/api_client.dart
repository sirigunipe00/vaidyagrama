import 'dart:convert';

import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:app/core/core.dart';
import 'package:app/features/auth/model/logged_in_user.dart';
import 'package:app/features/auth/presentation/bloc/auth/auth_cubit.dart';

import 'package:path/path.dart' show basename;

/// A class which is responsible to make actual api calls and provide [ApiResponse]s.
///
@injectable
class ApiClient {
  const ApiClient(this.client, this.internet);

  /// HTTPClient that is going to be used to make underlying api calls. It can be easily switched
  /// any other implementations like dio.
  final http.Client client;

  /// Internet checker
  final InternetConnectionChecker internet;

  /// Performs HTTP GET request with provided request configuration
  Future<ApiResponse<T>> get<T>(RequestConfig<T> params) async {
    return _request(
      (Uri urlWithParams) => client.get(urlWithParams, headers: params.headers),
      params,
    );
  }

  Future<ApiResponse<T>> put<T>(RequestConfig<T> params) async {
    return _request(
      (Uri urlWithParams) => client.put(urlWithParams, headers: params.headers, body: params.body),
      params,
    );
  }

  /// Performs HTTP POST request with provided request configuration
  Future<ApiResponse<T>> post<T>(RequestConfig<T> params) async {
    return _request(
      (Uri urlWithParams) => client.post(urlWithParams, headers: params.headers, body: params.body),
      params,
    );
  }

  AsyncValueOf<Uint8List> downloadFile(String url) async {
    try {
      final request = await HttpClient().getUrl(Uri.parse(url));
      final response = await request.close();
      final bytes = await consolidateHttpClientResponseBytes(response);
      return right(bytes);
    } catch (e) {
      return left(Failure(error: e.toString()));
    }
  }

  /// Performs HTTP POST-multipart-request body request with provided request configuration
  /// Note: This method is supposed to be used for uploading files only as of now because few
  /// keys have been hardcoded in the implementation.
  ///
  /// It can be easily extended to make a customized request
  Future<ApiResponse<T>> multipartRequest<T>(RequestConfig<T> params) async {
    try {
      if (!await internet.hasInternet()) {
        throw NoInternetException(Errors.noInternet);
      }

      // For multipart, use base URL without query params (reqParams go in form fields)
      final Uri uri = Uri.parse(params.url);
      final http.MultipartRequest request = http.MultipartRequest('POST', uri);
      final Map<String, String>? headers = params.headers;
      final Map<String, dynamic>? reqParams = params.reqParams;
      final Map<String, String>? files = params.files;

      // Add auth header if needed
      if ($sl.isRegistered<LoggedInUser>()) {
        final user = $sl.get<LoggedInUser>();
        final apiKey = user.apiKey;
        final apiSecret = user.apiSecret;
        if (!apiKey.doesNotHaveValue && !apiSecret.doesNotHaveValue) {
          request.headers[HttpHeaders.authorizationHeader] = 'token $apiKey:$apiSecret';
        }
      }


      if (headers != null) {
        final filteredHeaders = Map<String, String>.from(headers)
        ..remove(HttpHeaders.contentTypeHeader);
        request.headers.addAll(filteredHeaders);
      }


      if (reqParams != null) {
        for (final MapEntry<String, dynamic> param in reqParams.entries) {
          if (param.value is File) {

            continue;
          } else {
            request.fields.putIfAbsent(param.key, () => param.value.toString());
          }
        }
      }


      if (files != null) {
        for (final MapEntry<String, String> fileEntry in files.entries) {
          final File file = File(fileEntry.value);
          if (await file.exists()) {
            final http.MultipartFile multipartFile = await http.MultipartFile.fromPath(
              fileEntry.key, // Use the key as the field name (e.g., 'vehicle_temperature_photo')
              file.path,
              filename: basename(file.path),
            );
            request.files.add(multipartFile);
          }
        }
      }

      if (kDebugMode) {
        $logger
          ..info(uri)
          ..info('Form fields: ${request.fields}')
          ..info('Files: ${files?.keys.toList()}');
      }

      final http.StreamedResponse streamedResponse = await client.send(request);
      final http.Response httpResponse = await http.Response.fromStream(streamedResponse);
      final int statusCode = httpResponse.statusCode;
      final String resBody = httpResponse.body;
      
      if (kDebugMode) {
        $logger
          ..info('Status Code $statusCode')
          ..info('Response : $resBody');
      }
      
      if (statusCode == HttpStatus.ok) {
        if (resBody.doesNotHaveValue) {
          throw UnExpectedResponseException(resBody);
        }

        final ApiResponseParser<T> responseParser = params.apiResponseParser ?? FrappeApiResponseParser<T>();
        final ApiResponse<T> result = responseParser.parse(
          resBody,
          params.parser,
          Errors.defaultApiErrorMessage,
        );

        return result;
      } else {
        if(statusCode == HttpStatus.notFound || statusCode == HttpStatus.forbidden) {
             final message = defaultErrorParser(jsonDecode(resBody), Errors.internalServerError);
          throw ServerException(message);
        } else if(statusCode == HttpStatus.gatewayTimeout) {
          throw ServerException(Errors.gatewayTimeout);
        } else if(statusCode == HttpStatus.unauthorized) {
          _handleAuthenticationError();
          throw ServerException(Errors.invalidcredentials);
        } else if ((statusCode >= HttpStatus.internalServerError &&
            statusCode <= HttpStatus.networkConnectTimeoutError) || statusCode == HttpStatus.expectationFailed) {
          final message = defaultErrorParser(jsonDecode(resBody), Errors.internalServerError);
          throw ServerException(message);
        } else if (statusCode >= HttpStatus.badRequest &&
            statusCode <= HttpStatus.clientClosedRequest) {
          throw ClientException(Errors.clientError);
        } else {
          throw UnknownException(Errors.unknown);
        }
      }
    } on ServerException catch(e, _) {
      throw BaseApiException(e.message);
    } on FormatException catch (e) {
      throw ParseException(e.message);
    } on http.ClientException catch (e, st) {
      // Handle http package's ClientException (connection errors)
      $logger.error('[API client ClientException]', e, st);
      final errorMessage = e.message.toLowerCase();
      if (errorMessage.contains('connection closed') ||
          errorMessage.contains('connection reset') ||
          errorMessage.contains('socket') ||
          errorMessage.contains('network')) {
        throw ConnectionException(Errors.connectionIssue);
      }
      throw ClientException(Errors.clientError);
    } on Exception catch (e, st) {
      $logger.error('[API client Exception]', e, st);
      final errorString = e.toString().toLowerCase();
      // Check for connection-related errors
      if (errorString.contains('connection closed') ||
          errorString.contains('connection reset') ||
          errorString.contains('socket') ||
          errorString.contains('network')) {
        throw ConnectionException(Errors.connectionIssue);
      }
      if (e is NoInternetException ||
          e is UnExpectedResponseException ||
          e is UnAuthorizedException ||
          e is ClientException ||
          e is ServerException) {
        rethrow;
      }
      throw UnknownException(Errors.unknown);
    }
  }

  Future<ApiResponse<T>> _request<T>(
    Future<http.Response> Function(Uri url) apiCall,
    RequestConfig<T> params,
  ) async {
    try {
      if (!await internet.hasInternet()) {
        throw NoInternetException(Errors.noInternet);
      }

      final Uri uri = RestUtils.constructUri(params.url, params.reqParams);
      final http.Response httpResponse = await apiCall(uri);
      final int statusCode = httpResponse.statusCode;
      final String resBody = httpResponse.body;
      
      if (kDebugMode) {
        $logger
          ..info(uri)
          ..info(params.body ?? params.reqParams)
          ..info(params.headers)
          ..info('Status Code $statusCode')
          ..info('Response : $resBody');
      }
      
      if (statusCode == HttpStatus.ok) {
        if (resBody.doesNotHaveValue) {
          throw UnExpectedResponseException(resBody);
        }

        final ApiResponseParser<T> responseParser = params.apiResponseParser ?? FrappeApiResponseParser<T>();
        final ApiResponse<T> result = responseParser.parse(
          resBody,
          params.parser,
          Errors.defaultApiErrorMessage,
        );

        return result;
      } else {
        if(statusCode == HttpStatus.notFound || statusCode == HttpStatus.forbidden) {
             final message = defaultErrorParser(jsonDecode(resBody), Errors.internalServerError);
          throw ServerException(message);
        } else if(statusCode == HttpStatus.gatewayTimeout) {
          throw ServerException(Errors.gatewayTimeout);
        } else if(statusCode == HttpStatus.unauthorized) {
          _handleAuthenticationError();
          throw ServerException(Errors.invalidcredentials);
        } else if ((statusCode >= HttpStatus.internalServerError &&
            statusCode <= HttpStatus.networkConnectTimeoutError) || statusCode == HttpStatus.expectationFailed) {
          final message = defaultErrorParser(jsonDecode(resBody), Errors.internalServerError);
          throw ServerException(message);
        } else if (statusCode >= HttpStatus.badRequest &&
            statusCode <= HttpStatus.clientClosedRequest) {
          throw ClientException(Errors.clientError);
        } else {
          throw UnknownException(Errors.unknown);
        }
      }
    } on ServerException catch(e, _) {
      throw BaseApiException(e.message);
    } on FormatException catch (e) {
      throw ParseException(e.message);
    } on http.ClientException catch (e, st) {
      // Handle http package's ClientException (connection errors)
      $logger.error('[API client ClientException]', e, st);
      final errorMessage = e.message.toLowerCase();
      if (errorMessage.contains('connection closed') ||
          errorMessage.contains('connection reset') ||
          errorMessage.contains('socket') ||
          errorMessage.contains('network')) {
        throw ConnectionException(Errors.connectionIssue);
      }
      throw ClientException(Errors.clientError);
    } on Exception catch (e, st) {
      $logger.error('[API client Exception]', e, st);
      final errorString = e.toString().toLowerCase();
      // Check for connection-related errors
      if (errorString.contains('connection closed') ||
          errorString.contains('connection reset') ||
          errorString.contains('socket') ||
          errorString.contains('network')) {
        throw ConnectionException(Errors.connectionIssue);
      }
      if (e is NoInternetException ||
          e is UnExpectedResponseException ||
          e is UnAuthorizedException ||
          e is ClientException ||
          e is ServerException) {
        rethrow;
      }
      throw UnknownException(Errors.unknown);
    }
  }

  void _handleAuthenticationError() {
    try {
      if ($sl.isRegistered<AuthCubit>()) {
        final authCubit = $sl.get<AuthCubit>()
        ..signOut();
        debugPrint('authCubit$authCubit');
        $logger.info('[ApiClient] User logged out due to 401 authentication error');
      }
    } catch (e, st) {
      $logger.error('[ApiClient] Error during logout', e, st);
    }
  }
}
