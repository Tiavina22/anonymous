import 'package:anonymous/src/screen/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Importez ce package pour SystemUiOverlayStyle
import 'package:shared_preferences/shared_preferences.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Configurez la barre de statut pour qu'elle soit transparente
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // Barre de statut transparente
        statusBarIconBrightness:
            Brightness.light, // Icônes claires (pour un fond sombre)
      ),
    );

    return Scaffold(
      extendBodyBehindAppBar:
          true, // Étend le contenu derrière la barre de statut
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade800, // Couleur de départ
              Colors.blue.shade400, // Couleur de fin
            ],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Text(
                  "Anonymous",
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Pacifico', // Utilisez une police personnalisée
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            // Bouton "Démarrer" et texte de consentement en bas
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity, // Occupe 100% de la largeur
                    child: ElevatedButton(
                      onPressed: () async {
                        // Marquer que l'application a déjà été lancée
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        await prefs.setBool('firstLaunch', false);

                        // Naviguer vers la page de connexion
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white, // Couleur du bouton
                        foregroundColor:
                            Colors.blue.shade800, // Couleur du texte
                        padding:
                            EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        'Démarrer',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(height: 10), // Espacement
                  // Texte de consentement
                  Text(
                    'En continuant, vous acceptez notre Conditions d\'utilisation et vous avez lu et approuvé nos Politique de Confidentialité.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
