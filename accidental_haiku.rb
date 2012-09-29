class AccidentalHaiku
  include Cinch::Plugin

  match 'hello'

  def execute(message)
    message.reply "Hello, #{message.user.nick}"
  end
end
