require 'mysql2'
 
class Dog
  attr_accessor :id, :name, :color

  @@db = Mysql2::Client.new(:host => "127.0.0.1", :username => "root", :database => "dogs")

  def self.db
    @@db
  end

  def db
    @@db
  end

  def initialize(name, color)
    @name = name
    @color = color
    save!
  end

  def self.find(id)
    result = db.query("SELECT * FROM dog WHERE id = '10'")
    matches(result)
    new_from_hash(matches(result).first)
  end

  def new_from_hash(hash)
    Dog.new(hash["name"], hash["color"])
  end

  def self.find_by_att(attribute, value)
    result = db.query("SELECT * FROM dog WHERE #{attribute} = '#{value}'")
    matches(result)
    new_from_hash(matches(result).first)
  end

  def matches(result)
    array = []
    result.each {|row| row << array} unless result.nil?
    array
  end

  def insert
    db.query("INSERT INTO dog (name, color) VALUES ('#{name}', '#{color}')")
    mark_saved
  end

  def update
    db.query("UPDATE dog SET name = '#{name}', color = '#{color}' WHERE id = #{id}")
  end

  def delete
    db.query("DELETE FROM dog WHERE id = #{id}")
  end

  def self.new_from_db(id)
    result = db.query("SELECT * FROM dog WHERE id = #{id}").first
    new_from_hash(result).tap {|dog| dog.id = result["id"]}
  end

  def saved?
    id.nil? ? false : true
  end

  def unsaved?
    id.nil? ? true : false
  end

  def save!
    unsaved? ? insert : update
  end

  def mark_saved
    self.id = db.last_id if db.last_id > 0
  end
end



 
  # color, name, id
  # db
  # find_by_att
  # find
  # insert
  # update
  # delete/destroy
 
  # refactorings?
  # new_from_db?
  # saved?
  # save! (a smart method that knows the right thing to do)
  # unsaved?
  # mark_saved!
  # ==
  # inspect
  # reload
  # attributes