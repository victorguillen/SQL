require 'sqlite3'
require 'singleton'
require_relative 'users'
require_relative 'questions'

class ForumDatabase < SQLite3::Database
  include Singleton


  def initialize
    super('forum.db')
    self.type_translation = true
    self.results_as_hash = true
  end
end

# ("questions_id" => 45, "user_id" => 77, "parent_id" => 123, "parent" => 33)

# require "./forum.rb"
