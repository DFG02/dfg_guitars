import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class FirebaseDiagnostics {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  /// Verifica la conexión a Firebase y la configuración de Firestore
  static Future<Map<String, dynamic>> checkFirebaseConnection() async {
    final result = <String, dynamic>{
      'firebase_initialized': false,
      'firestore_connected': false,
      'catalogs_exist': false,
      'can_write': false,
      'errors': <String>[],
    };
    
    try {
      // Verificar inicialización de Firebase
      if (Firebase.apps.isNotEmpty) {
        result['firebase_initialized'] = true;
        if (kDebugMode) print('✅ Firebase está inicializado');
      } else {
        result['errors'].add('Firebase no está inicializado');
        return result;
      }
      
      // Verificar conexión a Firestore
      try {
        await _firestore.disableNetwork();
        await _firestore.enableNetwork();
        result['firestore_connected'] = true;
        if (kDebugMode) print('✅ Firestore está conectado');
      } catch (e) {
        result['errors'].add('Error de conexión a Firestore: $e');
      }
      
      // Verificar si los catálogos existen
      try {
        final catalogTypes = ['madera_cuerpo', 'madera_brazo', 'configuracion_pastillas', 'tipo_puente'];
        int existingCatalogs = 0;
        
        for (var catalogType in catalogTypes) {
          final doc = await _firestore.collection('catalogos').doc(catalogType).get();
          if (doc.exists) {
            existingCatalogs++;
          }
        }
        
        result['catalogs_exist'] = existingCatalogs == catalogTypes.length;
        result['existing_catalogs_count'] = existingCatalogs;
        result['total_catalogs_needed'] = catalogTypes.length;
        
        if (kDebugMode) {
          print('📋 Catálogos existentes: $existingCatalogs/${catalogTypes.length}');
        }
      } catch (e) {
        result['errors'].add('Error verificando catálogos: $e');
      }
      
      // Verificar permisos de escritura
      try {
        final testDoc = _firestore.collection('_test').doc('connection_test');
        await testDoc.set({
          'timestamp': FieldValue.serverTimestamp(),
          'test': 'connection_check'
        });
        await testDoc.delete();
        result['can_write'] = true;
        if (kDebugMode) print('✅ Permisos de escritura funcionan');
      } catch (e) {
        result['errors'].add('Error de permisos de escritura: $e');
      }
      
    } catch (e) {
      result['errors'].add('Error general en diagnóstico: $e');
    }
    
    return result;
  }
  
  /// Inicializa los catálogos solo si no existen
  static Future<bool> initializeCatalogsIfNeeded() async {
    try {
      final diagnostics = await checkFirebaseConnection();
      
      if (diagnostics['errors'].isNotEmpty) {
        if (kDebugMode) {
          print('❌ Errores en diagnóstico: ${diagnostics['errors']}');
        }
        return false;
      }
      
      if (!diagnostics['catalogs_exist']) {
        if (kDebugMode) {
          print('📋 Inicializando catálogos faltantes...');
        }
        await _createCatalogs();
        return true;
      } else {
        if (kDebugMode) {
          print('✅ Catálogos ya existen, no es necesario inicializar');
        }
        return true;
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error en initializeCatalogsIfNeeded: $e');
      }
      return false;
    }
  }
  
  /// Crea los catálogos en Firebase
  static Future<void> _createCatalogs() async {
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

    final batch = _firestore.batch();
    
    for (var entry in catalogos.entries) {
      final docRef = _firestore.collection('catalogos').doc(entry.key);
      batch.set(docRef, {
        'items': entry.value,
        'updated_at': FieldValue.serverTimestamp(),
        'created_at': FieldValue.serverTimestamp(),
      });
    }
    
    await batch.commit();
    if (kDebugMode) print('✅ Todos los catálogos creados exitosamente');
  }
}
