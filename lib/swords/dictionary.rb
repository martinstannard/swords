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

    def find_word(pattern, vector, dir, requested_words)
      word = find_word_from_dict(pattern, vector, requested_words, dir)
      find_word_from_dict(pattern, vector, @dict_words, dir) unless word
    end

    # Given a word(String), gets a specified max number of clues.
    def get_clue_for_word(word, number = 2)
      return "" unless word
      # the synonymns get discarded in the while loop
      return "No clue for you!" unless @dict[word]
      synonyms = dict[word]["si"].split(", ")
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

    def find_word_from_dict(pattern, vector, word_list, dir)
      word_list.each do |l|
        line = l.to_s.strip
        next unless line.size == vector.length
        r = Regexp.new(pattern)
        md = line.match(r)
        if !md.nil? && !@used_words[dir].include?(line) && !line.match(/[A-Z]/)
          word = Word.new(line, vector.x_pos, vector.y_pos, dir, get_clue_for_word(line)) 
          @used_words[dir] << line
          return word
        end
      end
      nil
    end
  end


end
