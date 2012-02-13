require 'spec_helper'

describe SetecAstronomy::KeePass::Database do
  describe 'self.open' do
    it "creates a new instance of the databse with the file" do
      db = SetecAstronomy::KeePass::Database.open(TEST_DATABASE_PATH)
      db.should_not be_nil
    end
  end

  describe "unlock" do
    before :each do
      @db = SetecAstronomy::KeePass::Database.open(TEST_DATABASE_PATH)
      @db.should be_valid
    end

    it "returns true when the master password is correct" do
      @db.unlock('testmasterpassword').should be_true
    end

    it "returns false when the master password is incorrect" do
      @db.unlock('bad password').should be_false
    end
  end

  describe "an unlocked database" do
    before :each do
      @db = SetecAstronomy::KeePass::Database.open(TEST_DATABASE_PATH)
      @db.unlock('testmasterpassword')
    end

    it "can find entries by their title" do
      @db.entry("test entry").password.should == "testpassword"
    end

    it "can find groups" do
      @db.groups.map(&:name).sort.should == ["Internet", "eMail"]
    end

    it "can search for entries" do
      entries = @db.search "test"
      entries.first.title.should == "test entry"
    end

    it "can search for entries case-insensitively" do
      entries = @db.search "TEST"
      entries.first.title.should == "test entry"
    end
  end
end
