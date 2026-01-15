USE social_network;


ALTER TABLE posts
ADD COLUMN likes_count INT DEFAULT 0;



CREATE TABLE likes (
    like_id INT PRIMARY KEY AUTO_INCREMENT,
    post_id INT NOT NULL,
    user_id INT NOT NULL,
    FOREIGN KEY (post_id) REFERENCES posts(post_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    UNIQUE KEY unique_like (post_id, user_id)
);



SELECT * FROM users;
SELECT * FROM posts;


START TRANSACTION;

INSERT INTO likes (post_id, user_id)
VALUES (1, 1);

UPDATE posts
SET likes_count = likes_count + 1
WHERE post_id = 1;

COMMIT;



SELECT * FROM posts;
SELECT * FROM likes;



START TRANSACTION;

INSERT INTO likes (post_id, user_id)
VALUES (1, 1);

UPDATE posts
SET likes_count = likes_count + 1
WHERE post_id = 1;

ROLLBACK;

SELECT * FROM posts;
SELECT * FROM likes;
