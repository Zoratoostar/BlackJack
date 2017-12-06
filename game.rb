
class Game
  DEALERS = %w[Билли Стиви Ларри Салли Бадди Майки Томми]
  STAKE = 100

  attr_reader :dealer
  attr_accessor :bank, :player

  def initialize
    @bank = 0
    @dealer = Player.new(DEALERS[rand(DEALERS.size)], STAKE)
  end

  def set_player
    puts '  Как я могу обращаться к Вам ?'
    print '  '
    self.player = Player.new(gets.strip, STAKE)
  rescue StandardError
    retry
  end

  def start
    puts '  Добро пожаловать за стол игры в Чёрного Джека!'
    puts "  Меня зовут #{dealer.name.inspect}"
    set_player
    loop do
      puts "  #{player.name}, хотите сыграть круг на #{STAKE} фишек ?"
      puts '  Да/Нет == Yes/No'
      print '  '
      response = gets.strip.capitalize[0].to_sym
      if %i[Д Y].include?(response)
        play_round
      elsif %i[Н N].include?(response)
        break
      end
    end
    puts "  #{player.name}, до свидания!"
  end

  def play_round
  end
end
