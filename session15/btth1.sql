CREATE DATABASE IF NOT EXISTS mini_social_network;

USE mini_social_network;

CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE posts (
    post_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    content TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id)
        REFERENCES users(user_id)
        ON DELETE CASCADE
);

CREATE TABLE comments (
    comment_id INT AUTO_INCREMENT PRIMARY KEY,
    post_id INT NOT NULL,
    user_id INT NOT NULL,
    content TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (post_id)
        REFERENCES posts(post_id)
        ON DELETE CASCADE,
    FOREIGN KEY (user_id)
        REFERENCES users(user_id)
        ON DELETE CASCADE
);

CREATE TABLE likes (
    user_id INT NOT NULL,
    post_id INT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, post_id),
    FOREIGN KEY (user_id)
        REFERENCES users(user_id)
        ON DELETE CASCADE,
    FOREIGN KEY (post_id)
        REFERENCES posts(post_id)
        ON DELETE CASCADE
);

CREATE TABLE friends (
    user_id INT NOT NULL,
    friend_id INT NOT NULL,
    status VARCHAR(20) DEFAULT 'pending',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, friend_id),
    FOREIGN KEY (user_id)
        REFERENCES users(user_id)
        ON DELETE CASCADE,
    FOREIGN KEY (friend_id)
        REFERENCES users(user_id)
        ON DELETE CASCADE,
    CHECK (status IN ('pending', 'accepted'))
);
