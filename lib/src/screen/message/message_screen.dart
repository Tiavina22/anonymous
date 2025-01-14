import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';

class MessageScreen extends StatefulWidget {
  final String userId;

  MessageScreen({required this.userId});

  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  List<dynamic> messages = [];
  String? userLink;
  bool isLoading = true;
  late WebSocketChannel _channel;

  @override
  void initState() {
    super.initState();
    fetchMessages();
    fetchUserLink();
    _connectToWebSocket();
  }

  // Connexion au WebSocket
  void _connectToWebSocket() {
    _channel = IOWebSocketChannel.connect('ws://192.168.1.61:5000');

    _channel.stream.listen((message) {
      final newMessage = json.decode(message);
      setState(() {
        messages.add(newMessage);
      });
    }, onError: (error) {
      print("Erreur WebSocket: $error");
    });
  }

  // Récupérer les messages
  Future<void> fetchMessages() async {
    try {
      final response = await http
          .get(Uri.parse('http://192.168.1.61:5000/messages/${widget.userId}'));

      if (response.statusCode == 200) {
        setState(() {
          messages = json.decode(response.body);
          isLoading = false;
        });
      } else {
        print("Erreur HTTP: ${response.statusCode}");
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print("Erreur: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  // Récupérer le lien unique
  Future<void> fetchUserLink() async {
    final response = await http
        .get(Uri.parse('http://192.168.1.61:5000/user-link/${widget.userId}'));
    if (response.statusCode == 200) {
      final link = json.decode(response.body)['link'];
      setState(() {
        userLink = link;
      });
      print('Lien unique: $link');
    }
  }

  // Copier le lien
  Future<void> _copyLink() async {
    if (userLink != null) {
      await Clipboard.setData(ClipboardData(text: userLink!));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lien copié dans le presse-papier!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Aucun lien disponible à copier.')),
      );
    }
  }

  // Partager le lien
  Future<void> _shareLink() async {
    if (userLink != null) {
      await Share.share(
        'Découvrez ce lien: $userLink',
        subject: 'Partager sur la story',
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Aucun lien disponible à partager.')),
      );
    }
  }

  @override
  void dispose() {
    _channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Messages')),
      body: Column(
        children: [
          if (userLink != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Votre lien unique:'),
                  SizedBox(height: 8),
                  Text(userLink ?? 'Lien non disponible',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ElevatedButton(
                          onPressed: _copyLink, child: Text('Copier le lien')),
                      SizedBox(width: 10),
                      ElevatedButton(
                          onPressed: _shareLink,
                          child: Text('Partager dans Story')),
                    ],
                  ),
                ],
              ),
            ),
          if (isLoading) Center(child: CircularProgressIndicator()),
          if (!isLoading)
            Expanded(
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(messages[index]['content']),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
