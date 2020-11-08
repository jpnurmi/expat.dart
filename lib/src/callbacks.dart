// Copyright (c) 1998-2000 Thai Open Source Software Center Ltd and Clark Cooper
// Copyright (c) 2001-2019 Expat maintainers
// Copyright (c) 2020 J-P Nurmi
//
// Permission is hereby granted, free of charge, to any person obtaining
// a copy of this software and associated documentation files (the
// "Software"), to deal in the Software without restriction, including
// without limitation the rights to use, copy, modify, merge, publish,
// distribute, sublicense, and/or sell copies of the Software, and to
// permit persons to whom the Software is furnished to do so, subject to
// the following conditions:
//
// The above copyright notice and this permission notice shall be included
// in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
// CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
// SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

typedef OnStartElement = void Function(String element, List<String> attributes);
typedef OnEndElement = void Function(String element);
typedef OnStartCharacterData = void Function();
typedef OnCharacterData = void Function(String data);
typedef OnEndCharacterData = void Function();
typedef OnProcessingInstruction = void Function(String target, String data);
typedef OnComment = void Function(String comment);
typedef OnDefault = void Function(String data);
typedef OnStartDoctypeDecl = void Function(
  String doctype,
  String systemId,
  String publicId,
  bool hasInternalSubset,
);
typedef OnEndDoctypeDecl = void Function();
typedef OnEntityDecl = void Function(
  String entity,
  bool isParameter,
  String value,
  String base,
  String systemId,
  String publicId,
  String notation,
);
typedef OnNotationDecl = void Function(
  String notation,
  String base,
  String systemId,
  String publicId,
);
typedef OnStartNamespaceDecl = void Function(String prefix, String uri);
typedef OnEndNamespaceDecl = void Function(String prefix);
typedef OnNotStandalone = bool Function();
typedef OnExternalEntityRef = bool Function(
  String context,
  String base,
  String systemId,
  String publicId,
);
typedef OnSkippedEntity = bool Function(String entity, bool isParameter);
typedef OnUnknownEncoding = bool Function(String encoding);
