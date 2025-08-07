import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class AddGuitarView extends StatelessWidget {
  const AddGuitarView({super.key});

  void _addGuitar(BuildContext context, Map<String, TextEditingController> controllers, String? imagePath) {
    final firestore = FirebaseFirestore.instance;

    final guitarData = {
      'marca': controllers['marca']?.text ?? '',
      'modelo': controllers['modelo']?.text ?? '',
      'precio': int.tryParse(controllers['precio']?.text ?? '0') ?? 0,
      'madera_cuerpo': controllers['madera_cuerpo']?.text ?? '',
      'madera_brazo': controllers['madera_brazo']?.text ?? '',
      'configuracion_pastillas': controllers['configuracion_pastillas']?.text ?? '',
      'tipo_puente': controllers['tipo_puente']?.text ?? '',
      'imageUrl': imagePath ?? '',
    };

    firestore.collection('guitarras').add(guitarData).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Guitarra agregada exitosamente')),
      );
      Navigator.pushNamed(context, '/');
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al agregar guitarra: $error')),
      );
    });
  }

  Future<String?> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    return pickedFile?.path;
  }

  @override
  Widget build(BuildContext context) {
    final controllers = {
      'marca': TextEditingController(),
      'modelo': TextEditingController(),
      'precio': TextEditingController(),
      'madera_cuerpo': TextEditingController(),
      'madera_brazo': TextEditingController(),
      'configuracion_pastillas': TextEditingController(),
      'tipo_puente': TextEditingController(),
    };
    String? imagePath;

    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Guitarra'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: controllers['marca'],
                decoration: InputDecoration(
                  labelText: 'Marca',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 12),
              TextField(
                controller: controllers['modelo'],
                decoration: InputDecoration(
                  labelText: 'Modelo',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 12),
              TextField(
                controller: controllers['precio'],
                decoration: InputDecoration(
                  labelText: 'Precio',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 12),
              TextField(
                controller: controllers['madera_cuerpo'],
                decoration: InputDecoration(
                  labelText: 'Madera del cuerpo',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 12),
              TextField(
                controller: controllers['madera_brazo'],
                decoration: InputDecoration(
                  labelText: 'Madera del brazo',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 12),
              TextField(
                controller: controllers['configuracion_pastillas'],
                decoration: InputDecoration(
                  labelText: 'Configuración de pastillas',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 12),
              TextField(
                controller: controllers['tipo_puente'],
                decoration: InputDecoration(
                  labelText: 'Tipo de puente',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 12),
              ElevatedButton(
                onPressed: () async {
                  imagePath = await _pickImage();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Imagen seleccionada: $imagePath')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                ),
                child: Text('Seleccionar Imagen'),
              ),
              SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => _addGuitar(context, controllers, imagePath),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                ),
                child: Text('Guardar guitarra'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
