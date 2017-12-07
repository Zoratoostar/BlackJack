
class Player
  include Validation

  attr_accessor :name, :balance
  attr_reader :cards, :value

  validate :name, :presence
  validate :name, :format, /[А-Яa-z\d]{3,}/i
  validate :balance, :type, Integer

  def initialize(name)
    @name = name
    @balance = 0
    validate!
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

  def to_s
    name
  end

  def show_cards
    cards.join
  end
end
