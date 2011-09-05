$:.unshift File.expand_path('./lib/')
require 'pp'
require 'setec_astronomy'

db = KeypassxDatabase.open('/Users/phinze/dev/setec_astronomy/spec/test_database.kdb')
db.unlock('testmasterpassword')
puts "Total Groups: #{db.header.ngroups}"
db.groups.each do |group|
  puts " - #{group.name}"
end
db.entries.each do |entry|
  print entry.password
end
print 'DONE'
