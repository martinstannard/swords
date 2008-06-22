require 'rubygems'
Dir.glob(File.join(File.dirname(__FILE__), "swords", "*.rb")).each { |f| require f }

module Swords
  VERSION = "0.0.1"
end
