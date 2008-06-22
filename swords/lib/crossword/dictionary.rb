module Crossword
  class Dictionary
    attr_accessor :dict, :dict_words, :used_words
    
    def initialize
      @dict = YAML.load_file(File.dirname(__FILE__) + '/../yaml/dictionary.yml')
      @dict_words = @dict.keys.sort_by {rand}
      @used_words = { :horizontal  =>  [], :vertical  =>  [] }
    end
    
    def find_word(pattern, coord, length, dir, requested_words)
      word = find_word_from_dict(pattern, coord, length, requested_words, dir)
      find_word_from_dict(pattern, coord, length, @dict_words, dir) unless word
    end
    
    def find_word_from_dict(pattern, coord, length, word_list, dir)
      word_list.each do |l|
        line = l.to_s.strip
        next unless line.size == length
        r = Regexp.new(pattern)
        md = line.match(r)
        if !md.nil? && !@used_words[dir].include?(line) && !line.match(/[A-Z]/)
          @used_words[dir] << line
          return line
        end
      end
      nil
    end
  end
end
