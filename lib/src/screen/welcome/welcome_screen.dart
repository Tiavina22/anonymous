import 'package:anonymous/src/screen/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo texte "NGL" avec une police jolie
              Text(
                "NGL",
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Pacifico', // Utilisez une police personnalisée
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 20), // Espacement
              // Bouton "Démarrer" en bas
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        // Marquer que l'application a déjà été lancée
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        await prefs.setBool('firstLaunch', false);

                        // Naviguer vers la page de connexion
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => LoginScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white, // Couleur du bouton
                        foregroundColor: Colors.blue.shade800, // Couleur du texte
                        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        'Démarrer',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    SizedBox(height: 10), // Espacement
                    // Texte de consentement
                    Text(
                      'En continuant, vous acceptez nos conditions d\'utilisation.',
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
      ),
    );
  }
}