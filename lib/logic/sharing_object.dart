import 'dart:io' show Platform;

import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import '../conf.dart';

part 'sharing_object.g.dart';

@HiveType(typeId: 1)
class SharingObject {
  @HiveField(0)
  final SharingObjectType type;

  /// path to file if type is file
  /// path to apk if type is app
  /// raw text if type is text
  @HiveField(1)
  final String data;

  @HiveField(2)
  final String name;

  IconData get icon {
    switch (type) {
      case SharingObjectType.file:
        return data.contains(multipleFilesDelimiter)
            ? BootstrapIcons.files
            : _fileIcon;

      case SharingObjectType.text:
        return BootstrapIcons.file_text;

      case SharingObjectType.app:
        return BootstrapIcons.file_binary;

      case SharingObjectType.unknown:
        return BootstrapIcons.file;
    }
  }

// todo review for ios (file naming)
  // todo publish that as a package
  // todo that's a mess
  IconData get _fileIcon {
    const fileMap = {
      ['exe', 'so']: BootstrapIcons.file_binary,
      // https://insights.stackoverflow.com/survey/2020#technology-programming-scripting-and-markup-languages-all-respondents
      [
        'js',
        'ts',
        'html',
        'htm',
        'css',
        'sql',
        'python',
        'java',
        'sh',
        'cs',
        'php',
        'cpp',
        'c',
        'go',
        'kt',
        'rb',
        'asm',
        'rust',
        'r',
        'dart',
        'xml',
        'yaml',
        'toml'
      ]: BootstrapIcons.file_code,
      ['diff']: BootstrapIcons.file_diff,
      // https://support.microsoft.com/en-us/office/file-formats-that-are-supported-in-excel-0943ff2c-6014-4e8d-aaea-b83d51d46247
      [
        'xlsx',
        'xlsm',
        'xlsb',
        'xltx',
        'xltm',
        'xls',
        'xlt',
        'xla',
        'xlw',
        'xlam'
      ]: BootstrapIcons.file_excel,
      // https://fileinfo.com/filetypes/font#:~:text=Font%20Files&text=Most%20modern%20fonts%20are%20stored,TTF%2C%20and%20.
      ['jfproj', 'woff', 'ttf', 'otf']: BootstrapIcons.file_font,
      ['png', 'jpg', 'gif', 'svg', 'ai', 'psd']: BootstrapIcons.file_image,
      ['mp3', 'odd']: BootstrapIcons.file_music,
      ['pdf']: BootstrapIcons.file_pdf,
      ['mp4', 'avi', 'webm', 'sub', 'srt', 'mpv']: BootstrapIcons.file_play,
      // https://support.microsoft.com/en-us/office/file-formats-that-are-supported-in-powerpoint-252c6fa0-a4bc-41be-ac82-b77c9773f9dc
      ['pptx', 'pptm', 'ppt', 'potx', 'potm', 'pot']: BootstrapIcons.file_ppt,
      ['md', 'rmd', 'ltx', 'tex']: BootstrapIcons.file_richtext,
      ['xps', 'odp']: BootstrapIcons.file_slides,
      ['csv']: BootstrapIcons.file_spreadsheet,
      ['doc', 'docm', 'docx', 'rtf']: BootstrapIcons.file_word,
      ['zip', 'rar', '7z', 'tar', 'xf']: BootstrapIcons.file_zip
    };

    final fileExtension = name.toLowerCase().split('.').last;

    for (final icon in fileMap.entries) {
      for (final extensions in icon.key) {
        if (fileExtension == extensions) {
          return icon.value;
        }
      }
    }

    return BootstrapIcons.file;
  }

  SharingObject({required this.type, required this.data, required this.name});

  static String getSharingName(SharingObjectType type, String data) {
    switch (type) {
      case SharingObjectType.file:
        return '${data.contains(multipleFilesDelimiter) ? '${data.split(multipleFilesDelimiter).length}: ' : ''}${data.split(multipleFilesDelimiter).map((e) => e.split(Platform.isWindows ? '\\' : '/').last).join(" ")}';
      case SharingObjectType.text:
        final _ = data.trim().replaceAll('\n', ' ');
        return _.length >= 101 ? _.substring(0, 100) : _;
      case SharingObjectType.app:
        throw Exception('when type is app, name is necessary');
      case SharingObjectType.unknown:
        throw Exception(
            'Unknown type is reserved only for backwards compatability');
    }
  }
}

@HiveType(typeId: 2)
enum SharingObjectType {
  @HiveField(0)
  file,
  @HiveField(1)
  text,
  @HiveField(2)
  app,
// If, in the future, we introduce more types, the unknown type will be used as a fallback, and won't break the receiver function
  @HiveField(3)
  unknown
}

SharingObjectType string2fileType(String type) {
  switch (type) {
    case 'file':
      return SharingObjectType.file;

    case 'text':
      return SharingObjectType.text;

    case 'app':
      return SharingObjectType.app;
  }
  return SharingObjectType.unknown;
}
