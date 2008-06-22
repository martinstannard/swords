require 'yaml'
module Swords
  class Dictionary
    attr_accessor :dict, :dict_words, :used_words

    def initialize
      @dict = YAML.load_file(File.dirname(__FILE__) + '/../../yaml/dictionary.yml')
      reset
    end

    def reset
      @dict_words = @dict.keys.sort_by {rand}
      @used_words = { :horizontal  =>  [], :vertical  =>  [] }
    end

    def find_word(pattern, coord, length, dir, requested_words)
      word = find_word_from_dict(pattern, coord, length, requested_words, dir)
      find_word_from_dict(pattern, coord, length, @dict_words, dir) unless word
    end

    def get_clue_for_word(word, number = 2)
      return "" unless word
      # the synonymns get discarded in the while loop
      clueline = @dict[word]["si"]
      synonyms = clueline != nil ? clueline.split(", ") : "No clue for you!"
      clues = {}
      while clues.size < number && synonyms.size > 0
        clue = synonyms[rand*10 % synonyms.length]
        synonyms.delete(clue) # ensures we exit
        if clue[word] == nil && !clues[clue]
          clues[clue] = true
        end
      end
      clues.keys.join ", "
    end

    def find_word_from_dict(pattern, coord, length, word_list, dir)
      word_list.each do |l|
        line = l.to_s.strip
        next unless line.size == length
        r = Regexp.new(pattern)
        md = line.match(r)
        if !md.nil? && !@used_words[dir].include?(line) && !line.match(/[A-Z]/)
          word = Word.new(line, coord[0], coord[1], dir, get_clue_for_word(line)) 
          @used_words[dir] << line
          return word
        end
      end
      nil
    end
  end


end
