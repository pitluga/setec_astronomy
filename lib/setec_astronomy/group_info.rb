# One group: [FIELDTYPE(FT)][FIELDSIZE(FS)][FIELDDATA(FD)]
#            [FT+FS+(FD)][FT+FS+(FD)][FT+FS+(FD)][FT+FS+(FD)][FT+FS+(FD)]...
# 
# [ 2 bytes] FIELDTYPE
# [ 4 bytes] FIELDSIZE, size of FIELDDATA in bytes
# [ n bytes] FIELDDATA, n = FIELDSIZE
# 
# Notes:
# - Strings are stored in UTF-8 encoded form and are null-terminated.
# - FIELDTYPE can be one of the following identifiers:
#   * 0000: Invalid or comment block, block is ignored
#   * 0001: Group ID, FIELDSIZE must be 4 bytes
#           It can be any 32-bit value except 0 and 0xFFFFFFFF
#   * 0002: Group name, FIELDDATA is an UTF-8 encoded string
#   * 0003: Creation time, FIELDSIZE = 5, FIELDDATA = packed date/time
#   * 0004: Last modification time, FIELDSIZE = 5, FIELDDATA = packed date/time
#   * 0005: Last access time, FIELDSIZE = 5, FIELDDATA = packed date/time
#   * 0006: Expiration time, FIELDSIZE = 5, FIELDDATA = packed date/time
#   * 0007: Image ID, FIELDSIZE must be 4 bytes
#   * 0008: Level, FIELDSIZE = 2
#   * 0009: Flags, 32-bit value, FIELDSIZE = 4
#   * FFFF: Group entry terminator, FIELDSIZE must be 0
class GroupInfo
  FIELD_TYPES = [
    [0x0, 'ignored', :null],
    [0x1, 'groupid', :int],
    [0x2, 'group_name', :string],
    [0x3, 'creation_time', :date],
    [0x4, 'lastmod_time', :date],
    [0x5, 'lastacc_time', :date],
    [0x6, 'expire_time', :date],
    [0x7, 'imageid', :int],
    [0x8, 'level', :short],
    [0x9, 'flags', :int]
  ]

  def self.extract_from_payload(header, payload)
    
  end

  def initialize(payload)
  end
end
