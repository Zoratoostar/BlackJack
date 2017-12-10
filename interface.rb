
module Interface
  class << self
    def set_player
      puts '  Как я могу обращаться к Вам ?'
      print '  '
      gets.strip
    end

    def greeting(dealer)
      puts
      puts '  Добро пожаловать за стол игры в Чёрного Джека!'
      puts "  Меня зовут #{dealer}."
    end

    def offer_game(player, stake)
      puts
      puts "  #{player}, хотите сыграть круг на #{stake} фишек ?"
      puts '  Да/Нет == Yes/No'
      print '  '
      gets.strip.capitalize[0]
    end

    def bye_bye(player)
      puts
      puts "  До свидания, #{player}!"
      puts
    end

    def start_round(number, bank)
      puts
      puts "  Раунд #{number}."
      puts "  В банке #{bank} фишек."
    end

    def blank
      puts
    end

    def draw
      puts '  Ничья: банк пополам.'
    end

    def show_winner(player)
      puts "  #{player} выиграл банк."
    end

    def show_total(player, dealer)
      puts
      puts "  #{player}: #{player.balance} фишек."
      puts "  #{dealer}: #{dealer.balance} фишек."
    end

    def encourage
      puts '  В следующий раз больше повезёт.'
    end

    def congratulation(player, stake)
      puts "  Поздравляю, #{player}, #{2 * stake} фишек ваши!"
    end

    def play_first(player, dealer)
      puts
      puts "  Карты дилера:  #{dealer.show_suits}"
      puts "    Ваши карты:  #{player.show_cards}  Сумма: #{player.max_value}"
      puts
      puts '  Ваше действие:'
      puts '   1 - добавить ещё карту'
      puts '   9 - открыть карты'
      puts '   либой другой символ - пропустить ход'
      print '   '
      gets.strip[0]
    end

    def dealer_draws_card
      puts '  Дилер взял карту.'
    end

    def dealer_checks
      puts '  Дилер пропустил ход.'
    end

    def show_dealer(cards)
      puts
      puts "  Карты дилера:  #{cards}"
    end

    def play_second
      puts
      puts '  Ваше действие:'
      puts '   1 - добавить ещё карту'
      puts '   либой другой символ - открыть карты'
      print '   '
      gets.strip[0]
    end

    def showdown(player, player_val, dealer, dealer_val)
      puts
      puts "  Карты дилера:  #{dealer.show_cards}  Сумма: #{dealer_val}"
      puts "    Ваши карты:  #{player.show_cards}  Сумма: #{player_val}"
    end
  end
end
