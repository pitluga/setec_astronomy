$:.unshift File.expand_path('./lib/')
require 'pp'
require 'setec_astronomy'

db = SetecAstronomy::KeePass::Database.open(File.expand_path('../spec/test_database.kdb', __FILE__))
db.unlock('testmasterpassword')
puts "Total Groups: #{db.header.ngroups}"
db.groups.each do |group|
  puts " - #{group.name}"
end
puts "Total Entries: #{db.header.nentries}"
db.entries.each do |entry|
  puts " - #{entry.title}: #{entry.username} / #{entry.password} (#{entry.notes})"
end
print 'DONE'
