
class Player
  include Validation

  attr_accessor :name, :balance
  attr_reader :cards, :value

  validate :name, :presence
  validate :name, :mode, /[А-Яa-z\d]{3,}/i
  validate :balance, :type, Integer

  def initialize(name, balance)
    @name = name
    @balance = balance
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
end
