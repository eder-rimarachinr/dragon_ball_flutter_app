import 'package:dbz_app/models/transformation_model.dart';
import 'package:flutter/material.dart';

class TransformationDetailScreen extends StatelessWidget {
  final TransformationResponse transformation;
  const TransformationDetailScreen({super.key, required this.transformation});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transformation Detail'),
      ),
    );
  }
}
