import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

class AstronomyPictureListPage extends StatelessWidget {
  const AstronomyPictureListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Picture List')),
      body: Center(child: Text('welcome-text'.i18n())),
    );
  }
}
