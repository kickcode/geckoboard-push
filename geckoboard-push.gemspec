# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{geckoboard-push}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Elliott Draper"]
  s.date = %q{2011-12-08}
  s.email = %q{el@kickcode.com}
  s.extra_rdoc_files = ["README.rdoc"]
  s.files = ["README.rdoc", "test/geckoboard/push_test.rb", "lib/geckoboard/push.rb", "lib/geckoboard-push.rb"]
  s.homepage = %q{http://docs.geckoboard.com/api/push.html}
  s.rdoc_options = ["--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Ruby library for pushing widget updates to Geckoboard.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<httparty>, ["~> 0.8.1"])
      s.add_development_dependency(%q<fakeweb>, ["~> 1.3.0"])
      s.add_development_dependency(%q<mocha>, ["~> 0.10.0"])
    else
      s.add_dependency(%q<httparty>, ["~> 0.8.1"])
      s.add_dependency(%q<fakeweb>, ["~> 1.3.0"])
      s.add_dependency(%q<mocha>, ["~> 0.10.0"])
    end
  else
    s.add_dependency(%q<httparty>, ["~> 0.8.1"])
    s.add_dependency(%q<fakeweb>, ["~> 1.3.0"])
    s.add_dependency(%q<mocha>, ["~> 0.10.0"])
  end
end
