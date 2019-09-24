spec = Gem::Specification.new do |s|
  s.name = 'rack-deadline'
  s.version = '1.0.1'
  s.platform = Gem::Platform::RUBY
  s.extra_rdoc_files = ["README.rdoc", "CHANGELOG", "MIT-LICENSE"]
  s.rdoc_options += ["--quiet", "--line-numbers", "--inline-source", '--title', 'Rack::Session::Deadline: Automatically clears sessions open too long', '--main', 'README.rdoc']
  s.license = "MIT"
  s.summary = "Automatically clears sessions open too long"
  s.author = "Jeremy Evans"
  s.email = "code@jeremyevans.net"
  s.homepage = "http://github.com/jeremyevans/rack-deadline"
  s.files = %w(MIT-LICENSE CHANGELOG README.rdoc Rakefile) + Dir["{lib,test}/**/*.rb"]
  s.description = <<END
rack-deadline is a simple rack middleware that automatically
clears sessions that have been open too long (by default,
1 day).

This is designed for use with cookie stores to mitigate the
risk of session fixation, since it is impossible to invalidate
older sessions with a pure cookie-based approach.

It is impossible to enforce a deadline with the standard rack
cookie session API. The expire_after setting is not part of the
session itself (it's part of the cookie, and not cryptographically
signed), and an attacker who has access to a previous cookie can
just omit it when making a request.

This stores a deadline inside the crytographically signed session,
and once the deadline is passed, the session will no longer be valid.
END
  s.add_development_dependency "minitest-global_expectations"
end
