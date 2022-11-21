import 'package:flutter/material.dart';

class NewNotesView extends StatelessWidget {
  const NewNotesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New notes'),
      ),
      body: const Text('New notes view'),
    );
  }
}
