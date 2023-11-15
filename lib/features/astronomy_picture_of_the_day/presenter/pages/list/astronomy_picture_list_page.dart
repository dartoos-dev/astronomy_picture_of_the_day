import 'package:flutter/material.dart';

class AstronomyPictureListPage extends StatelessWidget {
  const AstronomyPictureListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Picture List')),
      body: const Center(child: Text('Astronomy Picture List Page')),
    );
  }
}
