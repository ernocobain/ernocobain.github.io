import 'package:cms_flutter/services/draft_service.dart';
import 'package:flutter/material.dart';

class EditorController {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final TextEditingController slugController = TextEditingController();
  final TextEditingController dateController = TextEditingController(); // bisa gunakan `TextField` dengan `DatePicker`
  void clear() {
    titleController.clear();
    contentController.clear();
    slugController.clear();
    dateController.clear();
    DraftService.clearDraft();
  }
}



