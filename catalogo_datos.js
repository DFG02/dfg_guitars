// Script para agregar catálogos de guitarra a Firebase
// Ejecutar este código en la consola de Firebase o crear un script separado

const catalogos = {
  // Maderas de cuerpo
  madera_cuerpo: [
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
  
  // Maderas de brazo/mástil
  madera_brazo: [
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
  
  // Configuraciones de pastillas
  configuracion_pastillas: [
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
  
  // Tipos de puente
  tipo_puente: [
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

/* 
Para agregar estos datos a Firebase, usa este formato en Firestore:

Colección: catalogos
Documentos:
- madera_cuerpo: { items: [array con las maderas de cuerpo] }
- madera_brazo: { items: [array con las maderas de brazo] }
- configuracion_pastillas: { items: [array con las configuraciones] }
- tipo_puente: { items: [array con los tipos de puente] }

O alternativamente, cada item como documento separado:
Colección: catalogos
Sub-colección por tipo, con documentos individuales para cada opción.
*/
