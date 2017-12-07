
module PlayingCards
  RANKS = %i[2 3 4 5 6 7 8 9 10 J Q K A]
  SUITS = %i[c d h s]
  RANK_VALUES = {
    '2': 2, '3': 3, '4': 4, '5': 5,
    '6': 6, '7': 7, '8': 8, '9': 9,
    '10': 10, J: 10, Q: 10, K: 10, A: 1
  }

  class Deck
    def initialize
      @cards = []
      RANKS.each do |rank|
        SUITS.each do |suit|
          @cards << [rank, suit]
        end
      end
      @cards.shuffle!
    end

    def deal
      @cards.pop
    end

    def size
      @cards.size
    end
  end

  def card_value(card)
    RANK_VALUES.fetch(card.first)
  end
end
