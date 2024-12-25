import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ProduitBox extends StatefulWidget {
  final String nomProduit;
  final Function(String) onDelete;
  final bool isSelected;
  final Function(bool) onSelected;

  ProduitBox({
    required this.nomProduit,
    required this.onDelete,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  _ProduitBoxState createState() => _ProduitBoxState();
}

class _ProduitBoxState extends State<ProduitBox> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Slidable(
        key: ValueKey(widget.nomProduit),
        endActionPane: ActionPane(
          motion: ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => widget.onDelete(widget.nomProduit),
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Supprimer',
            ),
          ],
        ),
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Checkbox(
                value: widget.isSelected,
                onChanged: (bool? value) {
                  widget.onSelected(value ?? false);
                },
              ),
              Expanded(
                child: Text(widget.nomProduit),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
