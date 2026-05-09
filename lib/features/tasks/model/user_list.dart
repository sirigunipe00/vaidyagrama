

import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_list.freezed.dart';
part 'user_list.g.dart';

@freezed
class UserList with _$UserList {
  const factory UserList({
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'full_name') String? fullName
  }) = _UserList;
factory UserList.fromJson(Map<String, dynamic> json) => _$UserListFromJson(json);
@override
  String toString() => fullName ?? '';
  

}
