# The keepass file header.
# 
# From the KeePass doc:
# 
# Database header: [DBHDR]
# 
# [ 4 bytes] DWORD    dwSignature1  = 0x9AA2D903
# [ 4 bytes] DWORD    dwSignature2  = 0xB54BFB65
# [ 4 bytes] DWORD    dwFlags
# [ 4 bytes] DWORD    dwVersion       { Ve.Ve.Mj.Mj:Mn.Mn.Bl.Bl }
# [16 bytes] BYTE{16} aMasterSeed
# [16 bytes] BYTE{16} aEncryptionIV
# [ 4 bytes] DWORD    dwGroups        Number of groups in database
# [ 4 bytes] DWORD    dwEntries       Number of entries in database
# [32 bytes] BYTE{32} aContentsHash   SHA-256 hash value of the plain contents
# [32 bytes] BYTE{32} aMasterSeed2    Used for the dwKeyEncRounds AES
#                                     master key transformations
# [ 4 bytes] DWORD    dwKeyEncRounds  See above; number of transformations
# 
# Notes:
# 
# - dwFlags is a bitmap, which can include:
#   * PWM_FLAG_SHA2     (1) for SHA-2.
#   * PWM_FLAG_RIJNDAEL (2) for AES (Rijndael).
#   * PWM_FLAG_ARCFOUR  (4) for ARC4.
#   * PWM_FLAG_TWOFISH  (8) for Twofish.
# - aMasterSeed is a salt that gets hashed with the transformed user master key
#   to form the final database data encryption/decryption key.
#   * FinalKey = SHA-256(aMasterSeed, TransformedUserMasterKey)
# - aEncryptionIV is the initialization vector used by AES/Twofish for
#   encrypting/decrypting the database data.
# - aContentsHash: "plain contents" refers to the database file, minus the
#   database header, decrypted by FinalKey.
#   * PlainContents = Decrypt_with_FinalKey(DatabaseFile - DatabaseHeader)
class Header

  def initialize(header_bytes)
    @signature1 = header_bytes[0..4].unpack('L*').first
    @signature2 = header_bytes[4..8].unpack('L*').first
    @flags   = header_bytes[8..12].unpack('L*').first
    @version = header_bytes[12..16].unpack('L*').first
    @master_seed = header_bytes[16..32]
    @encryption_iv = header_bytes[32..48]
    @groups = header_bytes[48..52].unpack('L*').first
    @entries = header_bytes[52..56].unpack('L*').first
    @contents_hash = header_bytes[56..88]
    @master_seed2 = header_bytes[88..120]
    @rounds = header_bytes[120..-1].unpack('L*').first
  end

  def valid?
    @signature1 == 0x9AA2D903 && @signature2 == 0xB54BFB65
  end

  def final_key(master_key)
    key = Digest::SHA2.new.update(master_key)
    p key
    cipher = OpenSSL::Cipher::Cipher.new("aes-256-ecb")
    cipher.encrypt
    cipher.key = @master_seed2
    p @flags

    @rounds.times do |i|
      puts i if i % 1000 == 0
      cipher = OpenSSL::Cipher::Cipher.new("aes-256-ecb")
      cipher.encrypt
      cipher.key = @master_seed2
      cipher.iv = @encryption_iv
      key = cipher.update(key.to_s) << cipher.final
    end

    p "after #{@rounds} rounds"
    p key
    # cipher = AES.new(masterseed2,  AES.MODE_ECB)
    
    #rounds times
    #key = cipher.encrypt(key) 
    # key = hashlib.sha256(key).digest()

    # hashlib.sha256(masterseed + key).digest()
  end

end
