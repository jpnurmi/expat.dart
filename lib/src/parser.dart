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

import 'dart:ffi' as ffi;

import 'package:ffi/ffi.dart' as ffi;
import 'package:expat/src/bindings.dart';
import 'package:expat/src/callbacks.dart';
import 'package:expat/src/dylib.dart';
import 'package:expat/src/enums.dart';
import 'package:expat/src/extensions.dart';

class XmlParser {
  OnStartElement onStartElement;
  OnEndElement onEndElement;
  OnStartCharacterData onStartCharacterData;
  OnCharacterData onCharacterData;
  OnEndCharacterData onEndCharacterData;
  OnProcessingInstruction onProcessingInstruction;
  OnComment onComment;
  OnDefault onDefault;
  OnStartDoctypeDecl onStartDoctypeDecl;
  OnEndDoctypeDecl onEndDoctypeDecl;
  OnEntityDecl onEntityDecl;
  OnNotationDecl onNotationDecl;
  OnStartNamespaceDecl onStartNamespaceDecl;
  OnEndNamespaceDecl onEndNamespaceDecl;
  OnNotStandalone onNotStandalone;
  OnExternalEntityRef onExternalEntityRef;
  OnSkippedEntity onSkippedEntity;
  OnUnknownEncoding onUnknownEncoding;

  final ffi.Pointer<XML_ParserStruct> _parser;
  static final _instances = <ffi.Pointer, XmlParser>{};

  XmlParser({
    this.onStartElement,
    this.onEndElement,
    this.onStartCharacterData,
    this.onCharacterData,
    this.onEndCharacterData,
    this.onProcessingInstruction,
    this.onComment,
    this.onDefault,
    this.onStartDoctypeDecl,
    this.onEndDoctypeDecl,
    this.onEntityDecl,
    this.onNotationDecl,
    this.onStartNamespaceDecl,
    this.onEndNamespaceDecl,
    this.onNotStandalone,
    this.onExternalEntityRef,
    this.onSkippedEntity,
    this.onUnknownEncoding,
    String encoding = 'UTF-8',
    String namespaceSeparator = '',
  })  : assert(namespaceSeparator.length <= 1),
        _parser = _create(encoding, namespaceSeparator) {
    _instances[_parser] = this;
  }

  static ffi.Pointer<XML_ParserStruct> _create(String enc, String nsp) {
    final cstr = ffi.Utf8.toUtf8(enc);
    final parser = nsp.isEmpty
        ? dylib.XML_ParserCreate(cstr.cast())
        : dylib.XML_ParserCreateNS(cstr.cast(), nsp.codeUnitAt(0));
    dylib.XML_UseParserAsHandlerArg(parser);
    _initHandlers(parser);
    ffi.free(cstr);
    return parser;
  }

  static void _initHandlers(ffi.Pointer<XML_ParserStruct> parser) {
    dylib.XML_SetElementHandler(
      parser,
      ffi.Pointer.fromFunction(_handleStartElement),
      ffi.Pointer.fromFunction(_handleEndElement),
    );
    dylib.XML_SetCdataSectionHandler(
      parser,
      ffi.Pointer.fromFunction(_handleStartCharacterData),
      ffi.Pointer.fromFunction(_handleEndCharacterData),
    );
    dylib.XML_SetCharacterDataHandler(
      parser,
      ffi.Pointer.fromFunction(_handleCharacterData),
    );
    dylib.XML_SetProcessingInstructionHandler(
      parser,
      ffi.Pointer.fromFunction(_handleProcessingInstruction),
    );
    dylib.XML_SetCommentHandler(
      parser,
      ffi.Pointer.fromFunction(_handleComment),
    );
    dylib.XML_SetDefaultHandler(
      parser,
      ffi.Pointer.fromFunction(_handleDefault),
    );
    dylib.XML_SetDoctypeDeclHandler(
      parser,
      ffi.Pointer.fromFunction(_handleStartDoctypeDecl),
      ffi.Pointer.fromFunction(_handleEndDoctypeDecl),
    );
    dylib.XML_SetEntityDeclHandler(
      parser,
      ffi.Pointer.fromFunction(_handleEntityDecl),
    );
    dylib.XML_SetNotationDeclHandler(
      parser,
      ffi.Pointer.fromFunction(_handleNotationDecl),
    );
    dylib.XML_SetNamespaceDeclHandler(
      parser,
      ffi.Pointer.fromFunction(_handleStartNamespaceDecl),
      ffi.Pointer.fromFunction(_handleEndNamespaceDecl),
    );
    dylib.XML_SetNotStandaloneHandler(
      parser,
      ffi.Pointer.fromFunction(_handleNotStandalone, XML_STATUS_OK),
    );
    dylib.XML_SetExternalEntityRefHandler(
      parser,
      ffi.Pointer.fromFunction(_handleExternalEntityRef, XML_STATUS_OK),
    );
    dylib.XML_SetSkippedEntityHandler(
      parser,
      ffi.Pointer.fromFunction(_handleSkippedEntity),
    );
    dylib.XML_SetUnknownEncodingHandler(
      parser,
      ffi.Pointer.fromFunction(_handleUnknownEncoding, XML_STATUS_OK),
      ffi.nullptr,
    );
  }

