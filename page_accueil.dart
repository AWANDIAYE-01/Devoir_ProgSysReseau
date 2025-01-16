// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'settings_page.dart';
void main() {
  runApp(const Accueil());
}

class Accueil extends StatelessWidget {
  const Accueil({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LOCALMARKET',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "LOCALMARKET",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings), // Icône paramètres
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()), // Navigation vers la page des paramètres
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Bienvenue sur LOCALMARKET !",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Text(
              "Trouvez des produits agricoles frais directement auprès des agriculteurs.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MarketPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Voir le marché",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MarketPage extends StatefulWidget {
  const MarketPage({super.key});

  @override
  _MarketPageState createState() => _MarketPageState();
}

class _MarketPageState extends State<MarketPage> {
  final List<Map<String, dynamic>> products = [
    {"name": "Pommes de terre", "price": 500, "category": "Légumes", "details": "Pommes de terre fraîches et de qualité.", 
     "nutrition": "Calories: 77 kcal / 100g, Protéines: 2g, Glucides: 17g, Lipides: 0.1g", 
     "health_benefits": "Riche en potassium, aide à la régulation de la pression artérielle.", 
     "origin": "Cultivées localement", "vitamins": "Vitamine C, B6"},
    {"name": "Carottes", "price": 800, "category": "Légumes", "details": "Carottes croquantes et nourrissantes.",
     "nutrition": "Calories: 41 kcal / 100g, Protéines: 0.9g, Glucides: 10g, Lipides: 0.2g", 
     "health_benefits": "Bonne pour la vision, riche en bêta-carotène et en antioxydants.", 
     "origin": "Cultivées localement", "vitamins": "Vitamine A, C"},
    {"name": "Mangues", "price": 1500, "category": "Fruits", "details": "Mangues juteuses, bien mûres et sucrées.",
     "nutrition": "Calories: 60 kcal / 100g, Protéines: 0.8g, Glucides: 15g, Lipides: 0.4g", 
     "health_benefits": "Riche en antioxydants, améliore la digestion et le système immunitaire.", 
     "origin": "Provenant des tropiques", "vitamins": "Vitamine C, A, B6"},
    {"name": "Poivrons", "price": 1200, "category": "Légumes", "details": "Poivrons frais, colorés et pleins de saveurs.",
     "nutrition": "Calories: 20 kcal / 100g, Protéines: 1g, Glucides: 5g, Lipides: 0.2g", 
     "health_benefits": "Aide à renforcer le système immunitaire, améliore la circulation sanguine.", 
     "origin": "Cultivés localement", "vitamins": "Vitamine C, B6"},
    {"name": "Tomates", "price": 700, "category": "Légumes", "details": "Tomates mûres, idéales pour vos salades et sauces.",
     "nutrition": "Calories: 18 kcal / 100g, Protéines: 0.9g, Glucides: 4g, Lipides: 0.2g", 
     "health_benefits": "Bonne source de lycopène, anti-inflammatoire et antioxydant.", 
     "origin": "Cultivées localement", "vitamins": "Vitamine C, A"},
  ];

  final List<Map<String, dynamic>> cart = [];
  String searchQuery = "";
  String selectedCategory = 'Tous';
  double minPrice = 0;
  double maxPrice = 5000;

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredProducts = products
        .where((product) {
          final isCategoryMatch = selectedCategory == 'Tous' || product["category"] == selectedCategory;
          final isPriceMatch = product["price"] >= minPrice && product["price"] <= maxPrice;
          final isSearchMatch = product["name"].toLowerCase().contains(searchQuery.toLowerCase());
          return isCategoryMatch && isPriceMatch && isSearchMatch;
        })
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Marché LOCALMARKET"),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartPage(cart: cart)),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search bar
            TextField(
              decoration: InputDecoration(
                labelText: "Rechercher un produit",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
            const SizedBox(height: 16),
            // Product Grid
            Expanded(
              child: GridView.builder(
                itemCount: filteredProducts.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.8,
                ),
                itemBuilder: (context, index) {
                  final product = filteredProducts[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetailsPage(
                            product: product,
                            addToCart: (item) {
                              setState(() {
                                cart.add(item);
                              });
                            },
                          ),
                        )
                      );
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                      color: Colors.teal.shade50,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Container(
                              color: Colors.grey.shade200,
                              child: Icon(
                                Icons.shopping_cart_outlined,
                                size: 50,
                                color: Colors.teal.shade700,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Text(
                                  product["name"],
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.teal,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "${product["price"]} FCFA",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.teal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductDetailsPage extends StatelessWidget {
  final Map<String, dynamic> product;
  final Function(Map<String, dynamic>) addToCart;

  const ProductDetailsPage({super.key, required this.product, required this.addToCart});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product["name"]),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: Colors.grey.shade200,
                padding: const EdgeInsets.all(20.0),
                child: Icon(
                  Icons.shopping_cart_outlined,
                  size: 100,
                  color: Colors.teal.shade700,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                product["name"],
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "${product["price"]} FCFA",
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.teal,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "Détails Nutritionnels : ${product["nutrition"]}",
                style: const TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 8),
              Text(
                "Bienfaits pour la santé : ${product["health_benefits"]}",
                style: const TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 8),
              Text(
                "Provenance : ${product["origin"]}",
                style: const TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 8),
              Text(
                "Vitamines : ${product["vitamins"]}",
                style: const TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  addToCart(product);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Ajouter au panier",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// CartPage - Ajout de cette page pour afficher les articles du panier.
class CartPage extends StatelessWidget {
  final List<Map<String, dynamic>> cart;

  const CartPage({super.key, required this.cart});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Panier"),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: cart.isEmpty
            ? const Center(child: Text("Votre panier est vide."))
            : ListView.builder(
                itemCount: cart.length,
                itemBuilder: (context, index) {
                  final item = cart[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(item["name"]),
                      subtitle: Text("${item["price"]} FCFA"),
                      trailing: const Icon(Icons.delete),
                      onTap: () {
                        // Logique pour supprimer un article du panier.
                      },
                    ),
                  );
                },
              ),
      ),
    );
  }
}


class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Paramètres"),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: const [
            ListTile(
              title: Text("Option 1"),
              trailing: Icon(Icons.arrow_forward),
            ),
            ListTile(
              title: Text("Option 2"),
              trailing: Icon(Icons.arrow_forward),
            ),
            // Ajoutez plus d'options si nécessaire.
          ],
        ),
      ),
    );
  }
}