Gem::Specification.new do |s|
  s.name = "setec_astronomy"
  s.summary = "Command line and API access to KeePassX databases"
  s.description = "See http://github.com/pitluga/setec_astronomy"
  s.version = "0.2.0"
  s.author = "Tony Pitluga"
  s.email = "tony.pitluga@gmail.com"
  s.homepage = "http://github.com/pitluga/supply_drop"
  s.files = `git ls-files`.split("\n")
  s.bindir = "bin"
  s.executables = ["setec"]

  s.add_dependency "clipboard", "~> 0.9"
  s.add_dependency "fast-aes", "~> 0.1"
  s.add_dependency "highline", "~> 1.6"
  s.add_dependency "thor", "~> 0.14"

  s.add_development_dependency "rspec", "2.6.0"
end
