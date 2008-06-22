module Swords
  class Pattern
    attr_accessor :patterns

    def self.random
      patterns = new
      patterns.read
      patterns.patterns.sort_by {rand}.first[1]
    end

    def read
      @patterns, count = {}, 0
      File.readlines(File.dirname(__FILE__) + '/../../patterns/default.txt').each do |line|
        count += 1 and next if line.strip.empty?
        @patterns["#{count}"] ||= []
        @patterns["#{count}"] << line[0..-2]
      end
    end
  end
end
