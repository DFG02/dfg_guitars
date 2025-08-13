import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GuitarDropdownField extends StatelessWidget {
  final String label;
  final String? selectedValue;
  final String collectionName;
  final String fieldName;
  final ValueChanged<String?> onChanged;
  final bool allowCustomEntry;
  final List<String>? staticItems;

  const GuitarDropdownField({
    super.key,
    required this.label,
    required this.selectedValue,
    required this.collectionName,
    required this.fieldName,
    required this.onChanged,
    this.allowCustomEntry = true,
    this.staticItems,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(10);

    InputDecoration buildDecoration(String hint) => InputDecoration(
          filled: true,
          fillColor: const Color.fromARGB(255, 37, 32, 47),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          hintText: 'Selecciona $hint',
          hintStyle: TextStyle(color: Colors.deepPurple[200], fontSize: 14),
          enabledBorder: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: BorderSide(color: Colors.deepPurple.withOpacity(0.35), width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: const BorderSide(color: Colors.deepPurpleAccent, width: 2),
          ),
        );

    Widget buildLabel() => Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.deepPurple[100],
              fontSize: 14,
              letterSpacing: .3,
            ),
          ),
        );

    // Static list branch
    if (staticItems != null && staticItems!.isNotEmpty) {
      final items = [...staticItems!]..sort();
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildLabel(),
          DropdownButtonFormField<String>(
            value: (selectedValue != null && items.contains(selectedValue)) ? selectedValue : null,
            decoration: buildDecoration(label),
            items: items
                .map((e) => DropdownMenuItem(
                      value: e,
                      child: Text(e, style: const TextStyle(color: Colors.white)),
                    ))
                .toList(),
            onChanged: onChanged,
            icon: Icon(Icons.arrow_drop_down, color: Colors.deepPurple[200]),
            dropdownColor: const Color.fromARGB(255, 37, 32, 47),
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ],
      );
    }

    // Firestore branch
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildLabel(),
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection(collectionName).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SizedBox(
                height: 56,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 37, 32, 47),
                    borderRadius: borderRadius,
                    border: Border.all(color: Colors.deepPurple.withOpacity(0.35), width: 1),
                  ),
                  child: const Center(
                    child: SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                ),
              );
            }

            if (snapshot.hasError) {
              return _buildTextFieldFallback();
            }

            List<String> items = [];
            if (snapshot.hasData) {
              // Preferred structure: doc.id == fieldName with { items: [...] }
              final match = snapshot.data!.docs.where((d) => d.id == fieldName);
              if (match.isNotEmpty) {
                final data = match.first.data() as Map<String, dynamic>;
                final raw = data['items'];
                if (raw is List) {
                  items = raw.map((e) => e.toString()).where((e) => e.isNotEmpty).toList();
                }
              }
              // Fallback legacy structure
              if (items.isEmpty) {
                final collected = <String>{};
                for (final doc in snapshot.data!.docs) {
                  try {
                    final v = doc[fieldName];
                    if (v is String && v.trim().isNotEmpty) collected.add(v.trim());
                  } catch (_) {}
                }
                items = collected.toList();
              }
              items.sort();
            }

            if (items.isEmpty) {
              return _buildTextFieldFallback();
            }

            return DropdownButtonFormField<String>(
              value: (selectedValue != null && items.contains(selectedValue)) ? selectedValue : null,
              decoration: buildDecoration(label),
              items: [
                ...items.map((e) => DropdownMenuItem(
                      value: e,
                      child: Text(e, style: const TextStyle(color: Colors.white)),
                    )),
                if (allowCustomEntry)
                  DropdownMenuItem(
                    value: '__custom__',
                    child: Row(
                      children: [
                        Icon(Icons.add, size: 16, color: Colors.deepPurple[200]),
                        const SizedBox(width: 8),
                        Text('Agregar personalizado...',
                            style: TextStyle(
                              color: Colors.deepPurple[200],
                              fontStyle: FontStyle.italic,
                            )),
                      ],
                    ),
                  ),
              ],
              onChanged: (value) {
                if (value == '__custom__') {
                  _showCustomDialog(context);
                } else {
                  onChanged(value);
                }
              },
              icon: Icon(Icons.arrow_drop_down, color: Colors.deepPurple[200]),
              dropdownColor: const Color.fromARGB(255, 37, 32, 47),
              style: const TextStyle(color: Colors.white, fontSize: 16),
            );
          },
        ),
      ],
    );
  }

  Widget _buildTextFieldFallback() {
    return TextFormField(
      initialValue: selectedValue,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color.fromARGB(255, 37, 32, 47),
        hintText: 'Ingresa $label',
        hintStyle: TextStyle(color: Colors.deepPurple[200]),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.deepPurple.withOpacity(0.35), width: 1),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: Colors.deepPurpleAccent, width: 2),
        ),
      ),
      onChanged: onChanged,
    );
  }

  void _showCustomDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Agregar $label personalizado'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              final text = controller.text.trim();
              if (text.isNotEmpty) {
                try {
                  await FirebaseFirestore.instance.collection(collectionName).add({fieldName: text});
                  onChanged(text);
                } catch (_) {}
                if (context.mounted) Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
            ),
            child: const Text('Agregar'),
          ),
        ],
      ),
    );
  }
}
