# Expat for Dart

[![license: MIT](https://img.shields.io/badge/license-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Dart FFI bindings to a stream-oriented XML parser library written in C.

[Expat](https://libexpat.github.io/) excels with files too large to fit RAM,
and where performance and flexibility are crucial.

## Usage

```dart
import 'package:expat/expat.dart';

main() {
  var parser = XmlParser(
    onStartElement: (String element, List<String> attributes) {
      print('onStartElement $element')
    },
    onCharacterData: (String data) {
      print('onCharacterData $data');
    },
    onEndElement: (String element) {
      print('onEndElement $element');
    },
  );
  parser.parse(xml: '<foo>bar</foo>');
  parser.dispose();
}
```
