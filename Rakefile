require 'rake/testtask'

task :default => :test

task :package
task "package:clean"

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  # disable output - warning: assigned but unused variable
  t.warning = true
  t.verbose = false
  t.ruby_opts = ["--dev"] if defined?(JRUBY_VERSION)
end

namespace :test do
  task :isolated do
    Dir.glob("test/**/*_test.rb").all? do |file|
      sh(Gem.ruby, '-w', '-Ilib:test', file)
    end or raise "Failures"
  end
end
