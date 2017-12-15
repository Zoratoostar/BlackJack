
class Interface
  attr_reader :dealer
  attr_accessor :player, :bank, :deck

  def initialize
    dealers = Game::DEALERS
    @dealer = Player.new(dealers[rand(dealers.size)])
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
      puts "  #{player}, хотите сыграть круг на #{Game::STAKE} фишек ?"
      puts '  Да/Нет == Yes/No'
      print '  '
      response = gets.strip.capitalize[0].to_sym
      if %i[Д Y].include?(response)
        player.balance = Game::STAKE
        dealer.balance = Game::STAKE
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
      bet = Game::BET
      if lesser >= bet
        player.balance -= bet
        dealer.balance -= bet
        self.bank = 2 * bet
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
      puts "  Поздравляю, #{player}, #{2 * Game::STAKE} фишек ваши!"
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
    puts
    if Game.take_card?(dealer.has_ace?, dealer.max_value)
      dealer.add_card(deck.deal)
      puts '  Дилер взял карту.'
    else
      puts '  Дилер пропустил ход.'
    end
    if player.cards_count == 2
      if dealer.cards_count == 3
        puts
        puts "  Карты дилера:  #{dealer.show_suits}"
      end
      puts
      puts '  Ваше действие:'
      puts '   1 - добавить ещё карту'
      puts '   либой другой символ - открыть карты'
      print '   '
      player.add_card(deck.deal) if gets.strip[0] == '1'
    end
    showdown
  end

  def showdown
    player_val = player.max_value
    dealer_val = dealer.max_value
    puts
    puts "  Карты дилера:  #{dealer.show_cards}  Сумма: #{dealer_val}"
    puts "    Ваши карты:  #{player.show_cards}  Сумма: #{player_val}"
    Game.compare(player_val, dealer_val)
  end
end
