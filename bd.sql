CREATE TABLE users (
    id SERIAL PRIMARY KEY,                   -- Identifiant unique de l'utilisateur
    username VARCHAR(50) UNIQUE NOT NULL,    -- Nom d'utilisateur
    password_hash TEXT NOT NULL,             -- Mot de passe hashé
    link_token TEXT UNIQUE NOT NULL,         -- Token unique pour le lien de réception
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP -- Date de création du compte
);

CREATE TABLE messages (
    id SERIAL PRIMARY KEY,                   -- Identifiant unique du message
    receiver_id INT REFERENCES users(id),    -- ID du destinataire (lié à la table users)
    content TEXT NOT NULL,                   -- Contenu du message
    sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP -- Date d'envoi du message
);