import 'package:flutter/material.dart';

class GuitarListView extends StatelessWidget {
  const GuitarListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Guitarras'),
      ),
      body: Center(
        child: Text('Aquí se mostrará la lista de guitarras'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navegar a la vista de agregar guitarra
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
