require_relative 'forum'
require_relative 'questions'
require_relative 'users'

class Replies

  attr_accessor :questions_id, :user_id, :parent_id, :parent
  attr_reader :id

  def self.all
    data = ForumDatabase.instance.execute('SELECT * FROM replies')
    data.map {|datum| Replies.new(datum)}
  end

  def self.find_by_id(id)
    replies_db = ForumDatabase.instance.execute(<<-SQL, id)
    SELECT
    *
    FROM
    replies
    WHERE
    id = ?
    SQL

    return nil unless replies_db.length > 0
    Replies.new(replies_db.first)
  end

  def self.find_by_user_id(user_id)
    replies_db = ForumDatabase.instance.execute(<<-SQL, user_id)
    SELECT
    *
    FROM
    replies
    WHERE
    user_id = ?
    SQL

    return nil unless replies_db.length > 0
    Replies.new(replies_db.first)
  end

  def self.find_by_questions_id(questions_id)
    replies_db = ForumDatabase.instance.execute(<<-SQL, questions_id)
    SELECT
    *
    FROM
    replies
    WHERE
    questions_id = ?
    SQL

    return nil unless replies_db.length > 0
    Replies.new(replies_db.first)
  end

  def initialize(options)
    @id = options['id']
    @questions_id = options['questions_id']
    @user_id = options['user_id']
    @parent_id = options['parent_id']
    @parent = options['parent']
  end

  def create
    raise "#{self} is already in database" if @id

    ForumDatabase.instance.execute(<<-SQL, @questions_id, @user_id, @parent_id, @parent)
    INSERT INTO
      replies (questions_id, user_id, parent_id, parent)
    VALUES
      (?, ?, ?, ?)
    SQL
    @id = ForumDatabase.instance.last_insert_row_id
  end

  def update
    raise "#{self} is not in database" unless @id

    ForumDatabase.instance.execute(<<-SQL, @questions_id, @user_id, @parent_id, @parent, @id)
    UPDATE
      replies
    SET
      questions_id = ?, user_id = ?, parent_id = ?, parent = ?
    WHERE
      id = ?
    SQL
  end
end
