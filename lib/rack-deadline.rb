require 'rack/session/abstract/id'

# Rack middleware that automatically clears sessions that are open too long.
# This is designed to mitigate session fixation attacks in pure cookie-based
# session storage.
class Rack::Session::Deadline
  ENV_KEY = 'rack.session'.freeze
  DEFAULT_KEY = '_deadline'.freeze
  DEFAULT_DEADLINE = 86400

  # Configure the middleware with the given options:
  # :deadline :: The maximum number of seconds a session can be open.
  # :key :: the key in the session hash in which to store the deadline.
  def initialize(app, opts={})
    @app = app
    @deadline = opts[:deadline] || DEFAULT_DEADLINE
    @key = opts[:key] || DEFAULT_KEY
    @time_class = opts[:time_class] || Time
  end

  # Before calling the app, clears the session if it has passed the deadline.
  # After calling the app, set the deadline in the session if it hasn't been set yet.
  def call(env)
    if (session = env[ENV_KEY]) && (!session.has_key?(@key) || session[@key] < @time_class.now.to_i)
      session.clear
    end
    res = @app.call(env)
    if session
      session[@key] ||= @time_class.now.to_i + @deadline
    end
    res
  end
end
