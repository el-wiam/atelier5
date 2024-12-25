import 'package:flutter/material.dart';

class AddProduit extends StatelessWidget {
  final Function(String, String, String, double, int) onAdd; // Updated callback

  AddProduit({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    // Controllers for the input fields
    TextEditingController nomController = TextEditingController();
    TextEditingController marqueController = TextEditingController();
    TextEditingController categorieController = TextEditingController();
    TextEditingController prixController = TextEditingController();
    TextEditingController quantiteController = TextEditingController();

    return AlertDialog(
      title: Text('Ajouter un Produit'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nomController,
              decoration: InputDecoration(hintText: 'Nom du produit'),
            ),
            TextField(
              controller: marqueController,
              decoration: InputDecoration(hintText: 'Marque'),
            ),
            TextField(
              controller: categorieController,
              decoration: InputDecoration(hintText: 'Catégorie'),
            ),
            TextField(
              controller: prixController,
              decoration: InputDecoration(hintText: 'Prix'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: quantiteController,
              decoration: InputDecoration(hintText: 'Quantité'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            String nom = nomController.text;
            String marque = marqueController.text;
            String categorie = categorieController.text;
            double? prix = double.tryParse(prixController.text);
            int? quantite = int.tryParse(quantiteController.text);

            if (nom.isNotEmpty &&
                marque.isNotEmpty &&
                categorie.isNotEmpty &&
                prix != null &&
                quantite != null) {
              onAdd(nom, marque, categorie, prix, quantite);
              Navigator.of(context).pop();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Veuillez remplir tous les champs')),
              );
            }
          },
          child: Text('Ajouter'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Annuler'),
        ),
      ],
    );
  }
}
