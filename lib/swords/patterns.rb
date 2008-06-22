module Swords
  class Pattern
    def self.random
      Patterns.first
    end
  end
end

Patterns = [
            [ 
              'xxxxx ',
              ' x  x ',
              ' x  x ',
              ' x  x ',
              ' x  x ',
              ' xxxxx'
            ],
            [ 
              '  xxxx',
              ' x  x ',
              ' x  x ',
              ' x  x ',
              ' x  x ',
              'xxxx  '
            ],
            [ 
              ' x   x ',
              'xxxxxxx',
              ' x   x ',
              ' x   x ',
              'xxxxxxx',
              ' x   x '
            ]
            ]

# [
#   'xxxxxxx xxxxxxx',
#   ' x x x x x x x ',
#   'xxxxxxxxxx xxxx',
#   ' x x x x x x x ',
#   'xxxxxxxxxxxxxxx',
#   ' x   x x x x x ',
#   'xxxxxxxxx xxxxx',
#   '   x x x x x   ',
#   'xxxxx xxxxxxxxx',
#   ' x x x x x   x ',
#   'xxxxxxxxxxxxxxx',
#   ' x x x x x x x ',
#   'xxxx xxxxxxxxxx',
#   ' x x x x x x x ',
#   'xxxxxxx xxxxxxx'
# ]