import 'package:expat/expat.dart';
import 'package:test/test.dart';

void main() {
  var parser;
  var handler;

  setUp(() {
    parser = XmlParser();
    handler = TestHandler(parser);
  });

  tearDown(() {
    handler = null;
    parser.dispose();
  });

  test('basic', () {
    expect(parser.parse(xml: '<foo bar="baz">qux</foo>'), isTrue);
    expect(
        handler.calls,
        equals(<String>[
          'onStartElement foo [bar, baz]',
          'onCharacterData qux',
          'onEndElement foo',
        ]));
  });
}

class TestHandler {
  final calls = <String>[];

  TestHandler(XmlParser parser) {
    parser.onStartElement = onStartElement;
    parser.onEndElement = onEndElement;
    parser.onStartCharacterData = onStartCharacterData;
    parser.onCharacterData = onCharacterData;
    parser.onEndCharacterData = onEndCharacterData;
    parser.onProcessingInstruction = onProcessingInstruction;
    parser.onComment = onComment;
    parser.onDefault = onDefault;
    parser.onStartDoctypeDecl = onStartDoctypeDecl;
    parser.onEndDoctypeDecl = onEndDoctypeDecl;
    parser.onEntityDecl = onEntityDecl;
    parser.onNotationDecl = onNotationDecl;
    parser.onStartNamespaceDecl = onStartNamespaceDecl;
    parser.onEndNamespaceDecl = onEndNamespaceDecl;
    parser.onNotStandalone = onNotStandalone;
    parser.onExternalEntityRef = onExternalEntityRef;
    parser.onSkippedEntity = onSkippedEntity;
    parser.onUnknownEncoding = onUnknownEncoding;
  }

  void onStartElement(String element, List<String> attributes) {
    calls.add('onStartElement $element $attributes');
  }

  void onEndElement(String element) {
    calls.add('onEndElement $element');
  }

  void onStartCharacterData() {
    calls.add('onStartCharacterData');
  }

  void onCharacterData(String data) {
    calls.add('onCharacterData $data');
  }

  void onEndCharacterData() {
    calls.add('onEndCharacterData');
  }

  void onProcessingInstruction(String target, String data) {
    calls.add('onProcessingInstruction $target $data');
  }

  void onComment(String comment) {
    calls.add('onComment $comment');
  }

  void onDefault(String data) {
    calls.add('onDefault $data');
  }

  void onStartDoctypeDecl(
    String doctype,
    String systemId,
    String publicId,
    bool hasInternalSubset,
  ) {
    calls.add(
        'onStartDoctypeDecl $doctype $systemId $publicId $hasInternalSubset');
  }

  void onEndDoctypeDecl() {
    calls.add('onEndDoctypeDecl');
  }

  void onEntityDecl(
    String entity,
    bool isParameter,
    String value,
    String base,
    String systemId,
    String publicId,
    String notation,
  ) {
    calls.add(
        'onEntityDecl $entity $isParameter $value $base $systemId, $publicId, $notation');
  }

  void onNotationDecl(
    String notation,
    String base,
    String systemId,
    String publicId,
  ) {
    calls.add('onNotationDecl $notation $base $systemId $publicId');
  }

  void onStartNamespaceDecl(String prefix, String uri) {
    calls.add('onStartNamespaceDecl $prefix $uri');
  }

  void onEndNamespaceDecl(String prefix) {
    calls.add('onEndNamespaceDecl $prefix');
  }

  bool onNotStandalone() {
    calls.add('onNotStandalone');
    return true;
  }

  bool onExternalEntityRef(
    String context,
    String base,
    String systemId,
    String publicId,
  ) {
    calls.add('onExternalEntityRef $context $base $systemId $publicId');
    return true;
  }

  bool onSkippedEntity(String entity, bool isParameter) {
    calls.add('onSkippedEntity $entity $isParameter');
    return true;
  }

  bool onUnknownEncoding(String encoding) {
    calls.add('onUnknownEncoding $encoding');
    return false;
  }
}