  static void _handleStartElement(
    ffi.Pointer<ffi.Void> userData,
    ffi.Pointer<ffi.Int8> name,
    ffi.Pointer<ffi.Pointer<ffi.Int8>> atts,
  ) {
    final parser = _instances[userData];
    parser?.onStartElement?.call(name.toStr(), atts.toStrList());
  }

  static void _handleEndElement(
    ffi.Pointer<ffi.Void> userData,
    ffi.Pointer<ffi.Int8> name,
  ) {
    final parser = _instances[userData];
    parser?.onEndElement?.call(name.toStr());
  }

  static void _handleStartCharacterData(
    ffi.Pointer<ffi.Void> userData,
  ) {
    final parser = _instances[userData];
    parser?.onStartCharacterData?.call();
  }

  static void _handleCharacterData(
    ffi.Pointer<ffi.Void> userData,
    ffi.Pointer<ffi.Int8> data,
    int length,
  ) {
    final parser = _instances[userData];
    parser?.onCharacterData?.call(data.toStr(length));
  }

  static void _handleEndCharacterData(ffi.Pointer<ffi.Void> userData) {
    final parser = _instances[userData];
    parser?.onEndCharacterData?.call();
  }

  static void _handleProcessingInstruction(
    ffi.Pointer<ffi.Void> userData,
    ffi.Pointer<ffi.Int8> target,
    ffi.Pointer<ffi.Int8> data,
  ) {
    final parser = _instances[userData];
    parser?.onProcessingInstruction?.call(target.toStr(), data.toStr());
  }

  static void _handleComment(
    ffi.Pointer<ffi.Void> userData,
    ffi.Pointer<ffi.Int8> comment,
  ) {
    final parser = _instances[userData];
    parser?.onComment?.call(comment.toStr());
  }

  static void _handleDefault(
    ffi.Pointer<ffi.Void> userData,
    ffi.Pointer<ffi.Int8> data,
    int length,
  ) {
    final parser = _instances[userData];
    parser?.onDefault?.call(data.toStr(length));
  }

  static void _handleStartDoctypeDecl(
    ffi.Pointer<ffi.Void> userData,
    ffi.Pointer<ffi.Int8> doctype,
    ffi.Pointer<ffi.Int8> systemId,
    ffi.Pointer<ffi.Int8> publicId,
    int hasInternalSubset,
  ) {
    final parser = _instances[userData];
    parser?.onStartDoctypeDecl?.call(
      doctype.toStr(),
      systemId.toStr(),
      publicId.toStr(),
      hasInternalSubset == XML_TRUE,
    );
  }

  static void _handleEndDoctypeDecl(
    ffi.Pointer<ffi.Void> userData,
  ) {
    final parser = _instances[userData];
    parser?.onEndDoctypeDecl?.call();
  }

  static void _handleEntityDecl(
    ffi.Pointer<ffi.Void> userData,
    ffi.Pointer<ffi.Int8> entity,
    int isParameterEntity,
    ffi.Pointer<ffi.Int8> value,
    int length,
    ffi.Pointer<ffi.Int8> base,
    ffi.Pointer<ffi.Int8> systemId,
    ffi.Pointer<ffi.Int8> publicId,
    ffi.Pointer<ffi.Int8> notation,
  ) {
    final parser = _instances[userData];
    parser?.onEntityDecl?.call(
      entity.toStr(),
      isParameterEntity == XML_TRUE,
      value.toStr(length),
      base.toStr(),
      systemId.toStr(),
      publicId.toStr(),
      notation.toStr(),
    );
  }

  static void _handleNotationDecl(
    ffi.Pointer<ffi.Void> userData,
    ffi.Pointer<ffi.Int8> notation,
    ffi.Pointer<ffi.Int8> base,
    ffi.Pointer<ffi.Int8> systemId,
    ffi.Pointer<ffi.Int8> publicId,
  ) {
    final parser = _instances[userData];
    parser?.onNotationDecl?.call(
      notation.toStr(),
      base.toStr(),
      systemId.toStr(),
      publicId.toStr(),
    );
  }

  static void _handleStartNamespaceDecl(
    ffi.Pointer<ffi.Void> userData,
    ffi.Pointer<ffi.Int8> prefix,
    ffi.Pointer<ffi.Int8> uri,
  ) {
    final parser = _instances[userData];
    parser?.onStartNamespaceDecl?.call(prefix.toStr(), uri.toStr());
  }

  static void _handleEndNamespaceDecl(
    ffi.Pointer<ffi.Void> userData,
    ffi.Pointer<ffi.Int8> prefix,
  ) {
    final parser = _instances[userData];
    parser?.onEndNamespaceDecl?.call(prefix.toStr());
  }

