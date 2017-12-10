
class Game
  DEALERS = %w[Билли Стиви Ларри Салли Бадди Майки Томми].freeze
  STAKE = 25
  BET = 10

  attr_reader :dealer
  attr_accessor :player, :bank, :deck

  def initialize
    @dealer = Player.new(DEALERS[rand(DEALERS.size)])
  end

  def set_player
    self.player = Player.new(Interface.set_player)
  rescue StandardError
    retry
  end

  def start
    Interface.greeting(dealer.name.inspect)
    set_player
    loop do
      response = Interface.offer_game(player, STAKE)
      if %w[Д Y].include?(response)
        player.balance = STAKE
        dealer.balance = STAKE
        play_rounds
      elsif %w[Н N].include?(response)
        break
      end
    end
    Interface.bye_bye(player)
  end

  def play_rounds
    i = 0
    until player.balance.zero? || dealer.balance.zero?
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
      Interface.start_round(i += 1, bank)
      res = take_cards
      Interface.blank
      if res.zero?
        Interface.draw
        player.balance += bank / 2
        dealer.balance += bank / 2
      elsif res.positive?
        Interface.show_winner(player)
        player.balance += bank
      else
        Interface.show_winner(dealer)
        dealer.balance += bank
      end
      Interface.show_total(player, dealer)
    end
    Interface.blank
    if player.balance.zero?
      Interface.encourage
    else
      Interface.congratulation(player, STAKE)
    end
  end

  def take_cards
    self.deck = PlayingCards::Deck.new
    player.reset
    dealer.reset
    2.times do
      player.add_card(deck.deal)
      dealer.add_card(deck.deal)
    end
    case Interface.play_first(player, dealer)
    when '1' then player.add_card(deck.deal)
    when '9' then return showdown
    end
    flag = false
    if dealer.has_ace?
      flag = true if dealer.max_value <= 17
    else
      flag = true if dealer.max_value <= 15
    end
    Interface.blank
    if flag
      dealer.add_card(deck.deal)
      Interface.dealer_draws_card
    else
      Interface.dealer_checks
    end
    if player.cards_count == 2
      Interface.show_dealer(dealer.show_suits) if flag
      player.add_card(deck.deal) if Interface.play_second == '1'
    end
    showdown
  end

  def showdown
    player_val = player.max_value
    dealer_val = dealer.max_value
    Interface.showdown(player, player_val, dealer, dealer_val)
    player_val = 22 if player_val > 21
    dealer_val = 22 if dealer_val > 21
    return 0 if player_val == dealer_val
    return +1 if dealer_val == 22
    return -1 if player_val == 22
    return +1 if player_val > dealer_val
    -1
  end
end
