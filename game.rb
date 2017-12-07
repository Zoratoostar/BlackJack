
class Game
  DEALERS = %w[Билли Стиви Ларри Салли Бадди Майки Томми]
  STAKE = 100
  BET = 10

  attr_reader :dealer
  attr_accessor :player, :bank, :deck

  def initialize
    @dealer = Player.new(DEALERS[rand(DEALERS.size)])
    @bank = 0
  end

  def set_player
    puts '  Как я могу обращаться к Вам ?'
    print '  '
    self.player = Player.new(gets.strip)
  rescue StandardError
    retry
  end

  def start
    puts '  Добро пожаловать за стол игры в Чёрного Джека!'
    puts "  Меня зовут #{dealer.name.inspect}"
    set_player
    loop do
      puts "  #{player}, хотите сыграть круг на #{STAKE} фишек ?"
      puts '  Да/Нет == Yes/No'
      print '  '
      response = gets.strip.capitalize[0].to_sym
      if %i[Д Y].include?(response)
        player.balance = STAKE
        dealer.balance = STAKE
        play_round
      elsif %i[Н N].include?(response)
        break
      end
    end
    puts "  До свидания, #{player}!"
  end

  def play_round
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
      puts "  В банке #{bank} фишек."
      res = take_cards
      if res.zero?
        player.balance += bank / 2
        dealer.balance += bank / 2
      elsif res.positive?
        player.balance += bank
      else
        dealer.balance += bank
      end
      puts "  #{player}: #{player.balance} фишек."
      puts "  #{dealer}: #{dealer.balance} фишек."
    end
    if player.balance.zero?
      puts '  В следующий раз больше повезёт.'
    else
      puts "  Поздравляю, #{player}, #{2 * STAKE} фишек ваши!"
    end
  end

  def take_cards

  end
end
