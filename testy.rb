$:.unshift File.expand_path('./lib/')
require 'pp'
require 'setec_astronomy'

db = KeypassxDatabase.open('/Users/phinze/dev/setec_astronomy/spec/test_database.kdb')
db.unlock('testmasterpassword')
db.decrypt_payload
p db.header.ngroups
db.groups.each do |group|
  print group.name
end
db.entries.each do |entry|
  print entry.password
end
print 'DONE'
