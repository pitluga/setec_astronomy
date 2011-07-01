class KeypassxDatabase
  def self.open(path)
    self.new(File.read(path))
  end

  def initialize(raw_db)
    @header = Header.new(raw_db[0..124])
    @payload = raw_db[124..-1]
  end

  def unlock(master_password)
    final_key = @header.final_key(master_password)
    true
  end

  def valid?
    @header.valid?
  end
end
