require 'stringio'

# One entry: [FIELDTYPE(FT)][FIELDSIZE(FS)][FIELDDATA(FD)]
#            [FT+FS+(FD)][FT+FS+(FD)][FT+FS+(FD)][FT+FS+(FD)][FT+FS+(FD)]...

# [ 2 bytes] FIELDTYPE
# [ 4 bytes] FIELDSIZE, size of FIELDDATA in bytes
# [ n bytes] FIELDDATA, n = FIELDSIZE

# Notes:
# - Strings are stored in UTF-8 encoded form and are null-terminated.
# - FIELDTYPE can be one of the following identifiers:
#   * 0000: Invalid or comment block, block is ignored
#   * 0001: UUID, uniquely identifying an entry, FIELDSIZE must be 16
#   * 0002: Group ID, identifying the group of the entry, FIELDSIZE = 4
#           It can be any 32-bit value except 0 and 0xFFFFFFFF
#   * 0003: Image ID, identifying the image/icon of the entry, FIELDSIZE = 4
#   * 0004: Title of the entry, FIELDDATA is an UTF-8 encoded string
#   * 0005: URL string, FIELDDATA is an UTF-8 encoded string
#   * 0006: UserName string, FIELDDATA is an UTF-8 encoded string
#   * 0007: Password string, FIELDDATA is an UTF-8 encoded string
#   * 0008: Notes string, FIELDDATA is an UTF-8 encoded string
#   * 0009: Creation time, FIELDSIZE = 5, FIELDDATA = packed date/time
#   * 000A: Last modification time, FIELDSIZE = 5, FIELDDATA = packed date/time
#   * 000B: Last access time, FIELDSIZE = 5, FIELDDATA = packed date/time
#   * 000C: Expiration time, FIELDSIZE = 5, FIELDDATA = packed date/time
#   * 000D: Binary description UTF-8 encoded string
#   * 000E: Binary data
#   * FFFF: Entry terminator, FIELDSIZE must be 0
#   '''

class Entry
  def self.extract_from_payload(header, payload_io)
    groups = []
    header.nentries.times do
      group = Entry.new(payload_io)
      groups << group
    end
    groups
  end

  attr_reader :fields

  def initialize(payload_io)
    fields = []
    begin
      field = EntryField.new(payload_io)
      fields << field
    end while not field.terminator?

    @fields = fields
  end

  def length
    @fields.map(&:length).reduce(&:+)
  end

  def notes
    @fields.detect { |field| field.name == 'notes' }.data
  end

  def password
    @fields.detect { |field| field.name == 'password' }.data.chomp("\000")
  end

  def title
    @fields.detect { |field| field.name == 'title' }.data.chomp("\000")
  end

  def username
    @fields.detect { |field| field.name == 'username' }.data
  end
end

class EntryField
   FIELD_TYPES = [
     [0x0, 'ignored', :null],
     [0x1, 'uuid', :ascii],
     [0x2, 'groupid', :int],
     [0x3, 'imageid', :int],
     [0x4, 'title', :string],
     [0x5, 'url', :string],
     [0x6, 'username', :string],
     [0x7, 'password', :string],
     [0x8, 'notes', :string],
     [0x9, 'creation_time', :date],
     [0xa, 'last_mod_time', :date],
     [0xb, 'last_acc_time', :date],
     [0xc, 'expiration_time', :date],
     [0xd, 'binary_desc', :string],
     [0xe, 'binary_data', :shunt],
     [0xFFFF, 'terminator', :nil]
  ]
  FIELD_TERMINATOR = 0xFFFF
  TYPE_CODE_FIELD_SIZE = 2   # unsigned short integer
  DATA_LENGTH_FIELD_SIZE = 4 # unsigned integer


  attr_reader :name, :data_type, :data

  def initialize(payload)
    type_code, @data_length = payload.read(TYPE_CODE_FIELD_SIZE + DATA_LENGTH_FIELD_SIZE).unpack('SI')
    @name, @data_type = _parse_type_code(type_code)
    @data = payload.read(@data_length)
  end

  def terminator?
    name == 'terminator'
  end

  def length
    TYPE_CODE_FIELD_SIZE + DATA_LENGTH_FIELD_SIZE + @data_length
  end

  def _parse_type_code(type_code)
    (_, name, data_type) = FIELD_TYPES.detect do |(code, *rest)|
      code == type_code
    end
    [name, data_type]
  end
end
