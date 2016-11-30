class Model

  attr_accessor :db
  attr_reader :id

  def self.all
    data = ForumDatabase.instance.execute('SELECT * FROM #{@db}')
    data.map {|datum| self.new(datum)}
  end

  def self.find(findby)
    @findby = findby
  end

  def self.find_by(@findby)
    model_db = ForumDatabase.instance.execute(<<-SQL, find_by)
    SELECT
    *
    FROM
    #{@db}
    WHERE
    find_by = ?
    SQL

    return nil unless model_db.length > 0
    self.new(user_db.first)
  end

  # def initialize(options)
  #
  # end

  def create
    raise "#{self} is already in database" if @id

    ForumDatabase.instance.execute(<<-SQL, *arg)
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
