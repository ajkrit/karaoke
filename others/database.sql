-- Create database
create database karaoke;
use karaoke;

-- Create user
CREATE USER 'flutter_user'@'%' IDENTIFIED BY '';

GRANT ALL PRIVILEGES ON karaoke.* TO 'flutter_user'@'%';
FLUSH PRIVILEGES;

-- Create table
CREATE TABLE songs(id INTEGER PRIMARY KEY AUTO_INCREMENT, title TEXT, artist TEXT, lang TEXT, genre TEXT, lyrics TEXT, sound_path TEXT);

-- Insert data
set @lyrics := """
[00:19.11]We're no strangers to love
[00:23.23]You know the rules and so do I
[00:27.54]A full commitment's what I'm thinking of
[00:31.65]You wouldn't get this from any other guy

[00:35.67]I just wanna tell you how I'm feeling
[00:40.88]Gotta make you understand

[00:43.67]Never gonna give you up
[00:45.67]Never gonna let you down
[00:47.92]Never gonna run around and desert you
[00:52.17]Never gonna make you cry
[00:54.17]Never gonna say goodbye
[00:56.42]Never gonna tell a lie and hurt you
""";

INSERT INTO songs (id, title, artist, lang, genre, lyrics, sound_path) VALUES
(1, 'Never Gonna Give You Up', 'Rick Astley', 'English', 'Pop', @lyrics, '1ThzkS6aw06mqitms0PSVP4DROK3iR8TD');
INSERT INTO songs (id, title, artist, lang, genre, lyrics, sound_path) VALUES (2, 'We Will Rock You', 'Queen', 'English', 'Rock', '', '');
INSERT INTO songs (id, title, artist, lang, genre, lyrics, sound_path) VALUES (2, 'We Will Rock You', 'Queen', 'English', 'Rock', '', '');
INSERT INTO songs (id, title, artist, lang, genre, lyrics, sound_path) VALUES (3, 'Gimme! Gimme! Gimme!', 'ABBA', 'English', 'Party', '', '');
INSERT INTO songs (id, title, artist, lang, genre, lyrics, sound_path) VALUES (4, 'You\'ve got a friend in me', 'Randy Newman', 'English', 'Disney', '', '');
INSERT INTO songs (id, title, artist, lang, genre, lyrics, sound_path) VALUES (5, 'Πούλα με', 'Πυξ Λαξ', 'Greek', 'Rock', '', '');
INSERT INTO songs (id, title, artist, lang, genre, lyrics, sound_path) VALUES (6, 'Ζωή Κλεμμένη', 'Ελευθερία Αρβανιτάκη', 'Greek', 'Entechno', '', '');
INSERT INTO songs (id, title, artist, lang, genre, lyrics, sound_path) VALUES (7, 'Με το βοριά', 'Στέλιος Καζαντζίδης', 'Greek', 'Laiko', '', '');
INSERT INTO songs (id, title, artist, lang, genre, lyrics, sound_path) VALUES (8, 'Τα ματόκλαδά σου λάμπουν', 'Γρηγόρης Μπιθικώτσης', 'Greek', 'Rembetiko', '', '');
INSERT INTO songs (id, title, artist, lang, genre, lyrics, sound_path) VALUES (9, 'Woman Like Me ft. Nicki Minaj', 'Little Mix', 'English', 'Pop', '', '');