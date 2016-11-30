require_relative 'forum'
require_relative 'users'
require_relative 'replies'

class Questions

  attr_accessor :title, :body, :author_id
  attr_reader :id

  def self.all
    data = ForumDatabase.instance.execute('SELECT * FROM questions')
    data.map {|datum| Questions.new(datum)}
  end

  def self.find_by_id(id)
    question_db = ForumDatabase.instance.execute(<<-SQL, id)
    SELECT
    *
    FROM
    questions
    WHERE
    id = ?
    SQL

    return nil unless question_db.length > 0
    Questions.new(question_db.first)
  end

  def self.find_by_author(author_id)
    questions_db = ForumDatabase.instance.execute(<<-SQL, author_id)
    SELECT
      *
    FROM
    questions
    WHERE
    author_id = ?
    SQL

    questions_db.map { |question_data| Questions.new(question_data) }
  end

  def initialize(options)
    @id = options['id']
    @title = options['title']
    @body = options['body']
    @author_id = options['author_id']
  end

  def create
    raise "#{self} is already in database" if @id

    ForumDatabase.instance.execute(<<-SQL, @title, @body, @author_id)
    INSERT INTO
      questions (title, body, author_id)
    VALUES
      (?, ?, ?)
    SQL
    @id = ForumDatabase.instance.last_insert_row_id
  end

  def update
    raise "#{self} is not in database" unless @id

    ForumDatabase.instance.execute(<<-SQL, @title, @body, @author_id, @id)
    UPDATE
      questions
    SET
      title = ?, body = ?, author_id = ?
    WHERE
      id = ?
    SQL
  end
end
