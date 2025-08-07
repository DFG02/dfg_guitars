import 'package:flutter/material.dart';

class AddGuitarView extends StatelessWidget {
  const AddGuitarView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Guitarra'),
      ),
      body: Center(
        child: Text('Formulario para agregar una guitarra'),
      ),
    );
  }
}
