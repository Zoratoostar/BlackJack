
class Player
  include Validation

  attr_accessor :name, :balance
  attr_reader :cards, :value
  private :cards, :value

  validate :name, :presence
  validate :name, :format, /[А-Яa-z\d]{3,}/i
  validate :balance, :type, Integer

  def initialize(name)
    @name = name
    @balance = 0
    validate!
  end

  def reset
    @cards = []
    @value = {sum: 0, aces: 0}
  end

  def add_card(card)
    cards << card
    value[:sum] += PlayingCards.card_value(card)
    value[:aces] += 1 if card.first == :A
  end

  def max_value
    max = value.fetch(:sum)
    value.fetch(:aces).times do
      break if max > 11
      max += 10
    end
    max
  end

  def has_ace?
    return false if value.fetch(:aces).zero?
    true
  end

  def cards_count
    cards.size
  end

  def to_s
    name
  end

  def show_cards
    cards.join
  end

  def show_suits
    show_cards.tr('2-9TJQKA', '*')
  end
end
