require_relative "../res/hang_man_frames"


class GameFrame

    attr_reader :index
    def initialize(game,index = 0)
        @game = game
        @index = index
        @frames = Resources::HANGMANFRAMES        
    end

    def display
        system("clear")
        puts @frames[@index].to_s
        
    end

    def advance
        @index = [@index + 1,@frames.length-1].min
        display 
    end
end


class Game

    attr_reader :win, :bad_guess_index

    def initialize(gf)
        @gf = gf
        @word = File.open("./res/hangman_words.txt").readlines.sample.chomp.split('')
        @guessed_letters = []
        @win = false
        display

    end

    def display
        system("clear")
        p "Ans:\t #{@word.join}" 
        @gf.display
        @answer = @word.map {|letter| @guessed_letters.any?(letter) ? letter : "_" }.join
        puts @answer
        puts "Used letters: #{@guessed_letters.map(&:upcase).join(' ')}"
        check_win
    end

    def add_guess(letter)
        @guessed_letters << letter
        if @word.any?(letter) == false
        @gf.advance
        end
    end
   
    private
    def check_win
        if @answer.split('').any?("_") == false
            puts "Congratulations!"            
            @win = true
        
        elsif @gf.index >= 6
            puts "Sorry, You lose. Answer was #{@word.join}"
            @win = true
        end
        
    end
end
 
a = Game.new(GameFrame.new(self))

while !a.win do
    
    puts "Add a guess:\n"
    
    a.add_guess(gets.chomp.downcase)

    a.display
    
end
puts "Game Over"