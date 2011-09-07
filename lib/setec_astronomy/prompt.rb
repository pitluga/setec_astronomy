module Prompt
  def self.ask_password(prompt)
    ask("Password: ") { |q| q.echo = false }
  end
end
