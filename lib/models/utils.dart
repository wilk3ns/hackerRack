import 'package:html/parser.dart';
import 'package:html_unescape/html_unescape.dart';

String? sanitizeNullableString(String? input) {
  if (input == null) return null;
  final unescape = HtmlUnescape();
  final unescapedString = unescape.convert(input);

  final document = parse(unescapedString);
  return document.body?.text;
}
