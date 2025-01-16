import 'package:flutter/material.dart';
import 'settings_page.dart'; // Assurez-vous d'importer la page des paramètres ici

class FarmerDashboardPage extends StatefulWidget {
  const FarmerDashboardPage({super.key});

  @override
  _FarmerDashboardPageState createState() => _FarmerDashboardPageState();
}

class _FarmerDashboardPageState extends State<FarmerDashboardPage> {
  final List<Map<String, dynamic>> _products = [
    {"name": "Tomates", "price": "200 FCFA/kg", "stock": 100},
    {"name": "Carottes", "price": "150 FCFA/kg", "stock": 80},
  ];
  final List<Map<String, dynamic>> _orders = [
    {"product": "Tomates", "quantity": 5, "price": "1000 FCFA"},
    {"product": "Carottes", "quantity": 3, "price": "450 FCFA"},
  ];

  double _balance = 1450.0;
  String _searchQuery = '';

  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _productPriceController = TextEditingController();

  void _addProduct() {
    if (_productNameController.text.isNotEmpty &&
        _productPriceController.text.isNotEmpty) {
      setState(() {
        _products.add({
          "name": _productNameController.text,
          "price": _productPriceController.text,
          "stock": 50, // Default stock for new product
        });
        _productNameController.clear();
        _productPriceController.clear();
      });
      Navigator.pop(context);
    }
  }

  void _removeProduct(int index) {
    setState(() {
      _products.removeAt(index);
    });
  }

  void _editProduct(int index) {
    _productNameController.text = _products[index]["name"];
    _productPriceController.text = _products[index]["price"];
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Modifier un produit"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _productNameController,
                decoration: const InputDecoration(labelText: "Nom"),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _productPriceController,
                decoration: const InputDecoration(labelText: "Prix"),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Annuler"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _products[index] = {
                    "name": _productNameController.text,
                    "price": _productPriceController.text,
                    "stock": _products[index]["stock"],
                  };
                });
                _productNameController.clear();
                _productPriceController.clear();
                Navigator.pop(context);
              },
              child: const Text("Enregistrer"),
            ),
          ],
        );
      },
    );
  }

  double _calculateTotalOrders() {
    double total = 0;
    for (var order in _orders) {
      total += double.parse(order["price"].replaceAll(" FCFA", ""));
    }
    return total;
  }

  double _calculateTotalSales(String productName) {
    double totalSales = 0;
    for (var order in _orders) {
      if (order["product"] == productName) {
        totalSales += double.parse(order["price"].replaceAll(" FCFA", ""));
      }
    }
    return totalSales;
  }

  @override
  Widget build(BuildContext context) {
    final filteredProducts = _products
        .where((product) =>
            product["name"]
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Tableau de bord - Agriculteur"),
        backgroundColor: Colors.teal,
        actions: [
          // Icône de paramètres
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Naviguer vers la page des paramètres
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Mes Produits",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                hintText: "Rechercher un produit...",
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (query) {
                setState(() {
                  _searchQuery = query;
                });
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: filteredProducts.length,
                itemBuilder: (context, index) {
                  final product = filteredProducts[index];
                  double totalSales = _calculateTotalSales(product["name"]);
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                    child: ListTile(
                      title: Text(
                        product["name"],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        "Prix : ${product["price"]} - Total des ventes : $totalSales FCFA",
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Bouton pour modifier le produit
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _editProduct(index),
                          ),
                          // Bouton pour supprimer le produit
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _removeProduct(index),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("Ajouter un produit"),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            controller: _productNameController,
                            decoration: const InputDecoration(labelText: "Nom"),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _productPriceController,
                            decoration:
                                const InputDecoration(labelText: "Prix"),
                            keyboardType: TextInputType.number,
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Annuler"),
                        ),
                        ElevatedButton(
                          onPressed: _addProduct,
                          child: const Text("Ajouter"),
                        ),
                      ],
                    );
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
              ),
              child: const Text("Ajouter un produit"),
            ),
            const SizedBox(height: 32),
            const Text(
              "Commandes",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _orders.length,
                itemBuilder: (context, index) {
                  final order = _orders[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                    child: ListTile(
                      title: Text(
                        order["product"],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                          "Quantité : ${order["quantity"]}, Prix : ${order["price"]}"),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Solde disponible :",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "$_balance FCFA",
              style: const TextStyle(
                fontSize: 20,
                color: Colors.teal,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Fonction pour récupérer l'argent
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
              ),
              child: const Text("Récupérer l'argent"),
            ),
            const SizedBox(height: 16),
            Text(
              "Total des commandes : ${_calculateTotalOrders()} FCFA",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}