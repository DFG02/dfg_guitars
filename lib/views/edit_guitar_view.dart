import 'package:flutter/material.dart';

class EditGuitarView extends StatelessWidget {
  const EditGuitarView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Guitarra'),
      ),
      body: Center(
        child: Text('Formulario para editar una guitarra'),
      ),
    );
  }
}