  static int _handleNotStandalone(ffi.Pointer<ffi.Void> userData) {
    final parser = _instances[userData];
    return parser?.onNotStandalone?.call() ?? true
        ? XML_STATUS_OK
        : XML_STATUS_ERROR;
  }

  static int _handleExternalEntityRef(
    ffi.Pointer<XML_ParserStruct> userData,
    ffi.Pointer<ffi.Int8> context,
    ffi.Pointer<ffi.Int8> base,
    ffi.Pointer<ffi.Int8> systemId,
    ffi.Pointer<ffi.Int8> publicId,
  ) {
    final parser = _instances[userData];
    return parser?.onExternalEntityRef?.call(
              context.toStr(),
              base.toStr(),
              systemId.toStr(),
              publicId.toStr(),
            ) ??
            true
        ? XML_STATUS_OK
        : XML_STATUS_ERROR;
  }

  static void _handleSkippedEntity(
    ffi.Pointer<ffi.Void> userData,
    ffi.Pointer<ffi.Int8> entity,
    int isParameter,
  ) {
    final parser = _instances[userData];
    parser?.onSkippedEntity?.call(entity.toStr(), isParameter == XML_TRUE);
  }

  static int _handleUnknownEncoding(
    ffi.Pointer<ffi.Void> userData,
    ffi.Pointer<ffi.Int8> encoding,
    ffi.Pointer<XML_Encoding> info, // ### TODO
  ) {
    final parser = _instances[userData];
    return parser?.onUnknownEncoding?.call(encoding.toStr()) ?? true
        ? XML_STATUS_OK
        : XML_STATUS_ERROR;
  }

  String get base {
    final cstr = dylib.XML_GetBase(_parser);
    return ffi.Utf8.fromUtf8(cstr.cast());
  }

  set base(String base) {
    final cstr = ffi.Utf8.toUtf8(base);
    dylib.XML_SetBase(_parser, cstr.cast());
    ffi.free(cstr);
  }

  String buffer(int length) {
    final cstr = dylib.XML_GetBuffer(_parser, length);
    return ffi.Utf8.fromUtf8(cstr.cast());
  }

  bool parse({String xml, int length, bool isFinal}) {
    assert(xml != null || length >= 0);
    if (xml == null) {
      final res = dylib.XML_ParseBuffer(
        _parser,
        length,
        isFinal?.toInt() ?? XML_FALSE,
      );
      return res == XML_STATUS_OK;
    } else {
      final cstr = ffi.Utf8.toUtf8(xml);
      final len = length ?? xml.length;
      final res = dylib.XML_Parse(
        _parser,
        cstr.cast(),
        len,
        isFinal?.toInt() ?? len == xml.length ? XML_TRUE : XML_FALSE,
      );
      ffi.free(cstr);
      return res == XML_STATUS_OK;
    }
  }

  bool stop({bool resumable = false}) {
    final res = dylib.XML_StopParser(_parser, resumable.toInt());
    return res == XML_STATUS_OK;
  }

  bool resume() {
    final ret = dylib.XML_ResumeParser(_parser);
    return ret == XML_STATUS_OK;
  }

  void defaultCurrent() {
    dylib.XML_DefaultCurrent(_parser);
  }

  bool reset([String encoding = 'UTF-8']) {
    final cstr = ffi.Utf8.toUtf8(encoding);
    final res = dylib.XML_ParserReset(_parser, cstr.cast());
    ffi.free(cstr);
    return res == XML_TRUE;
  }

  set useForeignDtd(bool use) {
    dylib.XML_UseForeignDTD(_parser, use.toInt());
  }

  set paramEntityParsing(XmlParamEntityParsing parsing) {
    dylib.XML_SetParamEntityParsing(_parser, parsing.index);
  }

  set hashSalt(int hashSalt) {
    dylib.XML_SetHashSalt(_parser, hashSalt);
  }

  XmlStatus get status {
    final status = ffi.allocate<ffi.Uint32>();
    dylib.XML_GetParsingStatus(_parser, status.cast());
    final index = status.value;
    ffi.free(status);
    return XmlStatus.values[index];
  }

  XmlError get errorCode {
    final index = dylib.XML_GetErrorCode(_parser);
    return XmlError.values[index];
  }

  String get errorString {
    final str = dylib.XML_ErrorString(errorCode.index);
    return ffi.Utf8.fromUtf8(str.cast());
  }

  int get currentLineNumber {
    return dylib.XML_GetCurrentLineNumber(_parser);
  }

  int get currentColumnNumber {
    return dylib.XML_GetCurrentColumnNumber(_parser);
  }

  int get currentByteIndex {
    return dylib.XML_GetCurrentByteIndex(_parser);
  }

  int get currentByteCount {
    return dylib.XML_GetCurrentByteCount(_parser);
  }

  void dispose() {
    _instances.remove(_parser);
    dylib.XML_ParserFree(_parser);
  }
}
