class KeypassxDatabase

  attr_reader :header
  attr_reader :groups

  def self.open(path)
    self.new(File.read(path))
  end

  def initialize(raw_db)
    @header = Header.new(raw_db[0..124])
    @encrypted_payload = raw_db[124..-1]
  end

  def unlock(master_password)
    @final_key = header.final_key(master_password)
    decrypt_payload
    @groups = Group.extract_from_payload(header, @payload)
    true
  end

  def valid?
    @header.valid?
  end

  def decrypt_payload
    @payload = AESCrypt.decrypt(@encrypted_payload, @final_key, header.encryption_iv, 'AES-256-CBC')
  end
end
