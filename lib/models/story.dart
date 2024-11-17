import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:html/parser.dart';
import 'package:html_unescape/html_unescape.dart';

part 'story.freezed.dart';
part 'story.g.dart';

@freezed
class Story with _$Story {
  const factory Story({
    required int id,
    @JsonKey(fromJson: _sanitizeNullableString) String? title,
    @JsonKey(fromJson: _sanitizeNullableString) String? text,
    required String by,
    required int time,
    String? url,
    int? descendants,
    int? score,
  }) = _Story;

  factory Story.fromJson(Map<String, dynamic> json) => _$StoryFromJson(json);
}

String? _sanitizeNullableString(String? input) {
  if (input == null) return null;
  final unescape = HtmlUnescape();
  final unescapedString = unescape.convert(input);

  // Strip HTML tags
  final document = parse(unescapedString);
  return document.body?.text;
}
