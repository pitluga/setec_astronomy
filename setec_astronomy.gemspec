Gem::Specification.new do |s|
  s.name = "setec_astronomy"
  s.summary = "Command line and API access to KeePassX databases"
  s.description = "See http://github.com/pitluga/setec_astronomy"
  s.version = "0.3.0"
  s.authors = ["Tony Pitluga", "Paul Hinze"]
  s.email = ["tony.pitluga@gmail.com", "paul.t.hinze@gmail.com"]
  s.homepage = "https://github.com/pitluga/setec_astronomy"
  s.files = `git ls-files`.split("\n")
  s.bindir = "bin"
  s.executables = ["setec"]

  s.add_dependency "clipboard", "~> 0.9"
  s.add_dependency "fast-aes", "~> 0.1"
  s.add_dependency "highline", "~> 1.6"
  s.add_dependency "thor", "~> 0.14"

  s.add_development_dependency "rspec", "2.6.0"
end
