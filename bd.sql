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


CREATE TABLE users (
    id SERIAL PRIMARY KEY,                   -- Identifiant unique de l'utilisateur
    username VARCHAR(50) UNIQUE NOT NULL,    -- Nom d'utilisateur
    password_hash TEXT NOT NULL,             -- Mot de passe hashé
    link_token TEXT UNIQUE NOT NULL,         -- Token unique pour le lien de réception
    birth_month INT,                         -- Mois de naissance
    birth_year INT,                          -- Année de naissance
    usage_mode VARCHAR(50) NOT NULL,         -- Mode d'utilisation (instagram ou facebook)
    profile_picture TEXT,                    -- URL ou chemin de la photo de profil
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP -- Date de création du compte
);
