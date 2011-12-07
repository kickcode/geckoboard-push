require "rubygems"
require "rubygems/package_task"
require "rdoc/task"

require "rake/testtask"
Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList["test/**/*_test.rb"]
  t.verbose = true
end

task :default => ["test"]

spec = Gem::Specification.new do |s|

  s.name              = "geckoboard-push"
  s.version           = "0.1.0"
  s.summary           = "Ruby library for pushing widget updates to Geckoboard."
  s.author            = "Elliott Draper"
  s.email             = "el@kickcode.com"
  s.homepage          = "http://docs.geckoboard.com/api/push.html"

  s.has_rdoc          = true
  s.extra_rdoc_files  = %w(README.rdoc)
  s.rdoc_options      = %w(--main README.rdoc)

  s.files             = %w(README.rdoc) + Dir.glob("{test,lib}/**/*")
  s.require_paths     = ["lib"]

  s.add_dependency "httparty", "~> 0.8.1"

  s.add_development_dependency "fakeweb", "~> 1.3.0"
  s.add_development_dependency "mocha", "~> 0.10.0"
end

Gem::PackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec
end

desc "Build the gemspec file #{spec.name}.gemspec"
task :gemspec do
  file = File.dirname(__FILE__) + "/#{spec.name}.gemspec"
  File.open(file, "w") {|f| f << spec.to_ruby }
end

task :package => :gemspec

# Generate documentation
RDoc::Task.new do |rd|
  
  rd.rdoc_files.include("lib/**/*.rb")
  rd.rdoc_dir = "rdoc"
end

desc 'Clear out RDoc and generated packages'
task :clean => [:clobber_rdoc, :clobber_package] do
  rm "#{spec.name}.gemspec"
end
