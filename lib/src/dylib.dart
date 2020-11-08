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
import 'dart:io';

import 'package:expat/src/bindings.dart';

LibExpat _dylib;
LibExpat get dylib => _dylib ?? LibExpat(LibraryLoader.load());

extension StringWith on String {
  String prefixWith(String prefix) {
    if (isEmpty || startsWith(prefix)) return this;
    return prefix + this;
  }

  String suffixWith(String suffix) {
    if (isEmpty || endsWith(suffix)) return this;
    return this + suffix;
  }
}

class LibraryLoader {
  static String get platformPrefix => Platform.isWindows ? '' : 'lib';

  static String get platformSuffix {
    return Platform.isWindows
        ? '.dll'
        : Platform.isMacOS || Platform.isIOS
            ? '.dylib'
            : '.so';
  }

  static String fixupName(String baseName) {
    return baseName.prefixWith(platformPrefix).suffixWith(platformSuffix);
  }

  static String fixupPath(String path) => path.suffixWith('/');

  static bool isFile(String path) {
    return path.isNotEmpty &&
        Directory(path).statSync().type == FileSystemEntityType.file;
  }

  static String resolvePath() {
    final path = String.fromEnvironment(
      'LIBEXPAT_PATH',
      defaultValue: Platform.environment['LIBEXPAT_PATH'] ?? '',
    );
    if (isFile(path)) return path;
    return fixupPath(path) + fixupName('expat');
  }

  static ffi.DynamicLibrary load() =>
      Platform.environment['LIBEXPAT_STATIC'] != null
          ? ffi.DynamicLibrary.process()
          : ffi.DynamicLibrary.open(resolvePath());
}
