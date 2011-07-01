require 'setec_astronomy'
require 'thor'

module SetecAstronomy
  class CLI < Thor
    desc "search KEY", "searches the database for the given key"
    def search(key)
      puts "searching homie"
    end
  end
end
