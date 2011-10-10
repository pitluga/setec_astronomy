require 'setec_astronomy'
require 'setec_astronomy/prompt'

require 'thor'
require 'clipboard'

module SetecAstronomy
  class CLI < Thor
    desc "search PATTERN", "searches the database for entries matching the pattern"
    method_option :file, :type => :string, :required => true, :aliases => '-f'
    method_option :gui, :type => :boolean, :aliases => '-g'
    def search(pattern)
      keepass = database(options[:file], options[:gui])
      keepass.search(pattern).each do |match|
        puts "#{match.title} - #{match.notes}"
      end
    end

    desc "copy ENTRY", "copies the password for the given entry to the system clipboard"
    method_option :file, :type => :string, :required => true, :aliases => '-f'
    method_option :gui, :type => :boolean, :aliases => '-g'
    def copy(title)
      keepass = database(options[:file], options[:gui])
      entry = keepass.entry(title)
      resign("#{title} not found") if entry.nil?
      Clipboard.copy entry.password
    end

    no_tasks do
      def database(file, gui=false)
        db = KeePass::Database.open(file)
        password = gui ? Prompt.ask_password_gui : Prompt.ask_password_console
        resign("Unable to unlock database... exiting") unless db.unlock password
        db
      end

      def resign(error)
        puts error
        exit 1
      end
    end
  end
end
