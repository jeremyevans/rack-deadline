require "rake"
require "rake/clean"

CLEAN.include ["rack-deadline-*.gem", "rdoc", "coverage"]

desc "Build rack-deadline gem"
task :package=>[:clean] do |p|
  sh %{#{FileUtils::RUBY} -S gem build rack-deadline.gemspec}
end

### Tests

desc "Run specs"
task :spec do
  sh "#{FileUtils::RUBY} -rubygems -I lib test/rack-deadline_test.rb"
end

task :default => :spec

### RDoc

RDOC_DEFAULT_OPTS = ["--quiet", "--line-numbers", "--inline-source", '--title', 'Rack::Session::Deadline: Automatically clears sessions open too long']

begin
  gem 'rdoc', '= 3.12.2'
  gem 'hanna-nouveau'
  RDOC_DEFAULT_OPTS.concat(['-f', 'hanna'])
rescue Gem::LoadError
end

rdoc_task_class = begin
  require "rdoc/task"
  RDoc::Task
rescue LoadError
  require "rake/rdoctask"
  Rake::RDocTask
end

RDOC_OPTS = RDOC_DEFAULT_OPTS + ['--main', 'README.rdoc']

rdoc_task_class.new do |rdoc|
  rdoc.rdoc_dir = "rdoc"
  rdoc.options += RDOC_OPTS
  rdoc.rdoc_files.add %w"README.rdoc CHANGELOG MIT-LICENSE lib/**/*.rb"
end

