require 'spec_helper'
require 'clipboard'

describe "Command Line" do
  def setec(options, master_password = nil)
    bin = File.expand_path('../../bin/setec', __FILE__)
    auth = master_password.nil? ? "" : "echo #{master_password} | "
    `#{auth} #{bin} #{options} --file=#{TEST_DATABASE_PATH}`
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
