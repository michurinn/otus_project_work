import 'package:new_flutter_template/src/share/typedefs/typedef_json.dart';

/// Represents the List with Json to formatted string
extension StringWithJsonFormatExtension on List<Json> {
  String formatThisJsonList() {
    try {
      return map((e) => '${e.jsonToString()}\n').reduce(
        (value, element) => value + element,
      );
    } catch (e) {
      return toString();
    }
  }
}

extension JsonToString on Json {
  String jsonToString() {
    return keys
        .map(
          (e) => '$e : ${this[e]}',
        )
        .reduce(
          (value, element) => '$value\n$element',
        );
  }
}
