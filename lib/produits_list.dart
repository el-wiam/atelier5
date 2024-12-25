import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'add_produit.dart';
import 'product.dart';

class ProduitsList extends StatefulWidget {
  @override
  _ProduitsListState createState() => _ProduitsListState();
}

class _ProduitsListState extends State<ProduitsList> {
  FirebaseFirestore db = FirebaseFirestore.instance;

  // Function to delete a product
  void deleteProduit(String produitId) {
    db.collection('produits').doc(produitId).delete().catchError((e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Échec de la suppression du produit : $e'),
        backgroundColor: Colors.red,
      ));
    });
  }

  // Function to modify a product
  void modifyProduit(String produitId) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Modifier le produit avec ID : $produitId'),
    ));
  }

  // Function to add a product
  void addProduit(String nom, String marque, String categorie, double prix, int quantite) {
    db.collection('produits').add({
      'designation': nom,
      'marque': marque,
      'categorie': categorie,
      'prix': prix,
      'quantite': quantite,
      'photoUrl': '',
    }).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Produit ajouté avec succès')),
      );
    }).catchError((e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Échec de l\'ajout du produit : $e'),
        backgroundColor: Colors.red,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des Produits'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AddProduit(
                  onAdd: addProduit,
                ),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: db.collection('produits').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Une erreur est survenue'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          List<Produit> produits = snapshot.data!.docs.map((doc) {
            return Produit.fromFirestore(doc);
          }).toList();

          return ListView.builder(
            itemCount: produits.length,
            itemBuilder: (context, index) => ProduitItem(
              produit: produits[index],
              onDelete: () => deleteProduit(produits[index].id),
              onModify: () => modifyProduit(produits[index].id),
            ),
          );
        },
      ),
    );
  }
}

class ProduitItem extends StatelessWidget {
  final Produit produit;
  final VoidCallback onDelete;
  final VoidCallback onModify;

  ProduitItem({required this.produit, required this.onDelete, required this.onModify});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      color: Colors.blue[50],
      child: ListTile(
        contentPadding: const EdgeInsets.all(16.0),
        title: Text(
          produit.designation,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('${produit.marque} • ${produit.categorie}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('${produit.prix} €'),
            IconButton(
              icon: Icon(Icons.edit, color: Colors.orange),
              onPressed: onModify,
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
