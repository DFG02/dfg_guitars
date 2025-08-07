import 'package:flutter/material.dart';

class GuitarDetailsView extends StatelessWidget {
  const GuitarDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles de Guitarra'),
      ),
      body: Center(
        child: Text('Detalles de una guitarra específica'),
      ),
    );
  }
}
