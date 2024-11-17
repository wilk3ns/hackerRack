import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hacker_rack/models/utils.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class User with _$User {
  const factory User({
    required String id,
    @JsonKey(fromJson: sanitizeNullableString) String? about,
    required int created,
    required int karma,
    required List<int> submitted,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}