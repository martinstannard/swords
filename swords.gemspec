Gem::Specification.new do |s|
  s.name = %q{swords}
  s.version = "0.0.1"

  s.specification_version = 2 if s.respond_to? :specification_version=

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Dylan Fogarty-MacDonald", "Martin Stannard", "Michael Koukoullis", "Nick Pellow", "Ron Jeremy"]
  s.autorequire = %q{swords}
  s.date = %q{2008-06-22}
  s.default_executable = %q{swords}
  s.description = %q{SWORE-DS, dual the computer in a challenging game of words.}
  s.email = %q{swords@swords.com}
  s.executables = ["swords"]
  s.extra_rdoc_files = ["README"]
  s.files = ["README", "Rakefile", "bin/swords", "lib/swords", "lib/swords/cli.rb", "lib/swords/crossworder.rb", "lib/swords/dictionary.rb", "lib/swords/grid.rb", "lib/swords/parser.rb", "lib/swords/patterns.rb", "lib/swords/word.rb", "lib/swords.rb", "patterns/default.txt", "yaml/dictionary.yml"]
  s.has_rdoc = true
  s.homepage = %q{http://swords.com}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.1.1}
  s.summary = %q{SWORE-DS, dual the computer in a challenging game of words.}
end
