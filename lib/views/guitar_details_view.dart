import 'package:flutter/material.dart';
import 'dart:io';

class GuitarDetailsView extends StatelessWidget {
  const GuitarDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final guitar = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final imageUrl = guitar['imageUrl'] ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text(guitar['marca'] ?? 'Detalles de la guitarra'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            imageUrl.startsWith('http')
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Container(
                      width: 300,
                      height: 300,
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 300,
                            height: 300,
                            color: Colors.grey,
                            child: Icon(Icons.broken_image, size: 100, color: Colors.white),
                          );
                        },
                      ),
                    ),
                  )
                : imageUrl.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Container(
                          width: 300,
                          height: 300,
                          child: Image.file(
                            File(imageUrl),
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    : Container(
                        width: 300,
                        height: 300,
                        color: Colors.grey,
                        child: Icon(Icons.image, size: 100, color: Colors.white),
                      ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Marca: ${guitar['marca'] ?? 'Sin marca'}',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Modelo: ${guitar['modelo'] ?? 'Sin modelo'}',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Precio: ${guitar['precio'] ?? 'N/A'}',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Madera del cuerpo: ${guitar['madera_cuerpo'] ?? 'N/A'}',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Madera del brazo: ${guitar['madera_brazo'] ?? 'N/A'}',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Configuración de pastillas: ${guitar['configuracion_pastillas'] ?? 'N/A'}',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Tipo de puente: ${guitar['tipo_puente'] ?? 'N/A'}',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
