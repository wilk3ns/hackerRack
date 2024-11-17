import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hacker_rack/models/utils.dart';

part 'story.freezed.dart';
part 'story.g.dart';

@freezed
class Story with _$Story {
  const factory Story({
    required int id,
    @JsonKey(fromJson: sanitizeNullableString) String? title,
    @JsonKey(fromJson: sanitizeNullableString) String? text,
    required String by,
    required int time,
    String? url,
    int? descendants,
    int? score,
  }) = _Story;

  factory Story.fromJson(Map<String, dynamic> json) => _$StoryFromJson(json);
}


