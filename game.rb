
module Game
  DEALERS = %w[Билли Стиви Ларри Салли Бадди Майки Томми].freeze
  STAKE = 25
  BET = 10

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
end
