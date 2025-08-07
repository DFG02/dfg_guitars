import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
                child: ListTile(
                  leading: imageUrl.isNotEmpty
                      ? Image.network(imageUrl, width: 50, height: 50, fit: BoxFit.cover)
                      : Icon(Icons.image, size: 50, color: Colors.grey),
                  title: Text(guitar['marca'] ?? 'Sin marca'),
                  subtitle: Text(guitar['modelo'] ?? 'Sin modelo'),
                  trailing: Row(
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
                  onTap: () {
                    Navigator.pushNamed(context, '/details', arguments: {
                      'id': guitars[index].id,
                      ...guitar,
                    });
                  },
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
