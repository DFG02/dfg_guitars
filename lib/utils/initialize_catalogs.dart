import 'package:cloud_firestore/cloud_firestore.dart';

// Función para inicializar los catálogos en Firebase
Future<void> initializeCatalogs() async {
  final firestore = FirebaseFirestore.instance;
  
  // Datos de catálogos
  final Map<String, List<String>> catalogos = {
    'madera_cuerpo': [
      'Aliso (Alder)',
      'Fresno (Ash)', 
      'Tilo (Basswood)',
      'Caoba (Mahogany)',
      'Arce (Maple)',
      'Álamo (Poplar)',
      'Agathis',
      'Korina',
      'Sauce (Willow)',
      'Wenge',
      'Bubinga',
      'Zebrano'
    ],
    
    'madera_brazo': [
      'Arce (Maple)',
      'Caoba (Mahogany)', 
      'Roble (Oak)',
      'Wenge',
      'Bubinga',
      'Pau Ferro',
      'Purpleheart',
      'Walnut',
      'Korina',
      'Roasted Maple',
      'Quartersawn Maple'
    ],
    
    'configuracion_pastillas': [
      'SSS (Single-Single-Single)',
      'HSS (Humbucker-Single-Single)', 
      'HSH (Humbucker-Single-Humbucker)',
      'HH (Humbucker-Humbucker)',
      'SS (Single-Single)',
      'H (Humbucker)',
      'HHH (Humbucker-Humbucker-Humbucker)',
      'P90-P90',
      'P90-Humbucker',
      'Activas',
      'Pasivas'
    ],
    
    'tipo_puente': [
      'Tremolo Sincronizado',
      'Floyd Rose',
      'Tune-O-Matic',
      'Wraparound',
      'Hardtail',
      'Bigsby',
      'Kahler',
      'Wilkinson',
      'Hipshot',
      'Gotoh',
      'Schaller',
      'PRS Tremolo'
    ]
  };

  try {
    // Crear/actualizar cada catálogo
    for (var entry in catalogos.entries) {
      await firestore.collection('catalogos').doc(entry.key).set({
        'items': entry.value,
        'updated_at': FieldValue.serverTimestamp(),
      });
  // Catálogo ${entry.key} creado/actualizado (log omitido en producción)
    }
    
  // Todos los catálogos han sido inicializados correctamente
  } catch (e) {
  // Error al inicializar catálogos: $e
  }
}

// Función para verificar que los catálogos existen
Future<void> verifyCatalogs() async {
  final firestore = FirebaseFirestore.instance;
  
  final catalogTypes = ['madera_cuerpo', 'madera_brazo', 'configuracion_pastillas', 'tipo_puente'];
  
  for (var catalogType in catalogTypes) {
    try {
      var doc = await firestore.collection('catalogos').doc(catalogType).get();
      if (doc.exists) {
  // ${catalogType} catálogo verificado
      } else {
        // $catalogType: No existe
      }
    } catch (e) {
      // Error verificando $catalogType: $e
    }
  }
}
