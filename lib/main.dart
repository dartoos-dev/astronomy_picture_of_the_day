import 'package:flutter/material.dart';

// ignore_for_file: depend_on_referenced_packages
import 'package:flutter_modular/flutter_modular.dart';

import 'app_module.dart';
import 'app_widget.dart';

void main() {
  runApp(ModularApp(module: AppModule(), child: const AppWidget()));
}
