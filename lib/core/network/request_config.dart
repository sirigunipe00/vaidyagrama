import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:vaidyagrama/core/network/response_parser.dart';

part 'request_config.freezed.dart';

@freezed
class RequestConfig<T> with _$RequestConfig<T> {
  factory RequestConfig({
    required String url,
    required T Function(Map<String, dynamic>) parser,

    Map<String, dynamic>? reqParams,
    Map<String, String>? headers,

    /// NEW: Support multipart form-data file uploads
    Map<String, String>? files,

    ApiResponseParser<T>? apiResponseParser,
    String? body,
  }) = _RequestConfig<T>;
}
