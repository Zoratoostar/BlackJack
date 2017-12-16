
class Interface
  attr_reader :game

  def initialize
    @game = Game.new
  end

  def set_player
    puts '  Как я могу обращаться к Вам ?'
    print '  '
    game.player = Player.new(gets.strip)
  rescue StandardError
    retry
  end

  def start
    puts
    puts '  Добро пожаловать за стол игры в Чёрного Джека!'
    puts "  Меня зовут #{game.dealer.name.inspect}."
    set_player
    loop do
      puts
      puts "  #{game.player}, хотите сыграть круг на #{Game::STAKE} фишек ?"
      puts '  Да/Нет == Yes/No'
      print '  '
      response = gets.strip.capitalize[0].to_sym
      if %i[Д Y].include?(response)
        game.issue_stakes
        play_rounds
      elsif %i[Н N].include?(response)
        break
      end
    end
    puts
    puts "  До свидания, #{game.player}!"
    puts
  end

  def play_rounds
    i = 0
    until game.zero_balance?
      game.make_bank
      puts
      puts "  Раунд #{i += 1}."
      puts "  В банке #{game.bank} фишек."
      res = take_cards
      puts
      if res.zero?
        puts '  Ничья: банк пополам.'
        game.split_bank
      elsif res.positive?
        puts "  #{game.player} выиграл банк."
        game.take_bank(game.player)
      else
        puts "  #{game.dealer} выиграл банк."
        game.take_bank(game.dealer)
      end
      puts
      puts "  #{game.player}: #{game.player.balance} фишек."
      puts "  #{game.dealer}: #{game.dealer.balance} фишек."
    end
    puts
    if game.player.balance.zero?
      puts '  В следующий раз больше повезёт.'
    else
      puts "  Поздравляю, #{game.player}, #{2 * Game::STAKE} фишек ваши!"
    end
  end

  def take_cards
    game.initial_cards
    puts
    puts "  Карты дилера:  #{game.dealer.show_suits}"
    puts "    Ваши карты:  #{game.player.show_cards}  Сумма: #{game.player.max_value}"
    puts
    puts '  Ваше действие:'
    puts '   1 - добавить ещё карту'
    puts '   9 - открыть карты'
    puts '   либой другой символ - пропустить ход'
    print '   '
    case gets.strip[0]
    when '1' then game.player.add_card(game.deck.deal)
    when '9' then return showdown
    end
    puts
    if Game.take_card?(game.dealer.has_ace?, game.dealer.max_value)
      game.dealer.add_card(game.deck.deal)
      puts '  Дилер взял карту.'
    else
      puts '  Дилер пропустил ход.'
    end
    if game.player.cards_count == 2
      if game.dealer.cards_count == 3
        puts
        puts "  Карты дилера:  #{game.dealer.show_suits}"
      end
      puts
      puts '  Ваше действие:'
      puts '   1 - добавить ещё карту'
      puts '   либой другой символ - открыть карты'
      print '   '
      game.player.add_card(game.deck.deal) if gets.strip[0] == '1'
    end
    showdown
  end

  def showdown
    player_val = game.player.max_value
    dealer_val = game.dealer.max_value
    puts
    puts "  Карты дилера:  #{game.dealer.show_cards}  Сумма: #{dealer_val}"
    puts "    Ваши карты:  #{game.player.show_cards}  Сумма: #{player_val}"
    Game.compare(player_val, dealer_val)
  end
end
