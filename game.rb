
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
    puts '  Как я могу обращаться к Вам ?'
    print '  '
    self.player = Player.new(gets.strip)
  rescue StandardError
    retry
  end

  def start
    puts
    puts '  Добро пожаловать за стол игры в Чёрного Джека!'
    puts "  Меня зовут #{dealer.name.inspect}."
    set_player
    loop do
      puts
      puts "  #{player}, хотите сыграть круг на #{STAKE} фишек ?"
      puts '  Да/Нет == Yes/No'
      print '  '
      response = gets.strip.capitalize[0].to_sym
      if %i[Д Y].include?(response)
        player.balance = STAKE
        dealer.balance = STAKE
        play_rounds
      elsif %i[Н N].include?(response)
        break
      end
    end
    puts
    puts "  До свидания, #{player}!"
    puts
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
      puts
      puts "  Раунд #{i += 1}."
      puts "  В банке #{bank} фишек."
      res = take_cards
      puts
      if res.zero?
        puts '  Ничья: банк пополам.'
        player.balance += bank / 2
        dealer.balance += bank / 2
      elsif res.positive?
        puts "  #{player} выиграл банк."
        player.balance += bank
      else
        puts "  #{dealer} выиграл банк."
        dealer.balance += bank
      end
      puts
      puts "  #{player}: #{player.balance} фишек."
      puts "  #{dealer}: #{dealer.balance} фишек."
    end
    puts
    if player.balance.zero?
      puts '  В следующий раз больше повезёт.'
    else
      puts "  Поздравляю, #{player}, #{2 * STAKE} фишек ваши!"
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
    puts
    puts "  Карты дилера:  #{dealer.show_suits}"
    puts "    Ваши карты:  #{player.show_cards}  Сумма: #{player.max_value}"
    puts
    puts '  Ваше действие:'
    puts '   1 - добавить ещё карту'
    puts '   9 - открыть карты'
    puts '   либой другой символ - пропустить ход'
    print '   '
    case gets.strip[0]
    when '1' then player.add_card(deck.deal)
    when '9' then return showdown
    end
    flag = false
    if dealer.has_ace?
      flag = true if dealer.max_value <= 17
    else
      flag = true if dealer.max_value <= 15
    end
    if flag
      dealer.add_card(deck.deal)
      puts
      puts '  Дилер взял карту.'
    end
    puts
    puts "  Карты дилера:  #{dealer.show_suits}"
    puts "    Ваши карты:  #{player.show_cards}  Сумма: #{player.max_value}"
    puts
    puts '  Ваше действие:'
    puts '   1 - добавить ещё карту'
    puts '   либой другой символ - открыть карты'
    print '   '
    player.add_card(deck.deal) if gets.strip[0] == '1'
    showdown
  end

  def showdown
    player_val = player.max_value
    dealer_val = dealer.max_value
    puts
    puts "  Карты дилера:  #{dealer.show_cards}  Сумма: #{dealer_val}"
    puts "    Ваши карты:  #{player.show_cards}  Сумма: #{player_val}"
    player_val = 22 if player_val > 21
    dealer_val = 22 if dealer_val > 21
    return 0 if player_val == dealer_val
    return +1 if dealer_val == 22
    return -1 if player_val == 22
    return +1 if player_val > dealer_val
    -1
  end
end
