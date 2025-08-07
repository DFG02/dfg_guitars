import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

class GuitarListView extends StatelessWidget {
  const GuitarListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Guitarras'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('guitarras').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error al cargar guitarras'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No hay guitarras disponibles'));
          }

          final guitars = snapshot.data!.docs;

          return ListView.builder(
            itemCount: guitars.length,
            itemBuilder: (context, index) {
              final guitar = guitars[index].data() as Map<String, dynamic>;
              final imageUrl = guitar['imageUrl'] ?? '';

              return Card(
                margin: EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, '/details', arguments: {
                      'id': guitars[index].id,
                      ...guitar,
                    });
                  },
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Imagen cuadrada con tamaño fijo
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Container(
                          width: 240,
                          height: 240,
                          child: imageUrl.startsWith('http')
                              ? Image.network(
                                  imageUrl,
                                  fit: BoxFit.cover,
                                  loadingBuilder: (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Center(
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        value: loadingProgress.expectedTotalBytes != null
                                            ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                                            : null,
                                      ),
                                    );
                                  },
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: Colors.grey[300],
                                      child: Icon(Icons.broken_image, size: 50, color: Colors.grey[600]),
                                    );
                                  },
                                )
                              : imageUrl.isNotEmpty
                                  ? Image.file(
                                      File(imageUrl),
                                      fit: BoxFit.cover,
                                    )
                                  : Container(
                                      color: Colors.grey[300],
                                      child: Icon(Icons.image, size: 50, color: Colors.grey[600]),
                                    ),
                        ),
                      ),
                      SizedBox(width: 12),
                      // Contenido de texto expandido
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              guitar['marca'] ?? 'Sin marca',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              guitar['modelo'] ?? 'Sin modelo',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Precio: ${guitar['precio'] != null && guitar['precio'] > 0 ? '\$${guitar['precio']}' : 'No disponible'}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.green[700],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Pastillas: ${guitar['configuracion_pastillas'] ?? 'No disponible'}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      // Botones de acción
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.deepPurple),
                            onPressed: () {
                              Navigator.pushNamed(context, '/edit', arguments: {
                                'id': guitars[index].id,
                                ...guitar,
                              });
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              FirebaseFirestore.instance
                                  .collection('guitarras')
                                  .doc(guitars[index].id)
                                  .delete()
                                  .then((_) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Guitarra eliminada')),
                                );
                              }).catchError((error) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Error al eliminar guitarra: $error')),
                                );
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add');
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
