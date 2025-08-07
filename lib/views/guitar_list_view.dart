import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

class GuitarListView extends StatelessWidget {
  const GuitarListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/welcome'); //pop
          },
        ),
        title: Text(
          'Lista de Guitarras',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.white),
            onPressed: () {
              // Funcionalidad de búsqueda para el futuro
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.deepPurple.withOpacity(0.1),
              const Color.fromARGB(221, 38, 19, 61),
              const Color.fromARGB(255, 44, 26, 73).withOpacity(0.05),
            ],
          ),
        ),
        child: StreamBuilder(
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
                margin: EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                elevation: 8,
                shadowColor: Colors.deepPurple.withOpacity(0.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                color: Colors.grey[900], // Fondo oscuro para las cards
                child: InkWell(
                  borderRadius: BorderRadius.circular(16.0),
                  onTap: () {
                    Navigator.pushNamed(context, '/details', arguments: {
                      'id': guitars[index].id,
                      ...guitar,
                    });
                  },
                  child: Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Imagen cuadrada con tamaño fijo
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12.0),
                        child: SizedBox(
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
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white, // Texto blanco para tema oscuro
                              ),
                            ),
                            SizedBox(height: 6),
                            Text(
                              guitar['modelo'] ?? 'Sin modelo',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey[300], // Gris claro
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 6),
                            Text(
                              'Precio: ${guitar['precio'] != null && guitar['precio'] > 0 ? '\$${guitar['precio']}' : 'No disponible'}',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.green[400], // Verde más claro para tema oscuro
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 6),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.deepPurple.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'Pastillas: ${guitar['configuracion_pastillas'] ?? 'No disponible'}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.purple[200],
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Botones de acción más elegantes
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.deepPurple.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: Icon(Icons.edit_outlined, color: Colors.deepPurple[200]),
                              onPressed: () {
                                Navigator.pushNamed(context, '/edit', arguments: {
                                  'id': guitars[index].id,
                                  ...guitar,
                                });
                              },
                            ),
                          ),
                          SizedBox(height: 8),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: Icon(Icons.delete_outline, color: Colors.red[300]),
                              onPressed: () {
                                _showDeleteConfirmation(context, guitars[index].id);
                              },
                            ),
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
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, '/add');
        },
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        elevation: 8,
        icon: Icon(Icons.add),
        label: Text('Agregar Guitarra'),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, String guitarId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 28),
              SizedBox(width: 8),
              Text(
                'Confirmar eliminación',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
          content: Text(
            '¿Estás seguro de que deseas eliminar esta guitarra? Esta acción no se puede deshacer.',
            style: TextStyle(color: Colors.grey[300]),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey[400],
              ),
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                 _deleteGuitar(context, guitarId);
                Navigator.of(context).pop();
               
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }

  void _deleteGuitar(BuildContext context, String guitarId) {
    FirebaseFirestore.instance
        .collection('guitarras')
        .doc(guitarId)
        .delete()
        .then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 8),
              Text('Guitarra eliminada exitosamente'),
            ],
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.error, color: Colors.white),
              SizedBox(width: 8),
              Expanded(child: Text('Error al eliminar guitarra: $error')),
            ],
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    });
  }
}
