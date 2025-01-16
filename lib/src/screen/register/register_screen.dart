import 'package:anonymous/core/config/config.dart';
import 'package:anonymous/src/screen/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _birthMonthController = TextEditingController();
  final TextEditingController _birthYearController = TextEditingController();
  final TextEditingController _profilePictureController =
      TextEditingController();
  String _usageMode = 'instagram';

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
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } else {
      print('Erreur lors de l\'inscription');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Inscription')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Nom d\'utilisateur'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Mot de passe'),
              obscureText: true,
            ),
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
            TextField(
              controller: _profilePictureController,
              decoration:
                  InputDecoration(labelText: 'URL de la photo de profil'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: register,
              child: Text('S\'inscrire'),
            ),
          ],
        ),
      ),
    );
  }
}
