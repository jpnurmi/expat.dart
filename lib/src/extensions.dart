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

import 'dart:convert';
import 'dart:ffi' as ffi;
import 'dart:typed_data';

import 'package:ffi/ffi.dart' as ffi;
import 'package:expat/src/bindings.dart';

extension XmlBool on bool {
  int toInt() => this ? XML_TRUE : XML_FALSE;
}

extension XmlString on ffi.Pointer<ffi.Int8> {
  String toStr([int length]) {
    length ??= ffi.Utf8.strlen(cast());
    return utf8.decode(Int8List.view(asTypedList(length).buffer, 0, length));
  }
}

extension XmlStringList on ffi.Pointer<ffi.Pointer<ffi.Int8>> {
  List<String> toStrList() {
    var i = 0;
    var strings = <String>[];
    while (this[i] != ffi.nullptr) {
      strings.add(this[i++].toStr());
    }
    return strings;
  }
}
