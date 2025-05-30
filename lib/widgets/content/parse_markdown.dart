import 'dart:convert';

import 'package:cms_flutter/widgets/editor_controler.dart';

void parseMarkdown({
  required String base64Content,
  required EditorController controller,
}) {
  final cleanedBase64 = base64Content.replaceAll('\n', '');
  final decoded = utf8.decode(base64Decode(cleanedBase64));
  final lines = LineSplitter.split(decoded).toList();

  String? title;
  String? slug;
  String? date;
  final buffer = StringBuffer();
  bool isBody = false;
  int frontmatterCount = 0;

  for (final line in lines) {
    if (line.trim() == '---') {
      frontmatterCount++;
      if (frontmatterCount == 2) {
        isBody = true;
        continue;
      }
      continue;
    }

    if (!isBody) {
      if (line.startsWith('title:')) {
        title = line.replaceFirst('title:', '').trim().replaceAll('"', '');
      } else if (line.startsWith('slug:')) {
        slug = line.replaceFirst('slug:', '').trim().replaceAll('"', '');
      } else if (line.startsWith('date:')) {
        date = line.replaceFirst('date:', '').trim();
      }
    } else {
      buffer.writeln(line);
    }
  }

  controller.titleController.text = title ?? '';
  controller.slugController.text = slug ?? '';
  controller.dateController.text = date ?? '';
  controller.contentController.text = buffer.toString().trim();
}
