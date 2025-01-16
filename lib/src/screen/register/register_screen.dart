import 'package:anonymous/core/config/config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:anonymous/src/screen/auth/login_screen.dart'; // Importez votre écran de connexion

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _birthMonthController = TextEditingController();
  final TextEditingController _birthYearController = TextEditingController();
  final TextEditingController _profilePictureController =
      TextEditingController();
  String _usageMode = 'instagram';

  // Liste des étapes
  final List<Widget> _steps = [];

  @override
  void initState() {
    super.initState();
    _steps.addAll([
      _buildStep1(), // Étape 1 : Confirmez votre âge
      _buildStep2(), // Étape 2 : Choix du mode d'utilisation
      _buildStep3(), // Étape 3 : Choisis un nom d'utilisateur
      _buildStep4(), // Étape 4 : Mot de passe
      _buildStep5(), // Étape 5 : Photo de profil
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Inscription')),
      body: Column(
        children: [
          // Affichage des étapes
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: NeverScrollableScrollPhysics(), // Désactive le swipe
              children: _steps,
            ),
          ),
          // Boutons de navigation
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_currentPage > 0)
                  ElevatedButton(
                    onPressed: _goToPreviousPage,
                    child: Text('Retour'),
                  ),
                if (_currentPage < _steps.length - 1)
                  ElevatedButton(
                    onPressed: _goToNextPage,
                    child: Text('Suivant'),
                  ),
                if (_currentPage == _steps.length - 1)
                  ElevatedButton(
                    onPressed: _register,
                    child: Text('S\'inscrire'),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Étape 1 : Confirmez votre âge
  Widget _buildStep1() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            'Confirmez votre âge',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          TextField(
            controller: _birthMonthController,
            decoration: InputDecoration(labelText: 'Mois de naissance'),
            keyboardType: TextInputType.number,
          ),
          TextField(
            controller: _birthYearController,
            decoration: InputDecoration(labelText: 'Année de naissance'),
            keyboardType: TextInputType.number,
          ),
        ],
      ),
    );
  }

  // Étape 2 : Choix du mode d'utilisation
  Widget _buildStep2() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            'Où veux-tu utiliser NGL ?',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          DropdownButton<String>(
            value: _usageMode,
            onChanged: (String? newValue) {
              setState(() {
                _usageMode = newValue!;
              });
            },
            items: <String>['instagram', 'facebook']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // Étape 3 : Choisis un nom d'utilisateur
  Widget _buildStep3() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            'Choisis un nom d\'utilisateur',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          TextField(
            controller: _usernameController,
            decoration: InputDecoration(labelText: 'Nom d\'utilisateur'),
          ),
        ],
      ),
    );
  }

  // Étape 4 : Mot de passe
  Widget _buildStep4() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            'Mot de passe',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          TextField(
            controller: _passwordController,
            decoration: InputDecoration(labelText: 'Mot de passe'),
            obscureText: true,
          ),
        ],
      ),
    );
  }

  // Étape 5 : Photo de profil
  Widget _buildStep5() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            'Photo de profil',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          TextField(
            controller: _profilePictureController,
            decoration: InputDecoration(labelText: 'URL de la photo de profil'),
          ),
        ],
      ),
    );
  }

  // Aller à la page précédente
  void _goToPreviousPage() {
    if (_currentPage > 0) {
      setState(() {
        _currentPage--;
      });
      _pageController.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  // Aller à la page suivante
  void _goToNextPage() {
    if (_currentPage < _steps.length - 1) {
      setState(() {
        _currentPage++;
      });
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  // Soumettre le formulaire
  Future<void> _register() async {
    // Vérifier que tous les champs sont remplis
    if (_usernameController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _birthMonthController.text.isEmpty ||
        _birthYearController.text.isEmpty ||
        _profilePictureController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veuillez remplir tous les champs')),
      );
      return;
    }

    // Appeler votre méthode register existante
    await register();
  }

  // Votre méthode register existante
  Future<void> register() async {
    final response = await http.post(
      Uri.parse(Config.apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'username': _usernameController.text,
        'password': _passwordController.text,
        'birthMonth': int.parse(_birthMonthController.text),
        'birthYear': int.parse(_birthYearController.text),
        'usageMode': _usageMode,
        'profilePicture': _profilePictureController.text,
      }),
    );

    if (response.statusCode == 201) {
      // Inscription réussie
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Inscription réussie !')),
      );
      // Rediriger vers l'écran de connexion
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } else {
      // Gérer les erreurs de l'API
      final errorMessage =
          json.decode(response.body)['message'] ?? 'Erreur inconnue';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Erreur lors de l\'inscription : $errorMessage')),
      );
    }
  }
}
