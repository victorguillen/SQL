require_relative 'forum'
require_relative 'questions'
require_relative 'replies'

class Users

  attr_accessor :fname, :lname
  attr_reader :id

  def self.all
    data = ForumDatabase.instance.execute('SELECT * FROM users')
    data.map {|datum| Users.new(datum)}
  end

  def self.find_by_id(id)
    user_db = ForumDatabase.instance.execute(<<-SQL, id)
    SELECT
    *
    FROM
    users
    WHERE
    id = ?
    SQL

    return nil unless user_db.length > 0
    Users.new(user_db.first)
  end

  def self.find_by_name(fname, lname)
    user_db = ForumDatabase.instance.execute(<<-SQL, fname, lname)
    SELECT
    *
    FROM
      users
    WHERE
      fname = ?
    AND
      lname = ?
    SQL

    return nil unless user_db.length > 0
    Users.new(user_db.first)
  end

  def authored_q
    Questions.find_by_author(id)
  end

  def initialize(options)
    @id = options['id']
    @fname = options['fname']
    @lname = options['lname']
  end

  def create
    raise "#{self} is already in database" if @id

    ForumDatabase.instance.execute(<<-SQL, @fname, @lname)
    INSERT INTO
      users (fname, lname)
    VALUES
      (?, ?)
    SQL
    @id = ForumDatabase.instance.last_insert_row_id
  end

  def update
    raise "#{self} is not in database" unless @id

    ForumDatabase.instance.execute(<<-SQL, @fname, @lname, @id)
    UPDATE
      users
    SET
      fname = ?, lname = ?
    WHERE
      id = ?
    SQL
  end
end
