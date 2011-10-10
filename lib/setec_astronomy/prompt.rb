require 'highline/import'

module Prompt
  def self.ask_password_console
    ask("Password: ") { |q| q.echo = false }
  end

  def self.ask_password_gui
    `#{_password_dialog_actionscript}`.chomp
  end

  def self._password_dialog_actionscript
    <<-APPLESCRIPT.gsub(/^ */, '')
      /usr/bin/osascript <<EOT
      tell application "Finder"
          activate
          set output to text returned of ( \
            display dialog "Enter your master password:" \
            with title "KeePass Database Master Password" \
            default answer "" \
            with hidden answer \
            with icon (path to "apps") as Unicode text & "Utilities:Keychain Access.app:Contents:Resources:Keychain.icns" as alias \
          )
      end tell
      EOT
    APPLESCRIPT
  end
end
