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

import 'package:meta/meta.dart';

enum XmlStatus { initialized, parsing, finished, suspended }

enum XmlError {
  none,
  noMemory,
  syntax,
  noElements,
  invalidToken,
  unclosedToken,
  partialChar,
  tagMismatch,
  duplicateAttribute,
  junkAfterDocElement,
  paramEntityRef,
  undefinedEntity,
  recursiveEntityRef,
  asyncEntity,
  badCharRef,
  binaryEntityRef,
  attributeExternalEntityRef,
  misplacedXmlPi,
  unknownEncoding,
  incorrectEncoding,
  unclosedCdataSection,
  externalEntityHandling,
  notStandalone,
  unexpectedState,
  entityDeclaredInPe,
  featureRequiresXmlDtd,
  cantChangeFeatureOnceParsing,
  /* added in 1.95.7. */
  unboundPrefix,
  /* added in 1.95.8. */
  undeclaringPrefix,
  incompletePe,
  xmlDecl,
  textDecl,
  publicid,
  suspended,
  notSuspended,
  aborted,
  finished,
  suspendPe,
  /* added in 2.0. */
  reservedPrefixXml,
  reservedPrefixXmlns,
  reservedNamespaceUri,
  /* added in 2.2.1. */
  invalidArgument
}

enum XmlContentType {
  @visibleForTesting
  unused,
  empty,
  any,
  mixed,
  name,
  choice,
  seq,
}

enum XmlContentQuant { none, opt, rep, plus }

enum XmlParamEntityParsing { never, unlessStandalone, always }
