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

  // Variable pour stocker l'âge
  int _age = 0;

  @override
  void initState() {
    super.initState();

    // Initialiser les valeurs par défaut
    _birthMonthController.text = '6'; // Juin
    _birthYearController.text = '2001'; // 2001
    _calculateAge(); // Calculer l'âge initial
  }

  // Méthode pour calculer l'âge
  void _calculateAge() {
    final int birthMonth =
        int.tryParse(_birthMonthController.text) ?? DateTime.now().month;
    final int birthYear =
        int.tryParse(_birthYearController.text) ?? DateTime.now().year;

    final DateTime now = DateTime.now();
    int age = now.year - birthYear;
    if (now.month < birthMonth || (now.month == birthMonth && now.day < 1)) {
      age--; // Si l'anniversaire n'est pas encore passé cette année
    }

    setState(() {
      _age = age;
    });

    print('Âge : $_age');
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> steps = [
      _buildStep1(), // Étape 1 : Confirmez votre âge
      _buildStep2(), // Étape 2 : Choix du mode d'utilisation
      _buildStep3(), // Étape 3 : Choisis un nom d'utilisateur
      _buildStep4(), // Étape 4 : Mot de passe
      _buildStep5(), // Étape 5 : Photo de profil
    ];

    return Scaffold(
      appBar: AppBar(title: Text('Inscription')),
      body: Column(
        children: [
          // Affichage des étapes
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: NeverScrollableScrollPhysics(), // Désactive le swipe
              children: steps,
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
                if (_currentPage < steps.length - 1)
                  ElevatedButton(
                    onPressed: _goToNextPage,
                    child: Text('Suivant'),
                  ),
                if (_currentPage == steps.length - 1)
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

  Widget _buildStep1() {
    // Liste des mois
    final List<String> months = [
      'Janvier',
      'Février',
      'Mars',
      'Avril',
      'Mai',
      'Juin',
      'Juillet',
      'Août',
      'Septembre',
      'Octobre',
      'Novembre',
      'Décembre'
    ];

    // Liste des années (de 1950 à 2011)
    final List<int> years =
        List.generate(62, (index) => 1950 + index).reversed.toList();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            'Confirmez votre âge',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          // Afficher l'âge calculé avec un bouton pour le mettre à jour
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Âge : $_age ans',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 10), // Espace entre le texte et le bouton
              IconButton(
                icon: Icon(Icons.refresh), // Icône de rafraîchissement
                onPressed: () {
                  setState(() {
                    _calculateAge(); // Recalculer l'âge
                  });
                },
                tooltip: 'Mettre à jour l\'âge', // Info-bulle
              ),
            ],
          ),
          SizedBox(height: 20),
          // Mois et année côte à côte avec un arrière-plan commun pour l'élément central
          Padding(
            padding: EdgeInsets.only(left: 18, right: 18),
            child: Stack(
              children: [
                // Arrière-plan pour l'élément central
                Positioned(
                  top:
                      75, // Ajustez cette valeur pour aligner avec l'élément central
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 50, // Hauteur de l'élément central
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 204, 204, 204)
                          .withOpacity(0.2), // Couleur de fond
                      borderRadius: BorderRadius.circular(50), // Bord arrondi
                    ),
                  ),
                ),
                // Mois et année côte à côte
                Row(
                  children: [
                    // Mois de naissance
                    Expanded(
                      child: SizedBox(
                        height: 200, // Hauteur fixe pour le ListWheelScrollView
                        child: ListWheelScrollView.useDelegate(
                          itemExtent: 50, // Hauteur de chaque élément
                          diameterRatio:
                              1.5, // Ajuster la courbure du défilement
                          magnification: 1.5, // Zoom sur l'élément au centre
                          useMagnifier: true, // Activer le zoom
                          onSelectedItemChanged: (index) {
                            setState(() {
                              _birthMonthController.text = (index + 1)
                                  .toString(); // Janvier = 1, Décembre = 12
                              _calculateAge(); // Recalculer l'âge
                            });
                          },
                          childDelegate: ListWheelChildBuilderDelegate(
                            builder: (context, index) {
                              final month = months[index];
                              return Center(
                                child: Text(
                                  month,
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: month ==
                                            months[int.tryParse(
                                                    _birthMonthController
                                                        .text)! -
                                                1]
                                        ? Colors.blue
                                        : Colors.black,
                                  ),
                                ),
                              );
                            },
                            childCount: months.length,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16), // Espace entre les deux champs
                    // Année de naissance
                    Expanded(
                      child: SizedBox(
                        height: 200, // Hauteur fixe pour le ListWheelScrollView
                        child: ListWheelScrollView.useDelegate(
                          itemExtent: 50, // Hauteur de chaque élément
                          diameterRatio:
                              1.5, // Ajuster la courbure du défilement
                          magnification: 1.5, // Zoom sur l'élément au centre
                          useMagnifier: true, // Activer le zoom
                          onSelectedItemChanged: (index) {
                            setState(() {
                              _birthYearController.text =
                                  years[index].toString();
                              _calculateAge(); // Recalculer l'âge
                            });
                          },
                          childDelegate: ListWheelChildBuilderDelegate(
                            builder: (context, index) {
                              final year = years[index];
                              return Center(
                                child: Text(
                                  year.toString(),
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: year ==
                                            int.tryParse(
                                                _birthYearController.text)
                                        ? const Color.fromARGB(255, 0, 0, 0)
                                        : Colors.black,
                                  ),
                                ),
                              );
                            },
                            childCount: years.length,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
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
    if (_currentPage < 4) {
      // 4 est le nombre d'étapes - 1
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
