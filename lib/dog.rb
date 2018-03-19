class Dog
  attr_accessor :name, :breed
  attr_reader :id
  
  def initialize(id: nil, name:, breed:)
    @id = id
    @name = name
    @breed = breed
  end
  
  def self.create_table
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS dogs (
      id INTEGER PRIMARY KEY,
      name TEXT,
      breed TEXT
      )
    SQL
    
    DB[:conn].execute(sql)
  end
  
  def self.drop_table
    sql = "DROP TABLE IF EXISTS dogs"
    
    DB[:conn].execute(sql)
  end
  
  def self.new_from_db(record)
    self.new(id: record[0], name: record[1], breed: record[2])
  end
  
  def self.find_by_name(name)
    sql = "SELECT * FROM dogs WHERE name = ?"
    
    record = DB[:conn].execute(sql, name)[0]
    self.new_from_db(record)
  end
  
  def update
    sql = "UPDATE dogs SET name = ?, breed = ? WHERE id = ?"
    
    DB[:conn].execute(sql, self.name, self.breed, self.id)
  end
  
  def save
    if self.id
      self.update
    else
      sql = <<-SQL
        INSERT INTO dogs
        VALUES (?, ?, ?)
      SQL
      
      DB[:conn].execute(sql, self.id, self.name, self.breed)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][0]
      self
    end
  end
  
  def self.create(name: name, breed: breed)
    self.new(name: name, breed: breed).save
  end
  
  def self.find_by_id(id)
    sql = "SELECT * FROM dogs WHERE id = ?"
    
    record = DB[:conn].execute(sql, id)[0]
    self.new_from_db(record)
  end
  
  def self.find_or_create_by_name(name)
    dog = DB[:conn].execute("SELECT * FROM dogs WHERE name = ?", name)
    if !dog.empty?
      song_data = song[0]
      song = Song.new(song_data[0], song_data[1], song_data[2])
    else
      song = self.create(name: name, album: album)
    end
    song
  end 
end