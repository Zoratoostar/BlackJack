
class Game
  DEALERS = %w[Билли Стиви Ларри Салли Бадди Майки Томми].freeze
  STAKE = 25
  BET = 10

  attr_reader :dealer
  attr_accessor :player, :bank, :deck

  class << self
    def take_card?(have_ace, max_val)
      flag = false
      if have_ace
        flag = true if max_val <= 17
      else
        flag = true if max_val <= 15
      end
      flag
    end

    def compare(player_val, dealer_val)
      player_val = 22 if player_val > 21
      dealer_val = 22 if dealer_val > 21
      return 0 if player_val == dealer_val
      return +1 if dealer_val == 22
      return -1 if player_val == 22
      return +1 if player_val > dealer_val
      -1
    end
  end

  def initialize
    @dealer = Player.new(DEALERS[rand(DEALERS.size)])
    @bank = 0
  end

  def issue_stakes
    player.balance = STAKE
    dealer.balance = STAKE
  end

  def zero_balance?
    player.balance.zero? || dealer.balance.zero?
  end

  def make_bank
    lesser = [player.balance, dealer.balance].min
    if lesser >= BET
      player.balance -= BET
      dealer.balance -= BET
      self.bank = 2 * BET
    else
      player.balance -= lesser
      dealer.balance -= lesser
      self.bank = 2 * lesser
    end
  end

  def split_bank
    player.balance += bank / 2
    dealer.balance += bank / 2
  end

  def take_bank(player)
    player.balance += bank
  end

  def initial_cards
    self.deck = PlayingCards::Deck.new
    player.reset
    dealer.reset
    2.times do
      player.add_card(deck.deal)
      dealer.add_card(deck.deal)
    end
  end
end
