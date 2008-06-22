require "date"
require "fileutils"
require "rubygems"
require "rake/gempackagetask"
require "spec/rake/spectask"

require "./lib/swords"

swords_gemspec = Gem::Specification.new do |s|
  s.name             = "swords"
  s.version          = Swords::VERSION
  s.platform         = Gem::Platform::RUBY
  s.has_rdoc         = true
  s.extra_rdoc_files = ["README"]
  s.summary          = "SWORE-DS, dual the computer in a challenging game of words."
  s.description      = s.summary
  s.authors          = ["Ron Jeremy", "Martin Stannard", "Nick Pellow", "Dylan Fogarty-MacDonald", "Michael Koukoullis"].sort
  s.email            = "swords@swords.com"
  s.homepage         = "http://swords.com"
  s.require_path     = "lib"
  s.autorequire      = "swords"
  s.files            = %w(README Rakefile) + Dir.glob("{bin,lib,patterns,spec,yaml}/**/*")
  s.executables      = %w(swords)
end

Rake::GemPackageTask.new(swords_gemspec) do |pkg|
  pkg.gem_spec = swords_gemspec
end

namespace :gem do
  namespace :spec do
    desc "Update swords.gemspec"
    task :generate do
      File.open("swords.gemspec", "w") do |f|
        f.puts(swords_gemspec.to_ruby)
      end
    end
    
    desc "test spec in github cleanroom"
    task :test do
      require 'rubygems/specification'
      data = File.read('swords.gemspec')
      spec = nil
      Thread.new { spec = eval("$SAFE = 3\n#{data}") }.join
      puts spec
    end
  end
end

task :install => :package do
  sh %{sudo gem install pkg/swords-#{Swords::VERSION}}
end

desc "Remove all generated artifacts"
task :clean => :clobber_package
