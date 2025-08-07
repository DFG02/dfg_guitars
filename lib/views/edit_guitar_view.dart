import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class EditGuitarView extends StatelessWidget {
  const EditGuitarView({super.key});

  void _editGuitar(BuildContext context, Map<String, TextEditingController> controllers, String id, String? imagePath) {
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

    firestore.collection('guitarras').doc(id).update(guitarData).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Guitarra editada exitosamente')),
      );
      Navigator.pushNamed(context, '/');
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al editar guitarra: $error')),
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
    final guitar = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (guitar == null || !guitar.containsKey('id')) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: Datos de guitarra no válidos')),
        );
        Navigator.pop(context);
      });
      return Scaffold(
        appBar: AppBar(
          title: Text('Editar Guitarra'),
        ),
        body: Center(
          child: Text('Error: Datos de guitarra no válidos'),
        ),
      );
    }

    final controllers = {
      'marca': TextEditingController(text: guitar['marca']),
      'modelo': TextEditingController(text: guitar['modelo']),
      'precio': TextEditingController(text: guitar['precio']?.toString()),
      'madera_cuerpo': TextEditingController(text: guitar['madera_cuerpo']),
      'madera_brazo': TextEditingController(text: guitar['madera_brazo']),
      'configuracion_pastillas': TextEditingController(text: guitar['configuracion_pastillas']),
      'tipo_puente': TextEditingController(text: guitar['tipo_puente']),
    };
    String? imagePath = guitar['imageUrl'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Guitarra'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Formulario para editar una guitarra', style: TextStyle(fontSize: 18)),
              SizedBox(height: 20),
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
                onPressed: () => _editGuitar(context, controllers, guitar['id'], imagePath),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                ),
                child: Text('Guardar cambios'),
              ),
              SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                  foregroundColor: Colors.white,
                ),
                child: Text('Cancelar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
