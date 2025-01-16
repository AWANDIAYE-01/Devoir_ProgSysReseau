import 'package:flutter/material.dart';
// Assurez-vous d'importer les pages existantes ici :
import 'page_accueil.dart'; // Chemin vers votre HomePage
import 'agri_accueil.dart'; // Chemin vers votre FarmerDashboardPage

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LOCALMARKET',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.teal),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white,
            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      home: const AuthPage(),
    );
  }
}

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final List<Map<String, String>> _users = [
    {"email": "user@example.com", "password": "user123", "type": "user"},
    {"email": "farmer@example.com", "password": "farmer123", "type": "farmer"},
  ];

  void _login(BuildContext context, String email, String password) {
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez remplir tous les champs")),
      );
      return;
    }

    final user = _users.firstWhere(
      (user) => user["email"] == email && user["password"] == password,
      orElse: () => {},
    );

    if (user.isNotEmpty) {
      if (user["type"] == "user") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Accueil()), // Redirection vers Accueil
        );
      } else if (user["type"] == "farmer") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const FarmerDashboardPage()), // Redirection vers FarmerDashboardPage
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email ou mot de passe incorrect")),
      );
    }
  }

  void _navigateToSignup(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SignupPage(
          onSignup: (newUser) {
            setState(() {
              _users.add(newUser);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Connexion"),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Bienvenue",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Connectez-vous pour continuer.",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 32),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: "Adresse e-mail",
                prefixIcon: Icon(Icons.email, color: Colors.teal),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                labelText: "Mot de passe",
                prefixIcon: Icon(Icons.lock, color: Colors.teal),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _login(context, emailController.text, passwordController.text);
                },
                child: const Text("Se connecter"),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => _navigateToSignup(context),
              child: const Text("Créer un compte"),
            ),
          ],
        ),
      ),
    );
  }
}

class SignupPage extends StatefulWidget {
  final Function(Map<String, String>) onSignup;

  const SignupPage({super.key, required this.onSignup});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String userType = "user";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Créer un compte"),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Créer un compte",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: "Adresse e-mail",
                prefixIcon: Icon(Icons.email, color: Colors.teal),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                labelText: "Mot de passe",
                prefixIcon: Icon(Icons.lock, color: Colors.teal),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: userType,
              items: const [
                DropdownMenuItem(value: "user", child: Text("Utilisateur")),
                DropdownMenuItem(value: "farmer", child: Text("Agriculteur")),
              ],
              onChanged: (value) {
                setState(() {
                  userType = value!;
                });
              },
              decoration: const InputDecoration(
                labelText: "Type de compte",
                prefixIcon: Icon(Icons.person, color: Colors.teal),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  widget.onSignup({
                    "email": emailController.text,
                    "password": passwordController.text,
                    "type": userType,
                  });
                  Navigator.pop(context);
                },
                child: const Text("Créer un compte"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
