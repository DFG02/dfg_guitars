import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'guitar_dropdown_field.dart';
import 'dart:io';

class GuitarForm extends StatefulWidget {
  final Map<String, dynamic>? initialData;
  final Function(Map<String, dynamic>) onSubmit;
  final String submitButtonText;

  const GuitarForm({
    super.key,
    this.initialData,
    required this.onSubmit,
    required this.submitButtonText,
  });

  @override
  State<GuitarForm> createState() => _GuitarFormState();
}

class _GuitarFormState extends State<GuitarForm> {
  final _formKey = GlobalKey<FormState>();
  final _marcaController = TextEditingController();
  final _modeloController = TextEditingController();
  final _precioController = TextEditingController();
  
  String? _selectedMaderaCuerpo;
  String? _selectedMaderaBrazo;
  String? _selectedConfiguracionPastillas;
  String? _selectedTipoPuente;
  String? _imagePath;
  
  @override
  void initState() {
    super.initState();
    if (widget.initialData != null) {
      _marcaController.text = widget.initialData!['marca'] ?? '';
      _modeloController.text = widget.initialData!['modelo'] ?? '';
      _precioController.text = widget.initialData!['precio']?.toString() ?? '';
      _selectedMaderaCuerpo = widget.initialData!['madera_cuerpo'];
      _selectedMaderaBrazo = widget.initialData!['madera_brazo'];
      _selectedConfiguracionPastillas = widget.initialData!['configuracion_pastillas'];
      _selectedTipoPuente = widget.initialData!['tipo_puente'];
      _imagePath = widget.initialData!['imageUrl'];
    }
  // Preseleccionar una configuración por defecto si no hay
  _selectedConfiguracionPastillas ??= 'HH';
  }

  @override
  void dispose() {
    _marcaController.dispose();
    _modeloController.dispose();
    _precioController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 8),
              Text('Imagen seleccionada'),
            ],
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final formData = {
        'marca': _marcaController.text,
        'modelo': _modeloController.text,
        'precio': int.tryParse(_precioController.text) ?? 0,
        'madera_cuerpo': _selectedMaderaCuerpo ?? '',
        'madera_brazo': _selectedMaderaBrazo ?? '',
        'configuracion_pastillas': _selectedConfiguracionPastillas ?? '',
        'tipo_puente': _selectedTipoPuente ?? '',
        'imageUrl': _imagePath ?? '',
      };
      
      if (widget.initialData != null) {
        formData['id'] = widget.initialData!['id'];
      }
      
      widget.onSubmit(formData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.deepPurple.withOpacity(0.05),
            Colors.white,
            Colors.grey.withOpacity(0.05),
          ],
        ),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Card para información básica
              Card(
                elevation: 4,
                margin: EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.info_outline, color: Colors.deepPurple),
                          SizedBox(width: 8),
                          Text(
                            'Información Básica',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _marcaController,
                        decoration: InputDecoration(
                          labelText: 'Marca *',
                          prefixIcon: Icon(Icons.label_outline),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.deepPurple, width: 2),
                          ),
                        ),
                        validator: (value) => value?.isEmpty == true ? 'La marca es requerida' : null,
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _modeloController,
                        decoration: InputDecoration(
                          labelText: 'Modelo *',
                          prefixIcon: Icon(Icons.music_note_outlined),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.deepPurple, width: 2),
                          ),
                        ),
                        validator: (value) => value?.isEmpty == true ? 'El modelo es requerido' : null,
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _precioController,
                        decoration: InputDecoration(
                          labelText: 'Precio',
                          prefixIcon: Icon(Icons.attach_money),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.deepPurple, width: 2),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ],
                  ),
                ),
              ),

              // Card para especificaciones técnicas
              Card(
                elevation: 4,
                margin: EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.build_outlined, color: Colors.deepPurple),
                          SizedBox(width: 8),
                          Text(
                            'Especificaciones Técnicas',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      GuitarDropdownField(
                        label: 'Madera del Cuerpo',
                        selectedValue: _selectedMaderaCuerpo,
                        collectionName: 'catalogos',
                        fieldName: 'madera_cuerpo',
                        onChanged: (value) => setState(() => _selectedMaderaCuerpo = value),
                      ),
                      SizedBox(height: 16),
                      GuitarDropdownField(
                        label: 'Madera del Brazo',
                        selectedValue: _selectedMaderaBrazo,
                        collectionName: 'catalogos',
                        fieldName: 'madera_brazo',
                        onChanged: (value) => setState(() => _selectedMaderaBrazo = value),
                      ),
                      SizedBox(height: 16),
                      GuitarDropdownField(
                        label: 'Configuración de Pastillas',
                        selectedValue: _selectedConfiguracionPastillas,
                        collectionName: 'catalogos', // ignorado por staticItems
                        fieldName: 'configuracion_pastillas',
                        staticItems: const [
                          'HH',
                          'HSS',
                          'SSS',
                          'HSH',
                          'HS',
                          'SS',
                        ],
                        allowCustomEntry: false,
                        onChanged: (value) => setState(() => _selectedConfiguracionPastillas = value),
                      ),
                      if (_selectedConfiguracionPastillas == null || _selectedConfiguracionPastillas!.isEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 6.0),
                          child: Text(
                            'Selecciona una configuración',
                            style: TextStyle(color: Colors.red[600], fontSize: 12),
                          ),
                        ),
                      SizedBox(height: 16),
                      GuitarDropdownField(
                        label: 'Tipo de Puente',
                        selectedValue: _selectedTipoPuente,
                        collectionName: 'catalogos',
                        fieldName: 'tipo_puente',
                        onChanged: (value) => setState(() => _selectedTipoPuente = value),
                      ),
                    ],
                  ),
                ),
              ),

              // Card para imagen
              Card(
                elevation: 4,
                margin: EdgeInsets.only(bottom: 24),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.image_outlined, color: Colors.deepPurple),
                          SizedBox(width: 8),
                          Text(
                            'Imagen',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      if (_imagePath != null) ...[
                        Container(
                          height: 200,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: _imagePath!.startsWith('http')
                                ? Image.network(_imagePath!, fit: BoxFit.cover)
                                : Image.file(File(_imagePath!), fit: BoxFit.cover),
                          ),
                        ),
                        SizedBox(height: 12),
                      ],
                      ElevatedButton.icon(
                        onPressed: _pickImage,
                        icon: Icon(Icons.photo_library),
                        label: Text(_imagePath == null ? 'Seleccionar Imagen' : 'Cambiar Imagen'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Botón de guardar
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  elevation: 4,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.save),
                    SizedBox(width: 8),
                    Text(
                      widget.submitButtonText,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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
}
