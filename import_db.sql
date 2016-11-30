DROP TABLE if exists users;

CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname TEXT NOT NULL,
  lname TEXT NOT NULL
);

DROP TABLE if exists questions;

CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title TEXT NOT NULL,
  body TEXT NOT NULL,
  author_id INTEGER NOT NULL,

  FOREIGN KEY(author_id) REFERENCES users(id)
);

DROP TABLE if exists question_follows;

CREATE TABLE question_follows (
  user_id INTEGER NOT NULL,
  questions_id INTEGER NOT NULL,

  FOREIGN KEY(user_id) REFERENCES users(id),
  FOREIGN KEY(questions_id) REFERENCES questions(id)
);

DROP TABLE if exists replies;

CREATE TABLE replies (
  id INTEGER PRIMARY KEY,
  questions_id INTEGER NOT NULL,
  user_id INTEGER NOT NULL,
  parent_reply_id INTEGER NOT NULL,
  parent INTEGER NOT NULL,

  FOREIGN KEY(user_id) REFERENCES users(id),
  FOREIGN KEY(questions_id) REFERENCES questions(id)
  FOREIGN KEY(parent_reply_id) REFERENCES replies(id)
);

DROP TABLE if exists question_likes;

CREATE TABLE question_likes (
  question_id INTEGER,
  user_id INTEGER,

  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (user_id) REFERENCES users(id)
);

INSERT INTO
  users (fname, lname)
VALUES
  ('Bronwyn', 'Dunn'),
  ('Victor', 'Guillen');

INSERT INTO
  questions (title, body, author_id)
VALUES
  ('how do i do SQL', 'kjbdfvjbdbvd', 1),
  ('what is happening', 'kqjdbvjebvjbd', 1);

INSERT INTO
  replies (questions_id, user_id, parent_id, parent)
VALUES
  (1, 1, 1, 'Bronwyn');
  -- ((SELECT id FROM replies), "Victor Guillen", "kqjdbvjebvjbd")
