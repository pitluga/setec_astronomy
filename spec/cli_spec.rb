require 'spec_helper'
require 'setec_astronomy/cli'
require 'pty'
require 'expect'

describe "Command Line" do
  def setec(options, master_password = nil)
    bin = File.expand_path('../../bin/setec', __FILE__)
    cmd = "#{bin} #{options} --file=#{TEST_DATABASE_PATH}"
    output = ''
    PTY.spawn cmd do |reader, writer, pid|
      reader.expect("Password:") do
        unless master_password.nil?
          writer.puts master_password
          reader.gets
        end
      end
      until reader.eof?
        output << reader.gets
      end
    end
    output
  end

  describe "search" do
    it "lists the entries that contain the given text" do
      output = setec 'search test', "testmasterpassword"
      output.should include("test entry")
    end
  end

  describe "copy" do
    it "copies the given password to the system clipboard" do
      setec 'copy "test entry"', "testmasterpassword"
      Clipboard.paste.should == "testpassword"
    end
  end
end
