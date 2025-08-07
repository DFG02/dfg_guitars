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
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color.fromARGB(255, 69, 49, 103).withOpacity(0.1),
              const Color.fromARGB(255, 36, 12, 55),
              const Color.fromARGB(255, 44, 22, 62).withOpacity(0.1),
            ],
          ),
        ),
        child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Imagen centrada y ampliable
            Center(
              child: GestureDetector(
                onTap: () {
                  _showImageDialog(context, imageUrl);
                },
                child: Hero(
                  tag: 'guitar_image_${guitar['id']}',
                  child: Container(
                    margin: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 8.0,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: MediaQuery.of(context).size.width * 0.9,
                        child: imageUrl.startsWith('http')
                            ? Image.network(
                                imageUrl,
                                fit: BoxFit.cover,
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Center(
                                    child: CircularProgressIndicator(
                                      value: loadingProgress.expectedTotalBytes != null
                                          ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                                          : null,
                                    ),
                                  );
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: Colors.grey[300],
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.broken_image, size: 80, color: Colors.grey[600]),
                                        SizedBox(height: 8),
                                        Text('Error al cargar imagen', style: TextStyle(color: Colors.grey[600])),
                                      ],
                                    ),
                                  );
                                },
                              )
                            : imageUrl.isNotEmpty
                                ? Image.file(
                                    File(imageUrl),
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        color: Colors.grey[300],
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.broken_image, size: 80, color: Colors.grey[600]),
                                            SizedBox(height: 8),
                                            Text('Error al cargar imagen', style: TextStyle(color: Colors.grey[600])),
                                          ],
                                        ),
                                      );
                                    },
                                  )
                                : Container(
                                    color: Colors.grey[300],
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.image, size: 80, color: Colors.grey[600]),
                                        SizedBox(height: 8),
                                        Text('Sin imagen', style: TextStyle(color: Colors.grey[600])),
                                      ],
                                    ),
                                  ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Indicador de que se puede tocar para ampliar
            Text(
              'Toca la imagen para ampliarla',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Card para información básica
                  Card(
                    elevation: 4,
                    margin: EdgeInsets.only(bottom: 16),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Información Básica',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple,
                            ),
                          ),
                          SizedBox(height: 12),
                          _buildInfoRow(Icons.label, 'Marca', guitar['marca'] ?? 'Sin marca'),
                          _buildInfoRow(Icons.music_note, 'Modelo', guitar['modelo'] ?? 'Sin modelo'),
                          _buildInfoRow(Icons.attach_money, 'Precio', 
                            guitar['precio'] != null && guitar['precio'] > 0 
                              ? '\$${guitar['precio']}' 
                              : 'No disponible'),
                        ],
                      ),
                    ),
                  ),
                  // Card para especificaciones técnicas
                  Card(
                    elevation: 4,
                    margin: EdgeInsets.only(bottom: 16),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Especificaciones Técnicas',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple,
                            ),
                          ),
                          SizedBox(height: 12),
                          _buildInfoRow(Icons.park, 'Madera del cuerpo', guitar['madera_cuerpo'] ?? 'No especificada'),
                          _buildInfoRow(Icons.linear_scale, 'Madera del brazo', guitar['madera_brazo'] ?? 'No especificada'),
                          _buildInfoRow(Icons.electrical_services, 'Pastillas', guitar['configuracion_pastillas'] ?? 'No especificadas'),
                          _buildInfoRow(Icons.cable, 'Tipo de puente', guitar['tipo_puente'] ?? 'No especificado'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: Colors.deepPurple,
          ),
          SizedBox(width: 12),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(fontSize: 16, color: const Color.fromARGB(221, 201, 197, 204)),
                children: [
                  TextSpan(
                    text: '$label: ',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: const Color.fromARGB(255, 220, 209, 226),
                    ),
                  ),
                  TextSpan(
                    text: value,
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showImageDialog(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.black87,
          insetPadding: EdgeInsets.all(10),
          child: Stack(
            children: [
              // Imagen con zoom interactivo
              InteractiveViewer(
                panEnabled: true, // Permite mover la imagen
                boundaryMargin: EdgeInsets.all(20),
                minScale: 0.5,
                maxScale: 4.0,
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: Container(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.95,
                          maxHeight: MediaQuery.of(context).size.height * 0.85,
                        ),
                        child: imageUrl.startsWith('http')
                            ? Image.network(
                                imageUrl,
                                fit: BoxFit.contain,
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Container(
                                    width: MediaQuery.of(context).size.width * 0.95,
                                    height: MediaQuery.of(context).size.height * 0.85,
                                    color: Colors.black54,
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        value: loadingProgress.expectedTotalBytes != null
                                            ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                                            : null,
                                      ),
                                    ),
                                  );
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: MediaQuery.of(context).size.width * 0.95,
                                    height: MediaQuery.of(context).size.height * 0.85,
                                    color: Colors.black54,
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.broken_image, size: 100, color: Colors.white),
                                          SizedBox(height: 16),
                                          Text('Error al cargar imagen', style: TextStyle(color: Colors.white)),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              )
                            : imageUrl.isNotEmpty
                                ? Image.file(
                                    File(imageUrl),
                                    fit: BoxFit.contain,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        width: MediaQuery.of(context).size.width * 0.95,
                                        height: MediaQuery.of(context).size.height * 0.85,
                                        color: Colors.black54,
                                        child: Center(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.broken_image, size: 100, color: Colors.white),
                                              SizedBox(height: 16),
                                              Text('Error al cargar imagen', style: TextStyle(color: Colors.white)),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  )
                                : Container(
                                    width: MediaQuery.of(context).size.width * 0.95,
                                    height: MediaQuery.of(context).size.height * 0.85,
                                    color: Colors.black54,
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.image, size: 100, color: Colors.white),
                                          SizedBox(height: 16),
                                          Text('Sin imagen disponible', style: TextStyle(color: Colors.white)),
                                        ],
                                      ),
                                    ),
                                  ),
                      ),
                    ),
                  ),
                ),
              ),
              // Botón de cerrar en la esquina superior derecha
              Positioned(
                top: 20,
                right: 20,
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ),
              // Instrucciones de uso en la parte inferior
              Positioned(
                bottom: 30,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Pellizca para hacer zoom • Arrastra para mover',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
