const express = require('express');
const http = require('http');
const WebSocket = require('ws');
const cors = require('cors');
const bodyParser = require('body-parser');
const { Pool } = require('pg');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const { v4: uuidv4 } = require('uuid');

const app = express();
const server = http.createServer(app);
const wss = new WebSocket.Server({ server });

// Middleware
app.use(cors());
app.use(bodyParser.json());

// Connexion à PostgreSQL
const pool = new Pool({
  user: 'postgres',
  host: '192.168.1.5',
  database: 'testtt',
  password: '4dmin',
  port: 5432,
});

// Clé secrète pour JWT
const SECRET_KEY = 'ejejhfejhfehjef';

// Inscription
app.post('/register', async (req, res) => {
  const { username, password } = req.body;
  const passwordHash = await bcrypt.hash(password, 10);
  const linkToken = uuidv4(); // Génère un token unique
  try {
    const result = await pool.query(
      'INSERT INTO users (username, password_hash, link_token) VALUES ($1, $2, $3) RETURNING *',
      [username, passwordHash, linkToken]
    );
    res.status(201).json(result.rows[0]);
  } catch (err) {
    console.error(err);
    res.status(500).send('Erreur serveur');
  }
});

// Connexion
app.post('/login', async (req, res) => {
  const { username, password } = req.body;
  try {
    const result = await pool.query('SELECT * FROM users WHERE username = $1', [username]);
    if (result.rows.length === 0) {
      return res.status(401).send('Utilisateur non trouvé');
    }
    const user = result.rows[0];
    const validPassword = await bcrypt.compare(password, user.password_hash);
    if (!validPassword) {
      return res.status(401).send('Mot de passe incorrect');
    }
    const token = jwt.sign({ userId: user.id }, SECRET_KEY, { expiresIn: '1h' });
    res.status(200).json({ token, userId: user.id });
  } catch (err) {
    console.error(err);
    res.status(500).send('Erreur serveur');
  }
});

// Récupérer le lien unique d'un utilisateur
app.get('/user-link/:userId', async (req, res) => {
  const { userId } = req.params;
  try {
    const result = await pool.query('SELECT link_token FROM users WHERE id = $1', [userId]);
    if (result.rows.length === 0) {
      return res.status(404).send('Utilisateur non trouvé');
    }
    const link = `http://192.168.1.65:5000/send-message/${result.rows[0].link_token}`;
    res.status(200).json({ link });
  } catch (err) {
    console.error(err);
    res.status(500).send('Erreur serveur');
  }
});

// Envoyer un message via le lien unique
app.post('/send-message/:linkToken', async (req, res) => {
  const { linkToken } = req.params;
  const { content } = req.body;
  try {
    const userResult = await pool.query('SELECT id FROM users WHERE link_token = $1', [linkToken]);
    if (userResult.rows.length === 0) {
      return res.status(404).send('Lien invalide');
    }
    const receiverId = userResult.rows[0].id;
    const result = await pool.query(
      'INSERT INTO messages (receiver_id, content) VALUES ($1, $2) RETURNING *',
      [receiverId, content]
    );

    // Diffuser le nouveau message à tous les clients connectés
    broadcastNewMessage(result.rows[0]);

    res.status(201).json(result.rows[0]);
  } catch (err) {
    console.error(err);
    res.status(500).send('Erreur serveur');
  }
});

// Récupérer les messages d'un utilisateur
app.get('/messages/:userId', async (req, res) => {
  const { userId } = req.params;
  try {
    const result = await pool.query('SELECT * FROM messages WHERE receiver_id = $1', [userId]);
    res.status(200).json(result.rows);
  } catch (err) {
    console.error(err);
    res.status(500).send('Erreur serveur');
  }
});

// WebSocket pour les messages en temps réel
wss.on('connection', (ws) => {
  console.log('Nouvelle connexion WebSocket');

  ws.on('message', (message) => {
    console.log(`Message reçu: ${message}`);
  });

  ws.on('close', () => {
    console.log('Connexion WebSocket fermée');
  });
});

// Fonction pour diffuser un nouveau message à tous les clients connectés
function broadcastNewMessage(message) {
  wss.clients.forEach((client) => {
    if (client.readyState === WebSocket.OPEN) {
      client.send(JSON.stringify(message));
    }
  });
}

// Démarrer le serveur
server.listen(5000, () => {
  console.log('Serveur en écoute sur http://localhost:5000');
});