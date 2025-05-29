CREATE TABLE User (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(100) NOT NULL,
    username VARCHAR(50) NOT NULL UNIQUE,
    birth_date DATE,
    gender ENUM ('male', 'female', 'other') NOT NULL,
    country VARCHAR(50),
    postal_code VARCHAR(20)
);

CREATE TABLE Channel (
    channel_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    created_at DATETIME NOT NULL,
    FOREIGN KEY (user_id) REFERENCES User(user_id)
);

CREATE TABLE Video (
    video_id INT AUTO_INCREMENT PRIMARY KEY,
    channel_id INT NOT NULL,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    file_size_mb FLOAT,
    filename VARCHAR(255) NOT NULL,
    duration_seconds INT,
    thumbnail VARCHAR(255),
    visibility ENUM('public', 'hidden','private')DEFAULT 'public',
    views INT DEFAULT 0,
    likes_count INT DEFAULT 0,
    dislikes_count INT DEFAULT 0,
    published_at DATETIME NOT NULL,
    FOREIGN KEY (channel_id) REFERENCES Channel(channel_id)
);

CREATE TABLE Tag (
    tag_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE VideoTag (
    video_id INT,
    tag_id INT,
    PRIMARY KEY (video_id, tag_id),
    FOREIGN KEY (video_id) REFERENCES Video(video_id),
    FOREIGN KEY (tag_id) REFERENCES Tag(tag_id)
);

CREATE TABLE Subscription (
    subscriber_id INT,
    channel_id INT,
    subscribed_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (subscriber_id, channel_id),
    FOREIGN KEY (subscriber_id) REFERENCES User(user_id),
    FOREIGN KEY (channel_id) REFERENCES Channel(channel_id)
);

CREATE TABLE VideoReaction (
    user_id INT,
    video_id INT,
    reaction ENUM ('like','dislike') NOT NULL,
    reacted_at DATETIME NOT NULL,
    PRIMARY KEY (user_id, video_id),
    FOREIGN KEY (user_id) REFERENCES User(user_id),
    FOREIGN KEY (video_id) REFERENCES Video(video_id)
);

CREATE TABLE Playlist (
    playlist_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    created_at DATETIME NOT NULL,
    visibility ENUM ('public','private') DEFAULT PRIVATE,
    FOREIGN KEY (user_id) REFERENCES User(user_id)
);

CREATE TABLE PlaylistVideo (
    playlist_id INT,
    video_id INT,
    position_in_playlist INT,
    PRIMARY KEY (playlist_id, video_id),
    FOREIGN KEY (playlist_id) REFERENCES Playlist(playlist_id),
    FOREIGN KEY (video_id) REFERENCES Video(video_id)
);

CREATE TABLE Comment (
    comment_id INT AUTO_INCREMENT PRIMARY KEY,
    video_id INT NOT NULL,
    user_id INT NOT NULL,
    text TEXT NOT NULL,
    commented_at DATETIME NOT NULL,
    FOREIGN KEY (video_id) REFERENCES Video(video_id),
    FOREIGN KEY (user_id) REFERENCES User(user_id)
);

CREATE TABLE CommentReaction (
    user_id INT,
    comment_id INT,
    reaction ENUM ('like','dislike') NOT NULL,
    reacted_at DATETIME NOT NULL,
    PRIMARY KEY (user_id, comment_id),
    FOREIGN KEY (user_id) REFERENCES User(user_id),
    FOREIGN KEY (comment_id) REFERENCES Comment(comment_id)
);


INSERT INTO User (email, password, username, birth_date, gender, country, postal_code) VALUES
('alice@example.com', 'password123', 'aliceYT', '1990-05-10', 'female', 'USA', '90210'),
('bob@example.com', 'securepass', 'bobTV', '1985-03-20', 'male', 'UK', 'E1 6AN'),
('carol@example.com', '123456', 'carolCreator', '2000-12-01', 'female', 'Canada', 'H2X 1S1');

INSERT INTO Channel (user_id, name, description, created_at) VALUES
(1, 'Alice’s Channel', 'Tech tutorials and reviews', '2024-01-15 10:30:00'),
(2, 'Bob’s Vlog', 'Daily life and adventures', '2023-11-03 16:45:00');

INSERT INTO Video (channel_id, title, description, file_size_mb, filename, duration_seconds, thumbnail, visibility, published_at) VALUES
(1, 'How to Code in SQL', 'Beginner tutorial for SQL', 120.5, 'sql_tutorial.mp4', 600, 'thumb_sql.jpg', 'public', NOW()),
(2, 'My Trip to Japan', 'Travel vlog from Tokyo', 300.2, 'japan_trip.mp4', 1230, 'thumb_japan.jpg', 'public', NOW()),
(1, 'SQL Joins Explained', 'Deep dive into SQL joins with examples', 150.75, 'sql_joins.mp4', 765, 'thumb_joins.jpg', 'public', '2024-02-10 14:00:00'),
(2, 'Morning Routine', 'My quiet morning routine before work', 80.00, 'morning_routine.mp4', 510, 'thumb_morning.jpg', 'private', '2023-12-01 08:15:00');


INSERT INTO Tag (name) VALUES 
('tutorial'),
('sql'),
('travel'),
('vlog'),
('routine'),
('private');

INSERT INTO VideoTag (video_id, tag_id) VALUES
(1, 1), 
(1, 2), 
(2, 3), 
(2, 4), 
(3, 1), 
(3, 2), 
(4, 5), 
(4, 6); 


INSERT INTO Subscription (subscriber_id, channel_id, subscribed_at) VALUES
(3, 1, '2024-03-01 09:00:00'),
(3, 2, '2024-03-02 10:15:00');

INSERT INTO Playlist (user_id, name, created_at, visibility) VALUES
(3, 'Top Picks', '2024-03-05 15:00:00', 'public'),
(1, 'SQL Learning Path', '2024-03-07 10:00:00', 'public'),
(2, 'My Private Collection', '2024-03-07 11:30:00', 'private');

INSERT INTO PlaylistVideo (playlist_id, video_id) VALUES
(1, 1),
(1, 2),
(3, 1),
(3, 3),
(4, 4),
(4, 2);

INSERT INTO VideoReaction (user_id, video_id, reaction, reacted_at) VALUES
(3, 1, 'like', '2024-03-10 10:00:00'),  
(1, 2, 'dislike', '2024-03-10 10:05:00'), 
(2, 3, 'like', '2024-03-10 11:00:00'); 

INSERT INTO Comment (video_id, user_id, text, commented_at) VALUES
(1, 3, 'Great tutorial, very clear!', '2024-03-10 12:00:00'), 
(2, 1, 'Awesome trip, thanks for sharing!', '2024-03-10 12:30:00'), 
(3, 2, 'This helped me understand joins better.', '2024-03-10 13:00:00'); 

INSERT INTO CommentReaction (user_id, comment_id, reaction, reacted_at) VALUES
(1, 1, 'like', '2024-03-10 13:10:00'), 
(2, 2, 'like', '2024-03-10 13:15:00'), 
(3, 3, 'dislike', '2024-03-10 13:20:00'); 















