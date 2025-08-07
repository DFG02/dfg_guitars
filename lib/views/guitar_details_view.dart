import 'package:flutter/material.dart';

class GuitarDetailsView extends StatelessWidget {
  const GuitarDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final guitar = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;

    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles de Guitarra'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Marca: ${guitar['marca'] ?? 'Sin marca'}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Text(
              'Modelo: ${guitar['modelo'] ?? 'Sin modelo'}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 12),
            Text(
              'Precio: ${guitar['precio'] ?? 'N/A'}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 12),
            Text(
              'Madera del cuerpo: ${guitar['madera_cuerpo'] ?? 'N/A'}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 12),
            Text(
              'Madera del brazo: ${guitar['madera_brazo'] ?? 'N/A'}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 12),
            Text(
              'Configuración de pastillas: ${guitar['configuracion_pastillas'] ?? 'N/A'}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 12),
            Text(
              'Tipo de puente: ${guitar['tipo_puente'] ?? 'N/A'}',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
